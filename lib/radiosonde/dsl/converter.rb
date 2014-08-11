class Radiosonde::DSL::Converter
  class << self
    def convert(exported, opts = {})
      self.new(exported, opts).convert
    end
  end # of class methods

  def initialize(exported, options = {})
    @exported = exported
    @options = options
  end

  def convert
    @exported.each.map {|alarm_name, alarm_attrs|
      output_alarm(alarm_name, alarm_attrs)
    }.join("\n")
  end

  private

  def output_alarm(name, attrs)
    name = name.inspect
    description = attrs[:description]
    description = "description #{description.inspect}\n  " if description
    namespace = attrs[:namespace].inspect
    metric_name = attrs[:metric_name].inspect
    dimensions = format_dimensions(attrs)
    dimensions = "dimensions #{dimensions}\n  " if dimensions
    period = attrs[:period].inspect
    statistic = Radiosonde::DSL::Statistic.conv_to_alias(attrs[:statistic]).inspect
    threshold = format_threshold(attrs)
    evaluation_periods = attrs[:evaluation_periods].inspect
    actions_enabled = attrs[:actions_enabled].inspect
    alarm_actions = attrs[:alarm_actions].inspect
    ok_actions = attrs[:ok_actions].inspect
    insufficient_data_actions = attrs[:insufficient_data_actions].inspect

    if unit = attrs[:unit]
      unit = Radiosonde::DSL::Unit.conv_to_alias(unit).inspect
      unit = "unit #{unit}"
    end

    <<-EOS
alarm #{name} do
  #{description
  }namespace #{namespace}
  metric_name #{metric_name}
  #{dimensions
  }period #{period}
  statistic #{statistic}
  threshold #{threshold}
  evaluation_periods #{evaluation_periods}
  #{unit
  }actions_enabled #{actions_enabled}
  alarm_actions #{alarm_actions}
  ok_actions #{ok_actions}
  insufficient_data_actions #{insufficient_data_actions}
end
    EOS
  end

  def format_dimensions(attrs)
    dimensions = attrs[:dimensions] || []
    return nil if dimensions.empty?
    names = dimensions.map {|i| i[:name] }

    if duplicated?(names)
      dimensions.inspect
    else
      dimension_hash = {}

      dimensions.each do |dimension|
        name = dimension[:name]
        value = dimension[:value]
        dimension_hash[name] = value
      end

      unbrace(dimension_hash.inspect)
    end
  end

  def format_threshold(attrs)
    threshold = attrs[:threshold]
    operator = attrs[:comparison_operator]
    operator = Radiosonde::DSL::ComparisonOperator.conv_to_alias(operator)

    [
      operator.inspect,
      threshold.inspect,
    ].join(', ')
  end

  def unbrace(str)
    str.sub(/\A\s*\{/, '').sub(/\}\s*\z/, '')
  end

  def duplicated?(list)
    list.length != list.uniq.length
  end
end
