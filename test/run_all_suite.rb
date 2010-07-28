$silent = (ARGV[0] == "--silent")
begin
  require 'rubygems'
  require 'highline'
  $highline = HighLine.new
rescue LoadError
  puts "Better test suite summary with highline. Try 'gem install highline'"
end

# Say something
def color(message, color)
  if $highline
    $highline.color(message, color)
  else
    message
  end
end

# Test suite in order
tests = [ :assumptions, :unit, :contract, :commands, :restful ]

# Will contain interesting lines 
summary = []

# Let's go
tests.each do |kind| 
  file = File.expand_path("../#{kind}.spec", __FILE__)
  
  puts "Running #{kind} (#{kind}.spec)"
  summary << "\nSummary for #{kind}_test (#{kind}.spec)\n"
  
  # Executes it in a subprocess
  IO.popen("ruby #{file} 2>&1"){|io|
    while l = io.gets
      puts l unless $silent
      unless l =~ /^\s*\.*\s*$|\(in /
        if l =~ /0 failures/
          summary << "  " << color(l, :green) 
        elsif l =~ /failures/
          summary << "  " << color(l, :red)
        elsif l =~ /Finished/
          summary << "  " << color(l, :blue)
        else
          summary << "  " << l
        end
      end
    end
  }
end

puts summary.join("")
