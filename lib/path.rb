# frozen_string_literal: true

class Path
  attr_reader :nodes

  def initialize(nodes = [])
    @nodes = nodes
  end

  def get_earliest_piece
    earliest_piece = nil
    @nodes.each do |node|
      unless node.value.nil?
        earliest_piece = node.value
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
      unless node.value.nil?
        nodes << node
      end
    end
    nodes
  end

  def append_node(node)
    @nodes << node
  end

  def empty?
    @nodes.empty?
  end
end
