require File.expand_path('../../fixtures', __FILE__)

describe "DbAgile::IO /" do

  # Class sanity
  describe "Class interface" do

    DbAgile::IO::KNOWN_TO_FORMATS.each do |format|
      specify{ DbAgile::IO.should respond_to("to_#{format}".to_sym) }
    end

    DbAgile::IO::KNOWN_FROM_FORMATS.each do |format|
      specify{ DbAgile::IO.should respond_to("from_#{format}".to_sym) }
    end
    
  end

  # Some tools
  let(:relation_like){[
    {:id => 1, :name => "DbAgile", :version => DbAgile::VERSION},
    {:id => 2, :name => "SByC", :version => SByC::VERSION}
  ]}
  let(:columns){ [ :id, :name, :version ] }

  ::DbAgile::IO::KNOWN_FORMATS.each do |format|
    
    describe "#{format} format /" do 
      let(:options){ DbAgile::IO::roundtrip_options(format) }
      let(:encoder){ lambda { 
        DbAgile::IO.send("to_#{format}".to_sym, relation_like, columns, StringIO.new, options) 
      }}
      let(:decoder){ lambda { 
        DbAgile::IO.send("from_#{format}".to_sym, StringIO.new(encoder.call.string), options) 
      }}
      
      specify "it should support a to_#{format} that returns the buffer" do
        encoder.should_not raise_error 
        encoder.call.should be_kind_of(StringIO)
      end
    
      next unless  DbAgile::IO.respond_to?("from_#{format}") 

      specify "it should support roundtrip" do
        decoder.should_not raise_error
        decoder.call.should == relation_like
      end
        
    end
    
  end # ::DbAgile::IO::KNOWN_FORMATS
  
end # describe DbAgile::IO