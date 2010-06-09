class FlexiDB::Engine::Command::Help < FlexiDB::Engine::Command

  # Returns command's banner
  def banner
    "help [command]"
  end

  # Executes the command on the engine
  def execute(engine, env, cmd = nil)
    if cmd.nil?
      env.say("General:")
      FlexiDB::Engine::COMMANDS.keys.sort{|k1, k2| k1.to_s <=> k2.to_s}.each do |c|
        cmd = FlexiDB::Engine::COMMANDS[c]
        env.say("  " << cmd.banner)
      end
    elsif FlexiDB::Engine::COMMANDS.key?(cmd.to_sym)
      env.say(FlexiDB::Engine::COMMANDS[cmd.to_sym].banner)
    end
  end
        
end # class Quit