class DbAgile::Engine::Command::Assert < DbAgile::Engine::Command
        
  # Command's names
  names 'assert'

  # Command's signatures
  signature{
    argument(:OBJECT, Object)
  }
  signature{
    argument(:OBJECT, Object)
    argument(:MESSAGE, String)
  }

  # Command's synopsys
  synopsis "raises an assertion unless the first argument is false (or nil)"
            
  # Executes the command on the engine
  def execute_1(engine, object, message = "")
    raise "Assertion failed: #{message}" unless object
    true
  end
  alias :execute_2 :execute_1
        
end # class Quit