require 'uri'
class FlexiDB::Engine::Command::Connect < FlexiDB::Engine::Command
        
  # Command's names
  names '\c', 'connect'
        
  # Command's signatures
  signature{
    argument(:URI, String){|s| URI::parse(s); s}
  }
  
  # Command's synopsis
  synopsis "connect to a database through a adapter://user@host/database URI"
      
  # Executes the command on the engine
  def execute(engine, env, uri)
    engine.__connect(uri)
  end
        
end # class Quit