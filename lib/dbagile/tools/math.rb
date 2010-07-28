module DbAgile
  module MathTools
    
    # Returns x if x > y, y otherwise
    def max(x, y)
      x > y ? x : y
    end

    extend(MathTools)
  end # module StringTools
end # module DbAgile
