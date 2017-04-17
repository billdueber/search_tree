require 'search_tree/transform'

module SearchTree
  module Transform
    # The payload collector just returns an array of the
    # payloads from the leaves of the tree in left-right order
    class PayloadCollector
      include SearchTree::Transform::Mixin

      def transform_leaf(node, **kwargs)
        [node.payload]
      end

      def transform_and(list_of_left_paylaods, list_of_right_payloads, parent:,  **kwargs)
        list_of_left_paylaods + list_of_right_payloads
      end

      def transform_or(list_of_left_paylaods, list_of_right_payloads, parent:, **kwargs)
        list_of_left_paylaods + list_of_right_payloads
      end

      def transform_not(list_of_negated_payloads, parent:, **kwargs)
        list_of_negated_payloads
      end


    end
  end
end
