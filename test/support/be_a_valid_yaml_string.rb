RSpec::Matchers.define :be_a_valid_yaml_string do
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
