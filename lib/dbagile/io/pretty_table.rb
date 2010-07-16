#
# This file has been originally copied from Sequel, and is therefore distributed 
# under Sequel's LICENCE. 
#
# Copyright (c) 2007-2008 Sharon Rosner
# Copyright (c) 2008-2009 Jeremy Evans
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#   
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#    
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER 
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#
module DbAgile
  module IO
    #
    # Helper to create pretty tables (very much inspired from Sequel's PrettyTable,
    # see file licence header for details).
    #
    module PrettyTable
    
      # Prints nice-looking plain-text tables
      def self.print(records, columns, buffer = "", options = {}) # records is an array of hashes
        # investigate arguments
        sizes = column_sizes(records, columns)
        sep_line = normalize_line(separator_line(columns, sizes), options)

        # start generation now
        buffer << sep_line << "\n"
        buffer << normalize_line(header_line(columns, sizes),options) << "\n"
        buffer << sep_line << "\n"
        records.each {|r| 
          buffer << normalize_line(data_line(columns, sizes, r),options) << "\n"
        }
        buffer << sep_line << "\n"
        buffer
      end

      ### Private Module Methods ###
      
      # Normalize the line according to options
      def self.normalize_line(line, options)
        if options[:truncate_at] and line.length > options[:truncate_at]
          ellipse = options[:append_with] || '...'
          line = line[0..(options[:truncate_at]-ellipse.length)] 
          line += ellipse
        end
        line = line_wrap(line, options[:wrap_at]) if options[:wrap_at]
        line
      end

      #
      # Wraps a line at a given width
      #
      # Taken from Ruby Facets
      # Copyright (c) 2004-2006 Thomas Sawyer
      # Distributed under the terms of the Ruby license.
      #
      def self.line_wrap(line, width, tabs=2)
        s = line.gsub(/\t/,' ' * tabs) # tabs default to 2 spaces
        s = s.gsub(/\n/,' ')
        r = s.scan( /.{1,#{width}}/ )
        r.join("\n") << "\n"
      end
  
      # Hash of the maximum size of the value for each column 
      def self.column_sizes(records, columns) # :nodoc:
        sizes = Hash.new {0}
        columns.each do |c|
          s = c.to_s.size
          sizes[c.to_sym] = s if s > sizes[c.to_sym]
        end
        records.each do |r|
          columns.each do |c|
            s = r[c].to_s.size
            sizes[c.to_sym] = s if s > sizes[c.to_sym]
          end
        end
        sizes.each_key{|k| sizes[k] += 1}
        sizes
      end
    
      # String for each data line
      def self.data_line(columns, sizes, record) # :nodoc:
        '|' << columns.map {|c| format_cell(sizes[c], record[c])}.join('|') << '|'
      end
    
      # Format the value so it takes up exactly size characters
      def self.format_cell(size, v) # :nodoc:
        case v
          when Bignum, Fixnum
            "%#{size}d" % v
          when Float
            "%#{size}g" % v
          else
            "%-#{size}s" % v.to_s
        end
      end
    
      # String for header line
      def self.header_line(columns, sizes) # :nodoc:
        '|' << columns.map {|c| "%-#{sizes[c]}s" % c.to_s}.join('|') << '|'
      end

      # String for separtor line
      def self.separator_line(columns, sizes) # :nodoc:
        '+' << columns.map {|c| '-' * sizes[c]}.join('+') << '+'
      end

      private_class_method :column_sizes, :data_line, :format_cell, :header_line, :separator_line
      private_class_method :line_wrap, :normalize_line
    end # module PrettyTable
  end # module IO
end # module DbAgile