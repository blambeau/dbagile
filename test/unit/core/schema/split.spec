require File.expand_path('../fixtures', __FILE__)
describe "DbAgile::Core::Schema#split" do
  
  let(:schema) { DbAgile::Fixtures::Core::Schema::schema(:suppliers_and_parts) }

  it "should split correctly through a logical/physical separation" do
    splitted = schema.split{|obj| obj.logical? ? :logical : :physical}
    logical, physical = splitted[:logical], splitted[:physical]
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
    (logical + physical).look_same_as?(schema).should be_true
  end
  
  it "should split correctly through a logical/physical/constraint separation" do
    splitted = schema.split{|obj| 
      if obj.logical? 
        if obj.constraint?
          :constraint
        else
          :logical 
        end
      else
        :physical
      end
    }
    logical, constraints, physical = splitted[:logical], splitted[:constraint], splitted[:physical]
    logical.visit{|o, parent|
      unless o.composite?
        o.logical?.should be_true
        o.constraint?.should be_false
      end
    }
    constraints.visit{|o, parent|
      unless o.composite?
        o.logical?.should be_true
        o.constraint?.should be_true
      end
    }
    physical.visit{|o, parent|
      unless o.composite?
        o.physical?.should be_true
      end
    }
    (logical + physical + constraints).look_same_as?(schema).should be_true
  end
  
end