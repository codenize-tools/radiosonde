class Radiosonde::Wrapper
  class << self
    def wrap(cw, opts = {})
      Radiosonde::Wrapper::CloudWatch.new(cw, opts)
    end
  end # of class methods
end
