require 'ruby_parser'

module Courgette
  class FileToSexpr
    def initialize
      @parser = RubyParser.new
    end

    def convert filename
      contents = File.read filename

      begin
        x = @parser.parse contents
      rescue Racc::ParseError => e
        $stderr.puts "Error parsing #{filename}: #{e} (file ignored)"
      end
    end
  end
end
