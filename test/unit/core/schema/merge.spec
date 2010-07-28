require File.expand_path('../fixtures', __FILE__)
describe "DbAgile::Core::Schema#merge" do
  
  let(:left)             { DbAgile::Fixtures::Core::Schema::schema(:left)  }
  let(:right)            { DbAgile::Fixtures::Core::Schema::schema(:right) }
  
  it "should correctly label all nodes without conflict resolver" do
    status = DbAgile::Core::Schema
    schema = DbAgile::Core::Schema::merge(left, right){|l,r| nil}
    schema.visit{|p, parent|
      s = case p
        when DbAgile::Core::Schema::Logical::Relvar
          case p.name
            when :ADDED_COLUMNS_ON_LEFT,
                 :ADDED_CONSTRAINT_ON_LEFT,
                 :DROPPED_COLUMNS_ON_LEFT,
                 :DROPPED_CONSTRAINT_ON_LEFT,
              status::TO_ALTER
            when :ONLY_ON_LEFT_RELVAR,
              status::TO_DROP
            when :ONLY_ON_RIGHT_RELVAR
              status::TO_CREATE
            when :SAME
              status::NO_CHANGE
          end
        when DbAgile::Core::Schema::Logical::Attribute
          case p.name
            when :ADDED
              status::TO_DROP
            when :DROPPED
              status::TO_CREATE
          end
        when DbAgile::Core::Schema::Physical::Index
          case p.name
            when :ONLY_ON_LEFT_INDEX
              status::TO_DROP
            when :ONLY_ON_RIGHT_INDEX 
              status::TO_CREATE
            when :COMMON_INDEX
              status::NO_CHANGE
          end
        when DbAgile::Core::Schema::Logical::Constraint
          case p.name
            when :added_constraint
              status::TO_DROP
            when :dropped_constraint 
              status::TO_CREATE
          end
      end
      p.status.should == s unless s.nil?
    }
  end
  
  it "should raise a conflict error with a resolver" do
    lambda{ left + right }.should raise_error(DbAgile::SchemaConflictError)
    lambda{ DbAgile::Core::Schema::merge(left, right) }.should raise_error(DbAgile::SchemaConflictError)
  end
  
end