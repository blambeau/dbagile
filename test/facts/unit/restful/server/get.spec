require File.expand_path('../../../unit_helper.rb', __FILE__)
describe "Facts::Restful::Server#get" do
  
  let(:dburi)  { "memory://test.db"                                     }
  let(:server) { Facts::Restful::Server.new(dburi)                      }
  let(:request){ ::Rack::MockRequest.new(server)                        }
  before       { server.db.fact!(:tools, {:'#' => 1, :name => "facts"}) }
  subject      { request.get("http://localhost/#{path}")                }
  
  context "when called with unknown relation fact" do 
    let(:path){ "unknown" }
    specify{
      subject.status.should == 404
    }
  end
  
  context "when called with unknown tuple fact" do 
    let(:path){ "unknown/12" }
    specify{
      subject.status.should == 404
    }
  end
  
  context "when called with known relation fact" do 
    let(:path){ "tools" }
    specify{
      subject.status.should == 200
      tuples = Facts::Restful::json_decode(subject.body)
      tuples.should be_kind_of(Array)
      tuples.size.should == 1
      tuples[0][:name].should == "facts"
    }
  end
  
  context "when called with known tuple fact" do 
    let(:path){ "tools/1" }
    specify{
      pending("Relation heading should be implemented in order to support this requirement"){
        subject.status.should == 200
        tuple = Facts::Restful::json_decode(subject.body)
        tuple.should be_kind_of(Hash)
        tuple[:name].should == "facts"
      }
    }
  end
  
end

