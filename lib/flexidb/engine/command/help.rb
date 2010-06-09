class FlexiDB::Engine::Command::Help < FlexiDB::Engine::Command

  # Command's names
  names '\h', 'help'

  # Command's signatures
  signature{}
  signature{
    argument(:COMMAND, String)
  }

  # Command's synopsys
  synopsis "show available commands or display help of a specific command"
      
  # Executes the command on the engine
  def execute(engine, env, cmd = nil)
    if cmd.nil?
      env.say("General:")
      FlexiDB::Engine::COMMANDS.keys.sort{|k1, k2| k1.to_s <=> k2.to_s}.each do |c|
        cmd = FlexiDB::Engine::COMMANDS[c]
        cmd.banner.each{|b| env.say(" "*2 << b.to_s)}
        env.say(" "*20 << cmd.synopsis)
        env.say("\n")
      end
    elsif FlexiDB::Engine::COMMANDS.key?(cmd.to_sym)
      cmd = FlexiDB::Engine::COMMANDS[cmd.to_sym]
      env.say("\n")
      cmd.banner.each{|b| env.say(" "*2 << b.to_s)}
      env.say(" "*20 << cmd.synopsis)
      env.say("\n")
    end
  end
        
end # class Quit