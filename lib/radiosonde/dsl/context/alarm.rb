class Radiosonde::DSL::Context::Alarm
  include Radiosonde::DSL::Validator
  include Radiosonde::TemplateHelper

  def initialize(context, name, &block)
    @error_identifier = "Alarm `#{name}`"
    @context = context.merge(:alarm_name => name)
    @result = OpenStruct.new(
      :alarm_name => name,
      :alarm_actions => [],
      :ok_actions => [],
      :insufficient_data_actions => []
    )
    instance_eval(&block)
  end

  def result
    [
      :metric_name,
      :period,
      :statistic,
      :threshold,
      :comparison_operator,
      :actions_enabled,
    ].each do |name|
      _required(name, @result[name])
    end

    @result
  end

  private

  def description(value)
    _call_once(:alarm_description)
    @result.alarm_description = value.nil? ? nil : value.to_s
  end

  def namespace(value)
    _call_once(:namespace)
    @result.namespace = value.nil? ? nil : value.to_s
  end

  def metric_name(value)
    _call_once(:metric_name)
    _required(:metric_name, value)
    @result.metric_name = value.to_s
  end

  def dimensions(value)
    _call_once(:dimensions)
    _expected_type(value, Hash, Array)

    if value.kind_of?(Hash)
      value = value.map do |name, value|
        Aws::CloudWatch::Types::Dimension.new(name: name, value: value)
      end
    end

    @result.dimensions = value
  end

  def period(value)
    _call_once(:period)
    @result.period = value.to_i
  end

  def statistic(value)
    _call_once(:statistic)
    _validate("Invalid value: #{value}") do
      Radiosonde::DSL::Statistic.valid?(value)
    end

    @result.statistic = Radiosonde::DSL::Statistic.normalize(value)
  end

  def threshold(operator, value)
    _call_once(:threshold)
    _required(:threshold, value)
    operator = operator.to_s
    _validate("Invalid operator: #{operator}") do
      Radiosonde::DSL::ComparisonOperator.valid?(operator)
    end

    @result.threshold = value.to_f
    @result.comparison_operator = Radiosonde::DSL::ComparisonOperator.normalize(operator)
  end

  def evaluation_periods(value)
    _call_once(:evaluation_periods)
    @result.evaluation_periods = value.to_i
  end

  def unit(value)
    _call_once(:unit)
    _validate("Invalid value: #{value}") do
      Radiosonde::DSL::Unit.valid?(value)
    end

    @result.unit = Radiosonde::DSL::Unit.normalize(value)
  end

  def actions_enabled(value)
    _call_once(:actions_enabled)
    _expected_type(value, TrueClass, FalseClass)
    @result.actions_enabled = value
  end

  def alarm_actions(*actions)
    _call_once(:alarm_actions)
    _expected_type(actions, Array)
    @result.alarm_actions = [(actions || [])].flatten
  end

  def ok_actions(*actions)
    _call_once(:ok_actions)
    _expected_type(actions, Array)
    @result.ok_actions = [(actions || [])].flatten
  end

  def insufficient_data_actions(*actions)
    _call_once(:insufficient_data_actions)
    _expected_type(actions, Array)
    @result.insufficient_data_actions = [(actions || [])].flatten
  end

  def treat_missing_data(value)
    _call_once(:treat_missing_data)
    _validate("Invalid value: #{value}") do
      Radiosonde::DSL::TreatMissingData.valid?(value)
    end

    @result.treat_missing_data = Radiosonde::DSL::TreatMissingData.normalize(value)
  end

end
