require File.expand_path('../fixtures', __FILE__)
describe "DbAgile::Core::Schema#filter" do
  
  let(:schema) { DbAgile::Fixtures::Core::Schema::schema(:suppliers_and_parts) }

  it "should filter correctly through constraint/not constraint separation" do
    constraints = schema.filter{|k| k.constraint?}
    others = schema.filter{|k| !k.constraint?}
    constraints.visit{|o, parent|
      unless o.composite?
        o.should be_kind_of(DbAgile::Core::Schema::Logical::Constraint)
      end
    }
    others.visit{|o, parent|
      unless o.composite?
        o.should_not be_kind_of(DbAgile::Core::Schema::Logical::Constraint)
      end
    }
    # puts constraints.to_yaml
    # puts others.to_yaml
    (constraints + others).look_same_as?(schema).should be_true
  end

  it "should filter correctly through logical/physical separation" do
    logical  = schema.filter{|k| k.logical?}
    physical = schema.filter{|k| k.physical?}
    logical.visit{|o, parent|
      unless o.composite?
        o.logical?.should be_true
      end
    }
    physical.visit{|o, parent|
      unless o.composite?
        o.physical?.should be_true
      end
    }
    # puts logical.to_yaml
    # puts physical.to_yaml
    (logical + physical).look_same_as?(schema).should be_true
  end
  
end