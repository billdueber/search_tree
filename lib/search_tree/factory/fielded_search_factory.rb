require_relative 'default_factory'
require 'search_tree/node/generic_node'

module SearchTree::Factory
  class FieldedSearchFactory
    # Now let's do a fielded factory -- where a node can
    # keep track of the field it's searching inside.
    # Since a node delegates any unknonwn methods to
    # the annotations object, we can just go ahead
    # and define #field and #boost (aliased as `#in`) methods
    #
    # FieldedAnnotation is pushed into a default factory
    # and used to extend all the created objects.
    #
    # Note that all the data is kept in the annotations hash,
    # which makes all the duplication and such continue to work.
    module FieldedAnnotation

      DEFAULT_BOOST = 1
      FIELD         = :_field
      BOOST         = :_boost

      attr_reader :field2

      def field
        self[FIELD]
      end

      def field=(v)
        self[FIELD] = v
        @field2     = v
        self
      end

      def boost
        self[BOOST]
      end

      def boost=(v)
        self[BOOST] = v
        self
      end

      def in(field, with_boost: DEFAULT_BOOST)
        self.field = field
        self.boost = with_boost
        self
      end


      # Need to override simple_string to display
      # the field/boost
      def as_string
        return super if field.nil?

        str    = SearchTree::GenericNode::strip_outer_parens(super)
        prefix = if boost.nil? or boost == DEFAULT_BOOST
                   "#{field}"
                 else
                   "#{field}^#{boost}"
                 end
        "#{prefix}:(#{str})"

      end
    end


    # And override .new so to use the FieldedAnnotation
    # module as a mixin
    def self.new
      DefaultFactory.new(mixin: FieldedAnnotation)
    end


  end
end
