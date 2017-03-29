require_relative 'generic_node'
require 'search_tree/payload'

module SearchTree

  # Note that unlike the other node types, a leaf node's
  # payload is the actual value, not a Unary or Binary payload
  class LeafNode < GenericNode


    def node_type
      :leaf
    end

    def _parts
      if annotations.empty?
        payload
      else
        [payload, annotations]
      end
    end

    def value
      payload
    end

    def as_string
      payload.to_s
    end


  end

end
