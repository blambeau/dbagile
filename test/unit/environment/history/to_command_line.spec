describe "DbAgile::Environment::History#to_command_line" do
  
  let(:history){ Object.new.extend(DbAgile::Environment::History) }
  subject{ history.to_command_line(argv) }
  
  describe "when argv is empty" do
    let(:argv){ [] }
    it{ should == "" }
  end

  describe "when no quoting is required" do
    let(:argv){ ["--hello", "world"] }
    it{ should == "--hello world" }
  end

  describe "when quoting is required" do
    let(:argv){ ["--hello", "SELECT * FROM table"] }
    it{ should == '--hello "SELECT * FROM table"' }
  end

end