require File.expand_path('../../fixtures', __FILE__)

describe "DbAgile::IO" do

  ::DbAgile::IO::KNOWN_FORMATS.each do |format|

    describe "to_#{format} should work on an array of hashes" do
      let(:array)  { [ { :id => 10 } ] }
      let(:columns){ array[0].keys }
      let(:method){ "to_#{format}".to_sym }
      subject{ lambda { DbAgile::IO.send(method, array, columns) } }
      it { should_not raise_error }
    end

  end
  
end