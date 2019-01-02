require 'search_tree/factory/default_factory'
require 'search_tree/node/leaf_node'

module SearchTree::Factory
  # Mess with the factory just enough that the payload is
  # an array of things (probably strings), a format that's
  # used a lot in keyword-search interfaces
  class MultiPayloadLeafFactory < SearchTree::Factory::DefaultFactory

    class MultiPayloadLeaf < SearchTree::LeafNode

      # Force array payload
      def initialize(payload,  **kwargs)
        super(Array(payload), kwargs)
      end


      def add_to_payload(*args)
        @payload += args
        self
      end

      # Provide a leaf with stuff added to the payload
      #
      # @return [MultiPayloadLeaf]
      def with_additional_payload(*args)
        dup_leaf = self.factory.extend_node(self.dup)
        dup_leaf.add_to_payload *args
        dup_leaf
      end

    end


    def leaf_node(payload, **kwargs)
      self.extend_node(self.class.new(payload, factory: self, **kwargs))
    end


  end
end
