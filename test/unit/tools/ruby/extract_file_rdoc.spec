require File.expand_path('../fixtures', __FILE__)
describe "DbAgile::RubyTools#extract_file_rdoc /" do
  
  subject{ DbAgile::RubyTools::extract_file_rdoc(File.expand_path('../fixtures.rb', __FILE__)) }
  
  it "should be as expected" do
    subject.should == File.read(File.expand_path('../fixtures/rdoc.txt', __FILE__))
  end
  
end