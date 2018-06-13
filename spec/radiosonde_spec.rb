require 'spec_helper'
require 'pp'

describe Radiosonde do
  it 'has a version number' do
    expect(Radiosonde::VERSION).not_to be nil
  end
end

describe Radiosonde::Exporter do
  let(:cloudwatch_client) { Aws::CloudWatch::Client.new }
  let(:cloudwatch_alarm) { Radiosonde::Exporter.new(cloudwatch_client, {}) }

  it 'expect datapoints_to_alarm' do
    actual = cloudwatch_alarm.export['my-cloudwatch-alarm'][:datapoints_to_alarm]
    expect(actual).to eq(1)
  end
end
