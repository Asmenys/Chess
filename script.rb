require_relative 'lib/load_game.rb'
require 'pry-byebug'
require 'optparse'

options = {}

class Parser

  def self.parse(args)
    options = {}
    opt_parser = OptionParser.new do |parser|
      parser.banner = "Usage: script.rb [options] ARG..."
      parser.separator "CLI implementation of Chess in ruby"
      
      parser.on('-h', '--help', 'Prints help') do
        puts parser
        exit
      end
      parser.on('-p', '--[no-]play', 'Start a chess game') do |p|
        options[:play] = p
      end
      parser.on('-s', '--save=SAVE', 'Save file to load (relative directory)') do |s|
       options[:save] = File.read(s)
      end

    end
    opt_parser.parse!(args)
    return options
  end
end

begin
  options = Parser.parse ARGV
rescue Exception => e
  puts "Exception encountered: #{e}"
  exit 1
end

if options[:play]
  if options[:save]
    game_instance = Load_game.new(options[:save]).game
  else
    game_instance = Load_game.new.game
  end
  game_instance.game_loop
end
Parser.parse %w[--help] if ARGV.empty?


