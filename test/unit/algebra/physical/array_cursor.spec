require File.expand_path('../../../../spec_helper', __FILE__)

dbagile_load_all_subfiles(__FILE__, 'cursor/**/*.spec')

describe "DbAgile::Algebra::Physical::ArrayCursor" do
  
  let(:expected){ (1..10).collect{|i| {:id => i}} }

  subject{ DbAgile::Algebra::Physical::ArrayCursor.new(expected, [:id]) }  
  
  it_should_behave_like("A cursor")
  
end