class Radiosonde::DSL
  class << self
    def convert(exported, opts = {})
      Radiosonde::DSL::Converter.convert(exported, opts)
    end

    def parse(dsl, path, opts = {})
      Radiosonde::DSL::Context.eval(dsl, path, opts).result
    end
  end # of class methods
end
