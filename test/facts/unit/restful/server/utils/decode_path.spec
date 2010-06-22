require File.expand_path('../../../../unit_helper.rb', __FILE__)
describe "Facts::Restful::Server::Utils#decode_path" do

  let(:utils){ Object.new.extend(Facts::Restful::Server::Utils) }

  it "should support relation-inspired paths" do
    utils.decode_path('/people').should == [:people, {}]
    utils.decode_path('/people/').should == [:people, {}]
  end
  
  it "should support tuple-inspired paths" do
    utils.decode_path('/people/12').should == [:people, {:'#' => 12}]
    utils.decode_path('/people/12/').should == [:people, {:'#' => 12}]
  end
  
  ['/people/and/other'].each do |path|
    it "should raise an error on invalid path #{path}" do
      lambda{ utils.decode_path(path) }.should raise_error(Facts::Restful::UnexpectedPathError)
    end
  end
  

end