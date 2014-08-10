class Radiosonde::Client
  include Radiosonde::Logger::Helper

  def initialize(options = {})
    @options = options
    @cw = AWS::CloudWatch.new
  end

  def export(opts = {})
    exported = nil

    AWS.memoize do
      exported = Radiosonde::Exporter.export(@cw, @options.merge(opts))
    end

    Radiosonde::DSL.convert(exported, @options.merge(opts))
  end
end
