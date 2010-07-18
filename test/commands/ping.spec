shared_examples_for("The ping command") do
  
  it "should return the pinged configuration" do
    dba.ping(%w{sqlite}).should be_kind_of(::DbAgile::Core::Configuration)
  end

  it "should return the error if ping failed" do
    dba.ping(%w{unexisting}).should be_kind_of(StandardError)
  end

  it "should print a friendly message on success" do
    dba.ping(%w{sqlite})
    env.output_buffer.string.should =~ /ok/
  end

  it "should print a friendly message on failure" do
    dba.ping(%w{unexisting})
    env.output_buffer.string.should =~ /KO/
  end

end