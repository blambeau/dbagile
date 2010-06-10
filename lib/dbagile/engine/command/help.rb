class DbAgile::Engine::Command::Help < DbAgile::Engine::Command

  # Command's names
  names '\h', 'help'

  # Command's signatures
  signature{
  }
  signature{
    argument(:COMMAND, String)
  }

  # Command's synopsys
  synopsis "show available commands or display help of a specific command"
  
  # Executes on signature 1
  def execute_1(engine)
    engine.say("General:")
    engine.each_command(true) do |cmd|
      cmd.banner.each{|b| engine.say(" "*2 << b.to_s)}
      engine.say(" "*20 << cmd.synopsis)
      engine.say("\n")
    end
    nil
  end
  
  # Executes the command on the engine
  def execute_2(engine, cmd_name)
    engine.find_command(cmd_name) do |cmd|
      engine.say("\n")
      cmd.banner.each{|b| engine.say(" "*2 << b.to_s)}
      engine.say(" "*20 << cmd.synopsis)
      engine.say("\n")
    end
    nil
  end
        
end # class Quit