class Radiosonde::Wrapper::Alarm
  extend Forwardable
  include Radiosonde::Logger::Helper

  ATTRIBUTES_WITHOUT_NAME  = [
    :alarm_description,
    :namespace,
    :metric_name,
    :dimensions,
    :period,
    :statistic,
    :threshold,
    :comparison_operator,
    :evaluation_periods,
    :actions_enabled,
    :unit,
    :alarm_actions,
    :ok_actions,
    :insufficient_data_actions,
    :actions_enabled,
  ]

  ATTRIBUTES = [:alarm_name] + ATTRIBUTES_WITHOUT_NAME

  DEFAULT_VALUES = {
    :dimensions => []
  }

  ATTRIBUTES.each do |name|
    def_delegator :@alarm, name
  end

  class << self
    def normalize_attrs(attrs)
      normalized = {}

      Radiosonde::Wrapper::Alarm::ATTRIBUTES_WITHOUT_NAME.each do |name|
        unless (value = attrs[name]).nil?
          normalized[name] = value
        end
      end

      return normalized
    end
  end # of class methods

  def initialize(cloud_watch, alarm, options = {})
    @cloud_watch = cloud_watch
    @alarm = alarm
    @options = options
  end

  def eql?(dsl)
    diff(dsl).empty?
  end

  def update(dsl)
    delta = diff(dsl)
    log(:info, 'Update Alarm', :green, "#{self.alarm_name} > #{format_delta(delta)}")

    unless @options[:dry_run]
      opts = self.class.normalize_attrs(dsl)
      @alarm.update(opts)
      @cloud_watch.modify!
    end
  end

  def delete
    log(:info, 'Delete Alarm', :red, self.alarm_name)

    unless @options[:dry_run]
      @alarm.delete
      @cloud_watch.modify!
    end
  end

  private

  def diff(dsl)
    delta = {}

    ATTRIBUTES.each do |name|
      self_value = self.send(name)
      dsl_value = dsl[name]

      if normalize(name, self_value) != normalize(name, dsl_value)
        delta[name] = {:old => self_value, :new => dsl_value}
      end
    end

    return delta
  end

  def format_delta(delta)
    delta.map {|name, values|
      "#{name}(#{values[:old].inspect}=>#{values[:new].inspect})"
    }.join(', ')
  end

  def normalize(name, value)
    if [Array, Hash].any? {|c| value.kind_of?(c) }
      value.sort
    elsif DEFAULT_VALUES.has_key?(name) and value.nil?
      DEFAULT_VALUES[name]
    else
      value
    end
  end
end
