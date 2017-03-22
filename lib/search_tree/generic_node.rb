require 'search_tree/payload'
require 'forwardable'

require 'dry/initializer'
require 'dry/equalizer'


module SearchTree

  # predefine classes so order of code doesn't get too messy

  class GenericNode < SimpleDelegator; end
  class LeafNode < GenericNode; end
  class AndNode < GenericNode; end
  class OrNode < AndNode; end
  class NotNode < GenericNode; end

  LEAF_WRAPPER = ->(x) { x.kind_of?(GenericNode) ? x : LeafNode.new(x) }

  class DefaultFactory
    def wrap(x)
      if x.kind_of? GenericNode
        x
      else
        self.leaf_node(x)
      end
    end

    def and_node(left_child:, right_child:, **kwargs)
      AndNode.new(left_child: wrap(left_child), right_child: wrap(right_child), factory: self, **kwargs)
    end
  end

  DEFAULT_FACTORY = DefaultFactory.new

  class GenericNode < SimpleDelegator

    include Dry::Equalizer(:node_type, :payload, :annotations)



    extend Forwardable
    def_delegators :@payload, :to_s, :pretty_print, :left_child, :right_child, :only_child

    attr_reader :payload, :wrapper, :annotations, :factory



    def initialize(payload, factory: DEFAULT_FACTORY, **kwargs)
      @payload     = payload
      @wrapper     = wrapper
      @annotations = {}.merge(kwargs)
      @factory = factory
      __setobj__(@annotations)
      self
    end

    def dup(**kwargs)
      anno = annotations.merge(kwargs)
      self.class.new(payload, **anno)
    end
    alias_method :annotate_with, :dup


    def _parts
      if annotations.empty?
        [node_type, payload]
      else
        [node_type, annotations, payload]
      end
    end

    # def inspect
    #   _parts.to_s
    # end

    def pretty_print(q)
      _parts.pretty_print(q)
    end

    def
      # @wrapper = wr
      self
    end

    def node_type
      :generic
    end

    def and(other)
      factory.and_node(left_child:  self.dup,
                      right_child: other)
    end


    def or(other)
      OrNode.new(left_child:  self.dup,
                 right_child: factory.wrap(other))
    end

    def not
      if node_type == :not
        factory.wrap(only_child)
      else
        NotNode.new(only_child: self)
      end
    end

    # Alias as appropriate

    alias_method :&, :and
    alias_method :|, :or
    alias_method :!, :not


    # Allow any node to spit out a leaf with the
    # wrapper passed along

    def new_leaf(payload, **kwargs)
      LeafNode.new(payload, **kwargs)
    end

    # And something that looks like a factory
    def self.factory(wrapper: IDENTITY_FUNCTION)
      # self.new(:no_payload_factory_only)
      DEFAULT_FACTORY
    end

    # Get the left-to-right values from the leaves
    # Requires that you know that the payloads classes
    # all implement #values as well, which kinda smells
    def values
      if node_type == :leaf
        [payload]
      else
        payload.values
      end
    end


    # Create a simple string of the form
    # p1 AND (p2 AND (p3 OR p4)), just relying on the
    # #simple_string method of the various nodes.
    #
    # We're explicitly ignoring the annotations.
    # That's the "simple" part
    #
    # Need to be overridden for the node types
    def simple_string
      payload.to_s
    end

    # Make #as_string strip off any outer parens,
    # because it looks better
    OUTER_PARENS = /\A\((.*)\)\Z/
    def as_string
      ss = simple_string
      if m = OUTER_PARENS.match(ss)
        m[1]
      else
        ss
      end
    end

  end

  class AndNode < GenericNode

    def initialize(left_child:, right_child:, **kwargs)
      p = Payload::Binary.new(left_child: left_child, right_child: right_child)
      super(p, kwargs)
    end

    def dup(**kwargs)
      anno = annotations.merge(kwargs)
      self.class.new(left_child: payload.left_child.dup, right_child: payload.right_child.dup, **anno)
    end

    alias_method :annotate_with, :dup


    def node_type
      :and
    end

    def simple_string
      "(#{left_child.simple_string} AND #{right_child.simple_string})"
    end
  end

  class OrNode < AndNode
    def node_type
      :or
    end

    def simple_string
      "(#{left_child.simple_string} OR #{right_child.simple_string})"
    end

  end

  class NotNode < GenericNode
    def initialize(only_child:, **kwargs)
      p = Payload::Unary.new(only_child: only_child)
      super(p, kwargs)
    end

    def node_type
      :not
    end

    def dup(**kwargs)
      anno = annotations.merge(kwargs)
      self.class.new(only_child: payload.only_child, **kwargs)
    end
    alias_method :annotate_with, :dup

    def simple_string
      "(NOT #{payload.only_child.simple_string})"
    end


  end

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

    alias_method :value, :payload

    def simple_string
      payload.to_s
    end


  end



end
