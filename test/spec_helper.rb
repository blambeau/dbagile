$LOAD_PATH.unshift(File.expand_path('../', __FILE__))
$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))
require 'dbagile'
require 'rubygems'
require 'fixtures'
require 'spec'
require 'spec/autorun'
require 'fileutils'

Spec::Matchers.define :be_a_valid_json_string do
  match do |actual|
    begin
      JSON::parse(actual)
      true
    rescue JSON::JSONError
      false
    end
  end
  failure_message_for_should do |actual|
    "expected that #{actual.inspect} would be a valid JSON string"
  end
  failure_message_for_should_not do |actual|
    "expected that #{actual.inspect} would not be a valid JSON string"
  end
  description do
    "a valid JSON string"
  end
end

Spec::Matchers.define :be_a_valid_yaml_string do
  match do |actual|
    begin
      !YAML::load(actual).nil?
    rescue StandardError
      false
    end
  end
  failure_message_for_should do |actual|
    "expected that #{actual.inspect} would be a valid YAML string"
  end
  failure_message_for_should_not do |actual|
    "expected that #{actual.inspect} would not be a valid YAML string"
  end
  description do
    "a valid YAML string"
  end
end
