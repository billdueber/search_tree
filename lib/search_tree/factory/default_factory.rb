require_relative '../node'

# A factory has to implement
# * and_node(left_child:, right_child:, **kwargs)
# * or_node(left_child:, right_child:, **kwargs)
# * leaf_node(payload, **kwargs)
# * not_node(only_child:, **kwargs)
# * negate(node, **kwargs)
# * wrap(value, **kwargs) -- always returns a node

module SearchTree::Factory
  class DefaultFactory
    def wrap(x, **kwargs)
      if x.kind_of? SearchTree::GenericNode
        x
      else
        self.leaf_node(x)
      end
    end

    def extend_with_module
      nil
    end

    def extend_node(n)
      if extend_with_module
        n.extend(extend_with_module)
      end
      n
    end

    def and_node(left_child:, right_child:, **kwargs)
      self.extend_node SearchTree::AndNode.new(left_child: wrap(left_child), right_child: wrap(right_child), factory: self, **kwargs)
    end

    def or_node(left_child:, right_child:, **kwargs)
      self.extend_node SearchTree::OrNode.new(left_child: wrap(left_child), right_child: wrap(right_child), factory: self, **kwargs)
    end

    def not_node(only_child:, **kwargs)
      self.extend_node SearchTree::NotNode.new(only_child: wrap(only_child), factory: self, **kwargs)
    end

    def negate(node, **kwargs)
      if node.node_type == :not
        wrap(node.only_child, **kwargs)
      else
        not_node(only_child: node, factory: self, **kwargs)
      end
    end

    def leaf_node(payload, **kwargs)
      self.extend_node SearchTree::LeafNode.new(payload, factory: self, **kwargs)
    end

    # The annotation container has to support
    # #merge with a set of keyword arguments.
    # Everything else is up to the
    # specific implementation
    def new_annotation_container
      {}
    end
  end


end
