# Radiosonde

Radiosonde is a tool to manage CloudWatch Alarm.

It defines the state of CloudWatch Alarm using DSL, and updates CloudWatch Alarm according to DSL.

## Installation

Add this line to your application's Gemfile:

    gem 'radiosonde'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install radiosonde

## Usage

```sh
export AWS_ACCESS_KEY_ID='...'
export AWS_SECRET_ACCESS_KEY='...'
export AWS_REGION='us-east-1'
radiosonde -e -o Alarmfile  # export CloudWatch Alarm
vi Alarmfile
radiosonde -a --dry-run
radiosonde -a               # apply `Alarmfile` to CloudWatch
```

## Help

```
Usage: radiosonde [options]
    -p, --profile PROFILE_NAME
    -k, --access-key ACCESS_KEY
    -s, --secret-key SECRET_KEY
    -r, --region REGION
    -a, --apply
    -f, --file FILE
        --dry-run
    -e, --export
    -o, --output FILE
        --show-metrics
        --show-dimensions
        --show-statistics
        --namespace NAMESPACE
        --metric-name NAME
        --start-time TIME
        --end-time TIME
        --statistic STATISTIC
        --no-color
        --debug
```

## Alarmfile example

```ruby
require 'other/alarmfile'

alarm "alarm1" do
  namespace "AWS/EC2"
  metric_name "CPUUtilization"
  dimensions "InstanceId"=>"i-XXXXXXXX"
  period 300
  statistic :average
  threshold ">=", 50.0
  evaluation_periods 1
  actions_enabled true
  alarm_actions []
  ok_actions []
  insufficient_data_actions ["arn:aws:sns:us-east-1:123456789012:my_topic"]
end

alarm "alarm2" do
  ...
end
```
