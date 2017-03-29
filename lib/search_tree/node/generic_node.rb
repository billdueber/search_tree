require 'search_tree/payload'
require 'forwardable'

require 'dry/equalizer'
require 'dry-initializer'

require 'search_tree/factory/default_factory'


module SearchTree

  DEFAULT_FACTORY = Factory::DefaultFactory.new

  class GenericNode < SimpleDelegator

    include Dry::Equalizer(:node_type, :payload, :annotations)

    extend Forwardable
    def_delegators :@payload, :to_s, :pretty_print, :left_child, :right_child, :only_child

    attr_reader :payload, :annotations, :factory

    def initialize(payload, factory: DEFAULT_FACTORY, **kwargs)
      @payload     = payload
      @annotations = factory.new_annotation_container.merge(kwargs)
      @factory = factory
      __setobj__(@annotations)
      self
    end

    def dup(**kwargs)
      anno = annotations.merge(kwargs)
      self.class.new(payload, factory: factory, **anno)
    end
    alias_method :annotated_with, :dup


    def _parts
      if annotations.empty?
        [node_type, payload]
      else
        [node_type, annotations, payload]
      end
    end


    def pretty_print(q)
      _parts.pretty_print(q)
    end


    def node_type
      :generic
    end


    # Provide mechanisms to combine node
    # using and/or/not

    def and(other)
      factory.and_node(left_child:  self.dup,
                      right_child: other)
    end


    def or(other)
      factory.or_node(left_child:  self.dup,
                      right_child: other)
    end

    def negate
      factory.negate(self)
    end


    # Alias as appropriate

    alias_method :&, :and
    alias_method :|, :or
    alias_method :!, :negate
    alias_method :not, :negate # Does this make sense?


    # Allow any node to spit out a leaf

    def new_leaf(payload, **kwargs)
      factory.leaf_node(payload, **kwargs)
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

    alias_method :orig_to_s, :to_s
    OUTER_PARENS = /\A\((.*)\)\Z/
    def to_s
      as = as_string
      if m = OUTER_PARENS.match(as)
        m[1]
      else
        as
      end
    end



    def as_string
      orig_to_s
    end

  end


end
