class Radiosonde::Client
  include Radiosonde::Logger::Helper
  include Radiosonde::Utils

  def initialize(options = {})
    @options = options
    @cloud_watch = AWS::CloudWatch.new
  end

  def export(opts = {})
    exported = nil

    AWS.memoize do
      exported = Radiosonde::Exporter.export(@cloud_watch, @options.merge(opts))
    end

    Radiosonde::DSL.convert(exported, @options.merge(opts))
  end

  def metrics(opts = {})
    namespaces = {}

    AWS.memoize do
      ms = @cloud_watch.metrics

      [:namespace, :metric_name].each do |name|
        if (value = opts[name])
          ms = ms.filter(name.to_s, value)
        end
      end

      ms.sort_by {|m| [m.namespace, m.metric_name] }.each do |m|
        if opts[:with_statistics]
          namespaces[m.namespace] ||= {}
          statistics_ops = {}
          [:start_time, :end_time, :statistics].each do |name|
            statistics_ops[name] = opts[name] if opts[name]
          end
          statistics = m.statistics(statistics_ops)
          namespaces[m.namespace][m.metric_name] = {
            :label => statistics.label,
            :datapoints => statistics.datapoints
          }
        elsif opts[:with_dimensions]
          namespaces[m.namespace] ||= {}
          namespaces[m.namespace][m.metric_name] = m.dimensions
        else
          namespaces[m.namespace] ||= []
          namespaces[m.namespace] << m.metric_name
        end
      end
    end

    return namespaces
  end

  def apply(file)
    AWS.memoize { walk(file) }
  end

  private

  def walk(file)
    dsl = load_file(file)
    dsl_alarms = collect_to_hash(dsl.alarms, :alarm_name)
    aws = Radiosonde::Wrapper.wrap(@cloud_watch, @options)
    aws_alarms = collect_to_hash(aws.alarms, :alarm_name)

    dsl_alarms.each do |alarm_name, dsl_alarm|
      aws_alarm = aws_alarms.delete(alarm_name)

      if aws_alarm
        walk_alarm(dsl_alarm, aws_alarm)
      else
        aws.alarms.create(alarm_name, dsl_alarm)
      end
    end

    aws_alarms.each do |alarm_name, aws_alarm|
      aws_alarm.delete
    end

    @cloud_watch.modified?
  end

  def walk_alarm(dsl_alarm, aws_alarm)
    unless aws_alarm.eql?(dsl_alarm)
      aws_alarm.update(dsl_alarm)
    end
  end

  def load_file(file)
    if file.kind_of?(String)
      open(file) do |f|
        Radiosonde::DSL.parse(f.read, file)
      end
    elsif file.respond_to?(:read)
      Radiosonde::DSL.parse(file.read, file.path)
    else
      raise TypeError, "can't convert #{file} into File"
    end
  end
end
