class DbAgile::Engine::Command::Backtrace < DbAgile::Engine::Command
        
  # Command's names
  names 'backtrace'

  # Command's signatures
  signature{}

  # Command's synopsys
  synopsis "Prints the backtrace of the last error"
      
  # Executes the command on the engine
  def execute_1(engine)
    if err = engine.last_error
      engine.say(err.backtrace.join("\n"), :red)
    else
      engine.say("No error.", :red)
    end
  end
        
end # class Quit