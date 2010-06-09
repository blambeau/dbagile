class FlexiDB::Engine::Command::Use < FlexiDB::Engine::Command
        
  # Command's names
  names '\u', 'use'

  # Command's signatures
  signature{
    argument(:PLUGIN, Symbol){|s| FlexiDB::Plugin.const_get(s)}
  }

  # Command's synopsys
  synopsis "push plugin into the main adapter chain"
            
  # Executes the command on the engine
  def execute_1(engine, plugin)
    engine.database.__insert_in_main_chain(plugin)
  end
        
end # class Quit