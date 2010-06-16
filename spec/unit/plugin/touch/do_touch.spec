require File.expand_path('../../../../spec_helper', __FILE__)
describe "::DbAgile::Plugin::Touch#__do_touch" do

  before{ ::DbAgile::Plugin::Touch.instance_eval{public :__do_touch} }

  let(:adapter){ 
    adapter = DbAgile::MemoryAdapter.new 
    adapter.create_table(nil,:example, :id => Integer, :now => String)
    adapter
  }
  let(:values){ {:now => "now!!"} }
  let(:touch){ DbAgile::Core::Chain[DbAgile::Plugin::Touch.new(values, options), adapter] }

  context("when called with at insert and no force") do
    let(:options){ {:at => :insert, :force => false} }
    
    specify("it touches the tuple at insert time") do
      touch.insert(nil,:example, {:id => 1})
      adapter.dataset(:example).to_a.should == [ {:id => 1, :now => "now!!"} ]
    end
    
    specify("it does not touch the tuple at insert time if attribute is specified") do
      touch.insert(nil,:example, {:id => 1, :now => "hello"})
      adapter.dataset(:example).to_a.should == [ {:id => 1, :now => "hello"} ]
    end
    
    specify("it does not touch the tuple at update time") do
      touch.insert(nil,:example, {:id => 1})
      touch.update(nil,:example, {:id => 1}, {:now => "hello"})
      adapter.dataset(:example).to_a.should == [ {:id => 1, :now => "hello"} ]
    end
  end

  context("when called with at update and no force") do
    let(:options){ {:at => :update, :force => false} }
    
    specify("it does not touch the tuple at insert time") do
      touch.insert(nil,:example, {:id => 1})
      adapter.dataset(:example).to_a.should == [ {:id => 1, :now => nil} ]
    end
    
    specify("it touches the tuple at update time") do
      touch.insert(nil,:example, {:id => 1})
      touch.update(nil,:example, {:id => 1}, {:id => 2})
      adapter.dataset(:example).to_a.should == [ {:id => 2, :now => "now!!"} ]
    end

    specify("it does not touch the tuple at update time if attribute is specified") do
      touch.insert(nil,:example, {:id => 1})
      touch.update(nil,:example, {:id => 1}, {:id => 2, :now => "hello"})
      adapter.dataset(:example).to_a.should == [ {:id => 2, :now => "hello"} ]
    end
  end

  context("when called with both and force") do
    let(:options){ {:at => :both, :force => true} }
    
    specify("it touches the tuple at insert time") do
      touch.insert(nil,:example, {:id => 1})
      adapter.dataset(:example).to_a.should == [ {:id => 1, :now => "now!!"} ]
    end
    
    specify("it touches the tuple at insert time even if specified") do
      touch.insert(nil,:example, {:id => 1, :now => "hello"})
      adapter.dataset(:example).to_a.should == [ {:id => 1, :now => "now!!"} ]
    end
    
    specify("it touches the tuple at update time even if specified") do
      touch.insert(nil,:example, {:id => 1})
      touch.update(nil,:example, {:id => 1}, {:id => 2, :now => "hello"})
      adapter.dataset(:example).to_a.should == [ {:id => 2, :now => "now!!"} ]
    end
  end
  
end
