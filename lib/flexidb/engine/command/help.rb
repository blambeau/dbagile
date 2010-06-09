class FlexiDB::Engine::Command::Help < FlexiDB::Engine::Command

  # Returns command's banner
  def banner
    "help [COMMAND]"
  end

  # Returns command's help
  def help
    "show available commands or display help of a specific command"
  end
      
  # Executes the command on the engine
  def execute(engine, env, cmd = nil)
    if cmd.nil?
      env.say("General:")
      FlexiDB::Engine::COMMANDS.keys.sort{|k1, k2| k1.to_s <=> k2.to_s}.each do |c|
        cmd = FlexiDB::Engine::COMMANDS[c]
        banner, help = cmd.banner, cmd.help
        if banner.size < 19
          env.say(" "*2 << banner << " "*(19-banner.size) << help << "\n")
        else
          env.say(" "*2 << banner << "\n")
          env.say(" "*21 << help << "\n")
        end
      end
    elsif FlexiDB::Engine::COMMANDS.key?(cmd.to_sym)
      cmd = FlexiDB::Engine::COMMANDS[cmd.to_sym]
      env.say("\n")
      env.say(" "*2 << cmd.banner)
      env.say(" "*5 << cmd.help)
      env.say("\n")
    end
  end
        
end # class Quit