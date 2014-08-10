class Radiosonde::DSL::Statistic
  ALIASES = {
    'SampleCount' => :sample_count,
    'Average'     => :average,
    'Sum'         => :sum,
    'Minimum'     => :minimum,
    'Maximum'     => :maximum,
  }

  class << self
    def conv_to_alias(statistic)
      ALIASES[statistic] || statistic
    end

    def valid?(statistic)
      ALIASES.keys.include?(statistic) or ALIASES.values.include?(statistic)
    end

    def normalize(statistic)
      ALIASES.index(statistic) || statistic
    end
  end # of class methods
end
