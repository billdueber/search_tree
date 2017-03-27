require_relative '../node'

module SearchTree::Factory

  # A factory has to implement
  # * and_node(left_child:, right_child:, **kwargs)
  # * or_node(left_child:, right_child:, **kwargs)
  # * leaf_node(payload, **kwargs)
  # * not_node(only_child:, **kwargs)
  # * negate(node, **kwargs)
  # * wrap(value, **kwargs) -- always returns a node
  #
  # See the FieldedSearchFactory for how to implement
  # extensions to the default -- we just mix in a
  # module with the methods you want.
  class DefaultFactory

    attr_reader :mixin

    def initialize(mixin: nil)
      @mixin = mixin
    end

    def wrap(x, **kwargs)
      if x.kind_of? SearchTree::GenericNode
        extend_node(x)
      else
        self.leaf_node(x)
      end
    end

    def extend_node(n)
      if mixin and !(n.singleton_class.included_modules.include? mixin)
        n.extend(mixin)
        n
      else
        n
      end
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
        not_node(only_child: wrap(node), factory: self, **kwargs)
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
