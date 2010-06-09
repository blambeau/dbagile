class FlexiDB::Engine::Command::Use < FlexiDB::Engine::Command
        
  # Returns command's banner
  def banner
    "use PLUGIN {PLUGIN_OPTIONS...}"
  end  

  # Returns command's help
  def help
    "push plugin into the main adapter chain"
  end
      
  # Executes the command on the engine
  def execute(engine, env, args)
    if args =~ /^([^\s]+)\s*(.*)$/
      plugin_name, args = $1.to_sym, Kernel.eval($2)
      plugin = FlexiDB::Plugin::const_get(plugin_name)
      if args
        engine.database.__insert_in_main_chain(plugin, args)
      else
        engine.database.__insert_in_main_chain(plugin)
      end
      env.say(true)
    else
      env.error("USAGE: #{banner}")
    end
  end
        
end # class Quit