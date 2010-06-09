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
  
  # Executes on signature 1
  def execute_1(engine, uri)
    engine.connect(uri)
  end
  
end # class Quit