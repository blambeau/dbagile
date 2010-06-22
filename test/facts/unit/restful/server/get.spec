require File.expand_path('../../../unit_helper.rb', __FILE__)
describe "Facts::Restful::Server#get" do

  let(:dburi) { "memory://test.db"                }
  let(:server){ Facts::Restful::Server.new(dburi) }
  
  it "should support getting unknown facts" do
    s = server.get(:people, {:'#' => 1})
    s.should be_kind_of(Array) 
    s[0].should == 404
  end
  
  it "should support getting known facts" do
    server.db.fact!(:people, {:'#' => 1, :name => "blambeau"})
    s = server.get(:people, {:'#' => 1})
    s.should be_kind_of(Array) 
    s[0].should == 200
    # s[2].should == Facts::Restful::json_encode({:'#' => 1, :name => "blambeau"})
  end

end
