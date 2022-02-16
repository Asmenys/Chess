# frozen_string_literal: true

class Node
  attr_reader :index, :value

  def initialize(index, value = nil)
    @index = index
    @value = value
  end

  def valid_index?(index)
    result = false
    result = true if index >= 0 && (index < 8)
    result
  end

  def valid?
    result = false
    result = true if valid_index?(@index[0]) && valid_index?(@index[1])
    result
  end

  def empty?
    @value.nil?
  end
end
