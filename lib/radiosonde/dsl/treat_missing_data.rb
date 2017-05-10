class Radiosonde::DSL::TreatMissingData
  ALIASES = {
    'breaching'    => :breaching,
    'notBreaching' => :not_breaching,
    'ignore'       => :ignore,
    'missing'      => :missing
  }

  class << self
    def conv_to_alias(treat_missing_data)
      ALIASES[treat_missing_data] || treat_missing_data
    end

    def valid?(treat_missing_data)
      ALIASES.keys.include?(treat_missing_data) or ALIASES.values.include?(treat_missing_data)
    end

    def normalize(treat_missing_data)
      (ALIASES.respond_to?(:key) ? ALIASES.key(treat_missing_data) : ALIASES.index(treat_missing_data)) || treat_missing_data
    end
  end # of class methods
end
