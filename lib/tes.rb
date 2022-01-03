# frozen_string_literal: true

require 'pry-byebug'
require_relative 'game'
rook = Rook.new('black', 'Rook')
rook.moves_on_axis([4, 3])
bind
