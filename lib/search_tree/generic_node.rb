require 'search_tree/payload'
require 'delegate'

require 'dry/initializer'
require 'dry/equalizer'


module SearchTree

  # predefine classes so order of code doesn't get too messy

  class GenericNode < SimpleDelegator; end
  class LeafNode < GenericNode; end
  class AndNode < GenericNode; end
  class OrNode < AndNode; end
  class NotNode < GenericNode; end
  class LeafNode < GenericNode; end

  IDENTITY_FUNCTION = ->(x) { x.kind_of?(GenericNode) ? x : LeafNode.new(x) }



  class GenericNode < SimpleDelegator

    include Dry::Equalizer(:payload, :annotations)



    extend Forwardable
    def_delegators :@payload, :to_s, :pretty_print

    attr_reader :payload, :wrapper, :annotations



    def initialize(payload, **kwargs)
      @payload     = payload
      @wrapper     = IDENTITY_FUNCTION
      @annotations = {}.merge(kwargs)
      __setobj__(@annotations)
      self
    end


    def _parts
      if annotations.empty?
        [node_type, payload]
      else
        [node_type, annotations, payload]
      end
    end

    def inspect
      _parts.to_s
    end

    def pretty_print(q)
      _parts.pretty_print(q)
    end

    def set_wrapper(wr)
      @wrapper = wr
      self
    end

    def node_type
      :generic
    end

    def and(other)
      AndNode.new(left_child:  self.dup,
                  right_child: wrapper.(other)).set_wrapper(wrapper)
    end


    def or(other)
      OrNode.new(left_child:  self.dup,
                 right_child: wrapper.(other)).set_wrapper(wrapper)
    end

    def not
      if node_type == :not
        wrapper.(payload).set_wrapper(wrapper)
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
      LeafNode.new(payload, **kwargs).set_wrapper(wrapper)
    end

    # And something that looks like a factory
    def self.factory(wrapper: IDENTITY_FUNCTION)
      self.new(:no_payload_factory_only).set_wrapper(wrapper)
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

    


  end

  class AndNode < GenericNode

    def initialize(left_child:, right_child:, **kwargs)
      p = Payload::Binary.new(left_child: left_child, right_child: right_child)
      super(p, kwargs)
    end

    def dup(**kwargs)
      anno = annotations.merge(kwargs)
      self.class.new(left_child: payload.left_child.dup, right_child: payload.right_child.dup, **anno).set_wrapper(wrapper)
    end

    alias_method :annotate_with, :dup


    def node_type
      :and
    end
  end

  class OrNode < AndNode
    def node_type
      :or
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
      self.class.new(only_child: payload, **anno).set_wrapper(wrapper)
    end
    alias_method :annotate_with, :dup


  end

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

    def dup(**kwargs)
      anno = annotations.merge(kwargs)
      self.class.new(payload, **anno).set_wrapper(wrapper)
    end
    alias_method :annotate_with, :dup



    alias_method :value, :payload
  end



end
