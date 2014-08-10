class Radiosonde::DSL
  class << self
    def convert(exported, opts = {})
      Radiosonde::DSL::Converter.convert(exported, opts)
    end
  end # of class methods
end
