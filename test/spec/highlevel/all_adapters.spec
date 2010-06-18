shared_examples_for("All adapters") do

  Dir[File.join(File.dirname(__FILE__), "all_adapters", "**", "*.ex")].each do |file|
    self.instance_eval File.read(file)
  end

end # DbAgile -- All transactional adapters