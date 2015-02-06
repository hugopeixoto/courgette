require 'parser/current'

module Courgette
  class FileToSexpr
    def initialize p=nil
      @parser = p || default_parser
    end

    def default_parser
      Parser::CurrentRuby
    end

    def convert filename
      contents = File.read filename

      begin
        @parser.parse contents
      rescue Parser::SyntaxError => e
        $stderr.puts "Error parsing #{filename}: #{e} (file ignored)"
      end
    end
  end
end
