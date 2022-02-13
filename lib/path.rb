# frozen_string_literal: true

class Path
  attr_reader :nodes

  def initialize(nodes = [])
    @nodes = nodes
  end

  def get_earliest_piece_node
    earliest_piece = nil
    @nodes.each do |node|
      unless node.value.nil?
        earliest_piece = node
        break
      end
    end
    earliest_piece
  end

  def get_location_of(value)
    location = nil
    @nodes.each do |node|
      if node.value == value
        location = node.index
        break
      end
    end
    location
  end

  def path_until_first_piece
    path = Path.new
    @nodes.each do |node|
      path.append_node(node)
      if node.value.nil?
      else
        break
      end
    end
    path
  end

  def occupied_nodes
    nodes = []
    @nodes.each do |node|
      nodes << node unless node.value.nil?
    end
    nodes
  end

  def append_node(node)
    @nodes << node
  end

  def empty?
    @nodes.empty?
  end

  def valid?
    valid = true
    @nodes.each do |node|
      unless node.valid?
        valid = false
        break
      end
    end
    valid
  end

  def include?(value)
    @nodes.include?(value)
  end

  def nodes_as_indexes
    indexes = []
    @nodes.each do |node|
      indexes << node.index
    end
    indexes
  end

  def last_node
    @nodes.last
  end

  def pop
    @nodes.pop
  end
end
