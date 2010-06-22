shared_examples_for "Facts interface" do
  Dir[File.join(File.dirname(__FILE__), "interface", "**", "*.ex")].each do |file|
    self.instance_eval File.read(file)
  end
end