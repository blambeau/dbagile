describe "::DbAgile::Contract::Utils::Delegate" do
  
  describe "methods should correctly be installed" do
    subject{ Object.new.extend(::DbAgile::Contract::Utils::Delegate) }
    it{ should respond_to(:dataset) }
  end
  
  describe "method should pass parameters correctly" do
    subject{ 
      subject = Object.new.extend(::DbAgile::Contract::Utils::Delegate) 
      def subject.delegate
        o = Object.new
        def o.dataset(name)
          "Hello #{name}"
        end
        o
      end
      subject
    }
    specify { subject.dataset(:world).should == "Hello world" }
  end
  
end