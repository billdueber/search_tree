require_relative 'generic_node'

module SearchTree
  class OrNode < AndNode
    def node_type
      :or
    end

    def simple_string
      "(#{left_child.simple_string} OR #{right_child.simple_string})"
    end

  end


end
