require File.expand_path('../fixtures', __FILE__)
describe "DbAgile::Core::Schema#merge" do
  
  let(:left)             { DbAgile::Fixtures::Core::Schema::schema(:left)  }
  let(:right)            { DbAgile::Fixtures::Core::Schema::schema(:right) }
  
  it "should correctly label all nodes without conflict resolver" do
    schema = DbAgile::Core::Schema::merge(left, right){|l,r| nil}
    schema.visit{|p, parent|
      annotation = case p
        when DbAgile::Core::Schema::Logical::Relvar
          case p.name
            when :ADDED_COLUMNS_ON_LEFT,
                 :ADDED_CONSTRAINT_ON_LEFT,
                 :DROPPED_COLUMNS_ON_LEFT,
                 :DROPPED_CONSTRAINT_ON_LEFT,
              :alter
            when :ONLY_ON_LEFT_RELVAR,
              :drop
            when :ONLY_ON_RIGHT_RELVAR
              :create
            when :SAME
              :same
          end
        when DbAgile::Core::Schema::Logical::Attribute
          case p.name
            when :ADDED
              :drop
            when :DROPPED
              :create
          end
        when DbAgile::Core::Schema::Physical::Index
          case p.name
            when :ONLY_ON_LEFT_INDEX
              :drop
            when :ONLY_ON_RIGHT_INDEX 
              :create
            when :COMMON_INDEX
              :same
          end
        when DbAgile::Core::Schema::Logical::Constraint
          case p.name
            when :added_constraint
              :drop
            when :dropped_constraint 
              :create
          end
      end
      p.annotation.should == annotation unless annotation.nil?
    }
  end
  
  it "should raise a conflict error with a resolver" do
    lambda{ left + right }.should raise_error(DbAgile::SchemaConflictError)
    lambda{ DbAgile::Core::Schema::merge(left, right) }.should raise_error(DbAgile::SchemaConflictError)
  end
  
end