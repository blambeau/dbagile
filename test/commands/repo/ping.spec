shared_examples_for("The repo:ping command") do
  
  it "should return the pinged database" do
    dba.repo_ping(%w{sqlite}).should be_kind_of(::DbAgile::Core::Database)
  end

  it "should return the error if ping failed" do
    dba.repo_ping(%w{unexisting}).should be_kind_of(StandardError)
  end

  it "should print a friendly message on success" do
    dba.repo_ping(%w{sqlite})
    dba.output_buffer.string.should =~ /ok/
  end

  it "should print a friendly message on failure" do
    dba.repo_ping(%w{unexisting})
    dba.output_buffer.string.should =~ /KO/
  end

end