class Radiosonde::Wrapper::AlarmCollection
  include Radiosonde::Logger::Helper

  def initialize(cloud_watch, options = {})
    @cloud_watch = cloud_watch
    @options = options
  end

  def each
    @cloud_watch.describe_alarms.each do |page|
      page.metric_alarms.each do |alarm|
        yield(Radiosonde::Wrapper::Alarm.new(@cloud_watch, alarm, @options))
      end
    end
  end

  def create(name, dsl)
    log(:info, 'Create Alarm', :cyan, name)
    opts = Radiosonde::Wrapper::Alarm.normalize_attrs(dsl)

    alarm = Aws::CloudWatch::Types::MetricAlarm.new(opts.merge(alarm_name: name))
    unless @options[:dry_run]
      @cloud_watch.put_metric_alarm(alarm.to_h)
      @cloud_watch.modify!
    end

    Radiosonde::Wrapper::Alarm.new(@cloud_watch, alarm, @options)
  end
end
