require 'search_tree/transform'
require 'search_tree/transform/search_string'

module SearchTree
  module Transform
    # Produce a standard-looking
    # search string from the tree, with the result of the payload
    # #to_s being strung together with AND/OR/NOT and appropriate
    # parentheses, and fields represented by either
    # field^boost:terms or just field:terms if boost is 1 or not present
    #
    # Note that as written, there's no such thing as a boost without a
    # field. We also don't do any checks to make sure anything makes sense
    # e.g., one could have  something like title:(good AND author:bill)
    # which is silly. Sanitation needs to be done beforehand by whatever
    # rules seem right.
    class FieldedSearchString < SearchString
      include SearchTree::Transform::Mixin

      # Build a prefix of the form "title:" or "title^3"
      # when a field or field/boost are present, and an
      # empty string otherwise
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
