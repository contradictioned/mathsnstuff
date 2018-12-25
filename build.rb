require 'rubygems'
require 'bundler/setup'
require 'json'
require 'yaml'

Bundler.require(:default)

class Builder

  def initialize argv
    @input_file = argv[0]
    @output_file = argv[1]
  end

  def sane?
    !(@input_file.nil? || @output_file.nil?) &&
    @input_file != '' && @output_file != ''
  end

  def build!
    puts "* Building the index"
    parse_input
    puts "* Preparing #{@input.size} glyphs"
    compile
    write_output
    puts "* Output written. Examine your work."
  end

  def parse_input
    @input = YAML.load_file @input_file
    @output_string = JSON.dump(@input)
  end

  def compile
    template = File.read('index.haml')
    haml_engine = Haml::Engine.new(template)
    @html = haml_engine.render(self)
  end

  def write_output
    File.open(@output_file, 'w') do |f|
      f.write(@html)
    end
  end
end

builder = Builder.new ARGV
if !builder.sane?
  puts "Uaergh." 
  exit  
end
builder.build!