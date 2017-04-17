require 'search_tree/transform'
require 'search_tree/transform/search_string'

module SearchTree
  module Transform
    # The searchstring transform produces a standard-looking
    # search string from the tree, with the result of the payload
    # #to_s being strung together with AND/OR/NOT and appropriate
    # parentheses
    class FieldedSearchString < SearchString
      include SearchTree::Transform::Mixin

      def field_prefix(node)
        return "" if node.field.nil?
        boost = if node.boost.nil? or node.boost == 1
                  ""
                else
                  "^#{node.boost}"
                end
        "#{node.field}#{boost}:"
      end

      def transform_leaf(node, **kwargs)
        field_prefix(node) + super
      end

      def transform_and(left_child_ss, right_child_ss, parent:, **kwargs)
        field_prefix(parent) + super
      end

      def transform_or(left_child_ss, right_child_ss, parent:, **kwargs)
        field_prefix(parent) + super
      end

      def transform_not(ss_to_negate, parent:, **kwargs)
        "NOT #{field_prefix(parent)}#{ss_to_negate}"
      end
    end
  end
end
