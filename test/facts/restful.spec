shared_examples_for "Restful interface" do
  Dir[File.join(File.dirname(__FILE__), "restful", "**", "*.ex")].each do |file|
    self.instance_eval File.read(file)
  end
end