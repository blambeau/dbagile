shared_examples_for("The ping command") do
  
  it "should return the pinged configuration" do
    DbAgile::command(environment) do |env, api|
      api.ping(%w{sqlite}).should be_kind_of(::DbAgile::Core::Configuration)
    end
  end

  it "should return the error if ping failed" do
    DbAgile::command(environment) do |env, api|
      api.ping(%w{unexisting}).should be_kind_of(StandardError)
    end
  end

  it "should print a friendly message on success" do
    DbAgile::command(environment) do |env, api|
      api.ping(%w{sqlite})
      env.output_buffer.join('').should =~ /ok/
    end
  end

  it "should print a friendly message on failure" do
    DbAgile::command(environment) do |env, api|
      api.ping(%w{unexisting})
      env.output_buffer.join('').should =~ /KO/
    end
  end

end