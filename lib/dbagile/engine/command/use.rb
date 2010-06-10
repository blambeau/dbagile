class DbAgile::Engine::Command::Use < DbAgile::Engine::Command
        
  # Command's names
  names '\u', 'use'

  # Command's signatures
  signature{
    argument(:PLUGIN, Symbol){|s| DbAgile::Plugin.const_get(s)}
  }
  signature{
    argument(:PLUGIN, Module)
  }
  signature{
    argument(:PLUGIN, Symbol){|s| DbAgile::Plugin.const_get(s)}
    argument(:OPTIONS, Hash)
  }
  signature{
    argument(:PLUGIN, Module)
    argument(:OPTIONS, Hash)
  }

  # Command's synopsys
  synopsis "push plugin into the main adapter chain"
            
  # Executes the command on the engine
  def execute_1(engine, plugin)
    engine.connected!
    plugin = DbAgile::Plugin.const_get(plugin) if plugin.kind_of?(Symbol)
    engine.database.__insert_in_main_chain(plugin)
    true
  end
  alias :execute_2 :execute_1
        
  # Executes the command on the engine
  def execute_3(engine, plugin, options)
    engine.connected!
    plugin = DbAgile::Plugin.const_get(plugin) if plugin.kind_of?(Symbol)
    engine.database.__insert_in_main_chain(plugin, options)
    true
  end
  alias :execute_4 :execute_3
        
end # class Quit