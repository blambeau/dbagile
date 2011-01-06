shared_examples_for("The dba command") do
  
  let(:env){ DbAgile::default_environment.with_testing_methods! }
  let(:dba){ DbAgile::Command::Dba.new(env) }
  subject{ dba.run(__FILE__, args); env }
  
  describe "when called on an existing repository /" do
    
    before{ env.repository_path = DbAgile::Fixtures::repository_path(:basics) }
    
    describe "with no args" do
      let(:args){ [] }
      it{ should have_flushed(/Usage:/) }
    end
    
    describe "with --help" do
      let(:args){ ['--help'] }
      it{ should have_flushed(/Usage:/) }
    end
    
    describe "with --version" do
      let(:args){ ['--version'] }
      it{ should have_flushed(/(c)/) }
    end
    
    describe "with --interactive" do
      let(:args){ ['--interactive'] }
      it{ should be_interactive }
    end
    
    describe "with --no-interactive" do
      let(:args){ ['--no-interactive'] }
      it{ should_not be_interactive }
    end
    
    describe "with --backtrace" do
      let(:args){ ['--backtrace'] }
      it{ should be_show_backtrace }
    end
    
    describe "with --no-backtrace" do
      let(:args){ ['--no-backtrace'] }
      it{ should_not be_show_backtrace }
    end
    
    describe "with help" do
      let(:args){ ['help', 'help'] }
      it{ should have_flushed(/Usage:/) }
      it{ should have_flushed(/Description:/) }
    end
    
  end # on an existing repository
  
end