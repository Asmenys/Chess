# frozen_string_literal: true

class Node
  attr_reader :index, :value

  def initialize(index, value = nil)
    @index = index
    @value = value
  end
end
