class FlexiDB::Engine::Command::Insert < FlexiDB::Engine::Command
        
  # Command's names
  names 'insert'      
  
  # Command's signatures
  signature{
    argument(:TABLE_NAME, Symbol)
    argument(:TUPLE,      Hash)
  }
        
  # Command's synopsys
  synopsis "insert a {:attribute_name => value, ...} tuple inside a table"
      
  # Executes the command on the engine
  def execute(engine, env, args)
    if args =~ /^([^,]+),(.*)$/
      name, tuple = $1.strip.to_sym, Kernel.eval($2)
      env.say(engine.database.insert(name, tuple).inspect)
    else
      env.say(banner)
    end
  end
        
end # class Quit