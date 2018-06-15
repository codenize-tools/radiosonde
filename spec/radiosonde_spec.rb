require 'spec_helper'
require 'pp'

describe Radiosonde do
  it 'has a version number' do
    expect(Radiosonde::VERSION).not_to be nil
  end
end

describe Radiosonde::Client do
end

describe Radiosonde::Exporter do
  let(:cloudwatch_client) { Aws::CloudWatch::Client.new }

  it 'has datapoints_to_alarm' do
    exporter = Radiosonde::Exporter.new(cloudwatch_client, {})
    actual = exporter.export['my-cloudwatch-alarm'][:datapoints_to_alarm]
    expect(actual).to eq(1)
  end
end

describe Radiosonde::DSL::Converter do
  let(:cloudwatch_client) { Aws::CloudWatch::Client.new }
  let(:exporter) { Radiosonde::Exporter.new(cloudwatch_client, {})}

  it 'convert dsl' do
    dsl = <<-'EOF'
alarm "my-cloudwatch-alarm" do
  description "my_NumberOfProcesses"
  namespace "my-cloudwatch-namespace"
  metric_name "NumberOfProcesses"
  dimensions "name"=>"my-dimension"
  period 300
  statistic :average
  threshold "<=", 5.0
  treat_missing_data :not_breaching
  evaluation_periods 1
  datapoints_to_alarm 1
  unit :seconds
  actions_enabled true
  alarm_actions ["arn:aws:sns:ap-northeast-1:1234567890:sns_alert"]
  ok_actions ["arn:aws:sns:ap-northeast-1:1234567890:sns_alert"]
  insufficient_data_actions ["arn:aws:sns:ap-northeast-1:1234567890:sns_alert"]
end
EOF
    exported = exporter.export
    converter = Radiosonde::DSL::Converter.new(exported, {})
    actual = converter.convert
    expect(actual).to eq(dsl)
  end
end
