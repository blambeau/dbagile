module DbAgile
  module Core
    class Repository
      class Builder
        include DbAgile::Environment::Delegator
        
        # Environment to use
        attr_reader :environment
        
        # Creates a builder instance
        def initialize(env)
          @environment = env
        end
        
        #
        # Ensures that the repository exists. If not, ask the user about creating
        # one in interactive mode; raises an error otherwise. Continues execution
        # with the provided block if required.
        #
        def ensure_repository(&block)
          env = self.environment
          if env.repository_exists?
            block.call if block
          elsif env.interactive?
            where = env.friendly_repository_path
            msg = <<-EOF.gsub(/^\s*\| ?/, '')
            | DbAgile's repository #{where} does not exist. Maybe it's the first time you
            | lauch dba. Do you want to create a fresh repository now?
            EOF
            confirm(msg, "Have a look at 'dba help repo:create'"){
              # create it!
              say("Creating repository #{where}...")
              DbAgile::Core::Repository::create!(env.repository_path)
              say("Repository has been successfully created.")
            
              # continue?
              if block
                msg = "Do you want to continue with previous command execution?"
                confirm(msg, &block)
              end
            }
          else
            # to force an error
            environment.repository
          end
        end
      
        # Yields the block if the user confirms something and returns block 
        # execution. Returns nil otherwise
        #
        def confirm(msg, on_no_msg = nil)
          say("\n")
          say(msg, :magenta)
          answer = environment.ask(""){|q| q.validate = /^y(es)?|n(o)?|q(uit)?/i}
          case answer.strip
            when /^n/i, /^q/i
              say("\n")
              say(on_no_msg, :magenta) unless on_no_msg.nil?
            when /^y/i
              yield
          end
        end
      
      end # class Builder
    end # class Repository
  end # module Core
end # module DbAgile