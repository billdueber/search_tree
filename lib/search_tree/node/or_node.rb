require_relative 'generic_node'

module SearchTree
  class OrNode < AndNode
    def node_type
      :or
    end


    def string_connector
      'OR'
    end

  end
end
