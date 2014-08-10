class Radiosonde::DSL::ComparisonOperator
  ALIASES = {
    'GreaterThanOrEqualToThreshold' => '>=',
    'GreaterThanThreshold'          => '>',
    'LessThanThreshold'             => '<',
    'LessThanOrEqualToThreshold'    => '<=',
  }

  class << self
    def normalize(operator)
      ALIASES[operator] || operator
    end
  end # of class methods
end
