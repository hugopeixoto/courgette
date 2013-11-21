require 'ruby_parser'

module Courgette
  class FileToSexpr
    def initialize
      @parser = RubyParser.new
    end

    def convert filename
      contents = File.read filename

      @parser.parse contents
    end
  end
end
