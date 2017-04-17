module SearchTree
  module Transform

    # The transform mixin, which takes care of the recursive
    # trip through the search tree and dispatching to the various
    # node-specific transforms
    #
    # Note that every method gets a node (or two) and optional keyword args
    # that are just passed along.

    module Mixin


      # Run a recursive transformation on the tree, dispatching to
      # an appropriate method:
      #  * transform_not(transformed_only_child, **kwargs)
      #  * transform_and(transformed_left_child, transformed_right_child, **kwargs)
      #  * transform_or(transformed_left_child, transformed_right_child, **kwargs)
      #  * transform_leaf(leafnode, **kwargs)
      def transform(node, **kwargs)
        p = node.payload
        case node.node_type
        when :not
          transform_not(transform(p.only_child), parent: node,  **kwargs)
        when :and
          transform_and(transform(p.left_child), transform(p.right_child), parent: node,  **kwargs)
        when :or
          transform_or(transform(p.left_child), transform(p.right_child), parent: node, **kwargs)
        when :leaf
          transform_leaf(node, kwargs)
        else
          raise ArgumentError, "Transform passed a non-node (#{node}"
        end
      end

      alias_method :[], :transform


    end
  end
end
