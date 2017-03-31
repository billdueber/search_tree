require 'search_tree/transform'

module SearchTree
  module Transform
    # The searchstring transform produces a standard-looking
    # search string from the tree, with the result of the payload
    # #to_s being strung together with AND/OR/NOT and appropriate
    # parentheses
    class SearchString
      include SearchTree::Transform::Mixin

      def transform_leaf(node, **kwargs)
        node.payload.to_s
      end

      def transform_and(left_child_ss, right_child_ss, **kwargs)
        "(#{left_child_ss} AND #{right_child_ss})"
      end

      def transform_or(left_child_ss, right_child_ss, **kwargs)
        "(#{left_child_ss} OR #{right_child_ss})"
      end

      def transform_not(ss_to_negate, **kwargs)
        "NOT #{ss_to_negate}"
      end
    end
  end
end
