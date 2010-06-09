class FlexiDB::Engine::Command::Use < FlexiDB::Engine::Command
        
  # Command's names
  names '\u', 'use'

  # Command's signatures
  signature{
    argument(:PLUGIN, Symbol){|s| FlexiDB::Plugin.const_get(s)}
  }
  signature{
    argument(:PLUGIN, Symbol){|s| FlexiDB::Plugin.const_get(s)}
    argument(:OPTIONS, Hash)
  }

  # Command's synopsys
  synopsis "push plugin into the main adapter chain"
            
  # Executes the command on the engine
  def execute_1(engine, plugin)
    plugin = FlexiDB::Plugin.const_get(plugin) if plugin.kind_of?(Symbol)
    engine.database.__insert_in_main_chain(plugin)
    true
  end
        
  # Executes the command on the engine
  def execute_2(engine, plugin, options)
    plugin = FlexiDB::Plugin.const_get(plugin) if plugin.kind_of?(Symbol)
    engine.database.__insert_in_main_chain(plugin, options)
    true
  end
        
end # class Quit