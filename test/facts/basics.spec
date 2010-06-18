shared_examples_for "Facts - Basics" do
  Dir[File.join(File.dirname(__FILE__), "basics", "**", "*.ex")].each do |file|
    self.instance_eval File.read(file)
  end
end