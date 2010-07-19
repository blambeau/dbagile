describe "DbAgile::Environment::History#from_command_line" do
  
  let(:history){ Object.new.extend(DbAgile::Environment::History) }
  subject{ history.from_command_line(line) }
  
  describe "when line is empty" do
    let(:line){ "" }
    it{ should == [] }
  end

  describe "with one argument, not quoted" do
    let(:line){ "--hello" }
    it{ should == ["--hello"] }
  end

  describe "when many arguments, not quoted" do
    let(:line){ "--hello world" }
    it{ should == ["--hello", "world"] }
  end

  describe "with a singly quoted argument without any space" do
    let(:line){ "'hello'" }
    it{ should == ["hello"] }
  end
  
  describe "with argument for which single quotes are part of the argument" do
    let(:line){ "\"'hello'\"" }
    it{ should == ["'hello'"] }
  end
  
  describe "with argument for which double quotes are part of the argument" do
    let(:line){ "'\"hello\"'" }
    it{ should == ['"hello"'] }
  end
  
  describe "with a doubly quoted argument without any space" do
    let(:line){ '"hello"' }
    it{ should == ["hello"] }
  end
  
  describe "with one singly quoted arguments" do
    let(:line){ "'SELECT * FROM table'" }
    it{ should == ["SELECT * FROM table"] }
  end

  describe "with one doubly quoted argument" do
    let(:line){ '"SELECT * FROM table"' }
    it{ should == ["SELECT * FROM table"] }
  end
  
  describe "with a mix of all cases" do
    let(:line){ "'hello' --world \"Foo\" Bar 'SELECT * FROM table' \"DROP TABLE table\"" }
    it{ should == ["hello", "--world", "Foo", "Bar", 'SELECT * FROM table', "DROP TABLE table"] }
  end

end