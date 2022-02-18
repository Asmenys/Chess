# frozen_string_literal: true

class Movement_directions
  attr_reader :current_location, :current_location_two, :en_passant, :destination, :destination_two

  def initialize(current_location, destination, en_passant = nil, current_location_two = nil, destination_two = nil)
    @current_location = current_location
    @destination = destination
    @en_passant = en_passant
    @current_location_two = current_location_two
    @destination_two = destination_two
  end

  def moves_two_pieces?
    @current_location_two.nil? == false && @destination_two.nil? == false
  end

  def creates_en_passant?
    @en_passant.nil? == false
  end
end
