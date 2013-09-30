module JSON
  class SchemaGenerator
    class DataWalker
      def initialize file_name
        @buffer = StringIO.new
        @buffer.puts "{"
        @buffer.puts '"$schema": "http://json-schema.org/draft-03/schema#",'
        @buffer.print '"description": "Generated from '
        @buffer.print file_name
        @buffer.puts '",'
      end

      def close
        @buffer.puts "}"
      end

      def walk_data data, buffer = @buffer
        case data
        when String
          buffer.puts '"type": "string",'
          buffer.puts '"required": true'
        when Integer
          buffer.puts '"type": "integer",'
          buffer.puts '"required": true'
        when Float
          buffer.puts '"type": "number",'
          buffer.puts '"required": true'
        when Array
          buffer.puts buffer.puts '"type": "array",'
          buffer.puts buffer.puts '"items": {'
          buffer.puts walk_data data.first, StringIO.new
          buffer.puts '},'
          buffer.puts '"minItems": 1,'
          buffer.puts '"uniqueItems": true'
          buffer.puts "}"
        when Hash
          buffer.puts '"type": "object",'
          buffer.print '"properties": {'
          subsection = data.map do |k,v|
            subbuffer = StringIO.new
            subbuffer.puts
            subbuffer.puts "\"#{k}\": {"
            walk_data v, subbuffer
            subbuffer.string
          end.join "},"
          buffer << subsection
          buffer.puts "}"
        else
          raise "Unknown type! #{data.class}"
        end
        buffer.string
      end

      def result
        @buffer.string
      end
    end

    class << self
      def generate file
        dw = DataWalker.new file
        data = JSON.load(File.read file)
        dw.walk_data data
        dw.close
        dw.result
      end
    end
  end
end