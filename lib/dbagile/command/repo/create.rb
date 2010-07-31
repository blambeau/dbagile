module DbAgile
  class Command
    module Repo
      #
      # Create a fresh dbagile repository in a specific directory
      #
      # Usage: dba #{command_name} [DIR]
      #
      # This commands creates a dbagile repository in a directory. When
      # none is specified, it will create a repository under 'dbagile'
      # in the current folder.
      #
      class Create < Command
        Command::build_me(self, __FILE__)
      
        # Where does the repository must be create?
        attr_accessor :where
      
        # Force repository creation?
        attr_accessor :force
      
        # Contribute to options
        def add_options(opt)
          self.force = false
          opt.separator nil
          opt.separator "Options:"
          opt.on("--force", 
                 "Force creation of the repository, removing the folder if it already exists") do |value|
            self.force = true
          end
        end
      
        # Normalizes the pending arguments
        def normalize_pending_arguments(arguments)
          if arguments.empty?
            self.where = "dbagile"
          else
            self.where = valid_argument_list!(arguments, String)
          end
        end
      
        # Executes the command
        def execute_command
          if File::exists?(self.where) and self.force
            FileUtils::rm_rf(self.where)
          end
          DbAgile::Core::Repository::create!(self.where)
          say("Repository successfully created!", :magenta)
        end
      
      end # class Create
    end # module Repo
  end # class Command
end # module DbAgile