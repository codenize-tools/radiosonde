class Radiosonde::DSL::Statistic
  ALIASES = {
    'SampleCount' => :sample_count,
    'Average'     => :average,
    'Sum'         => :sum,
    'Minimum'     => :minimum,
    'Maximum'     => :maximum,
  }

  class << self
    def normalize(statistic)
      ALIASES[statistic] || statistic
    end
  end # of class methods
end
