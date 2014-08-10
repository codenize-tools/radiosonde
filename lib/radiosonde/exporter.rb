class Radiosonde::Exporter
  class << self
    def export(clowd_watch, opts = {})
      self.new(clowd_watch, opts).export
    end
  end # of class methods

  def initialize(clowd_watch, options = {})
    @clowd_watch = clowd_watch
    @options = options
  end

  def export
    result = {}

    @clowd_watch.alarms.each do |alarm|
      export_alarm(alarm, result)
    end

    return result
  end

  private

  def export_alarm(alarm, result)
    alarm_attrs = {
      :description => alarm.alarm_description,
      :metric_name => alarm.metric_name,
      :namespace => alarm.namespace,
      :dimensions => alarm.dimensions,
      :period => alarm.period,
      :statistic => alarm.statistic,
      :threshold => alarm.threshold,
      :comparison_operator => alarm.comparison_operator,
      :evaluation_periods => alarm.evaluation_periods,
      :actions_enabled => alarm.actions_enabled,
      :alarm_actions => alarm.alarm_actions,
      :ok_actions => alarm.ok_actions,
      :insufficient_data_actions => alarm.insufficient_data_actions,
      :unit => alarm.unit,
    }

    if @options[:with_status]
      alarm_attrs[:status] = export_alarm_status(alarm)
    end

    result[alarm.alarm_name] = alarm_attrs
  end

  def export_alarm_status(alarm)
    {
      :alarm_arn => alarm.alarm_arn,
      :state_value => alarm.state_value,
      :state_reason => alarm.state_reason,
      :state_reason_data => alarm.state_reason_data ? JSON.parse(alarm.state_reason_data) : nil,
      :state_updated_timestamp => alarm.state_updated_timestamp,
      :alarm_configuration_updated_timestamp => alarm.alarm_configuration_updated_timestamp,
    }
  end
end
