require File.expand_path('../fixtures', __FILE__)
describe "to_yaml understanding /" do

  describe "about user-defined to_yaml method" do
    let(:dumpable){ DbAgile::Fixtures::YAMLDumpable.new("hello") }
    subject{ lambda{ dumpable.to_yaml } }
    it{ should_not raise_error }
  end

end