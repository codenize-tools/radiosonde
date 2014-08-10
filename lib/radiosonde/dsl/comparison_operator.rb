class Radiosonde::DSL::ComparisonOperator
  ALIASES = {
    'GreaterThanOrEqualToThreshold' => '>=',
    'GreaterThanThreshold'          => '>',
    'LessThanThreshold'             => '<',
    'LessThanOrEqualToThreshold'    => '<=',
  }

  class << self
    def conv_to_alias(operator)
      ALIASES[operator] || operator
    end

    def valid?(operator)
      ALIASES.keys.include?(operator) or ALIASES.values.include?(operator)
    end

    def normalize(operator)
      ALIASES.index(operator) || operator
    end
  end # of class methods
end
