class FlexiDB::Engine::Command::Define < FlexiDB::Engine::Command
        
  # Command's names
  names 'define'
        
  # Command's signature
  signature{
    argument(:TABLE_NAME, Symbol)
    argument(:HEADER,     Hash){|h| h.keys.all?{|k| Symbol===k} and h.values.all?{|v| Class===v}}
  }
  
  # Command's synopsis
  synopsis "define/create a new table with a specific {:attribute_name => AttributeType, ...} heading"
      
  # Executes the command on the engine
  def execute(engine, env, args)
    if args =~ /^([^,]+),(.*)$/
      name, heading = $1.to_sym, Kernel.eval($2)
      engine.database.create_table(name, heading)
      env.say(true)
    else
      env.say(banner)
    end
  end
        
end # class Quit