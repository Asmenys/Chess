# frozen_string_literal: true

class Movement_directions
  attr_reader :starting_location, :starting_location_two, :en_passant, :destination, :destination_two

  def initialize(starting_location, destination, en_passant = nil, starting_location_two = nil, destination_two = nil)
    @starting_location = starting_location
    @destination = destination
    @en_passant = en_passant
    @starting_location_two = starting_location_two
    @destination_two = destination_two
  end

  def moves_two_pieces?
    @starting_location_two.nil? == false && @destination_two.nil? == false
  end

  def creates_en_passant?
    @en_passant.nil? == false
  end
end
