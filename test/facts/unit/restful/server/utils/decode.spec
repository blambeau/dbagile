require File.expand_path('../../../../unit_helper.rb', __FILE__)
describe "Facts::Restful::Server::Utils#decode" do

  let(:utils){ Object.new.extend(Facts::Restful::Server::Utils) }
  let(:env){  }

  ['people', 'people/'].each do |path|
    it "should support relation-inspired path #{path}" do
      env = ::Rack::MockRequest::env_for("http://localhost/#{path}")
      utils.decode(env).should == [:relation, :people, {}]
    end
  end

  ['people/12', 'people/12/'].each do |path|
    it "should support tuple-inspired path #{path}" do
      env = ::Rack::MockRequest::env_for("http://localhost/#{path}")
      utils.decode(env).should == [:tuple, :people, {:'#' => '12'}]
    end
  end
  
end