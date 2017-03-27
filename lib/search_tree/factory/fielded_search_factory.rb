require_relative 'default_factory'

module SearchTree::Factory
  class FieldedSearchFactory < DefaultFactory
    # Now let's do a fielded factory -- where a node can
    # keep track of the field it's searching inside.
    # Since a node delegates any unknonwn methods to
    # the annotations object, we can just go ahead
    # and define a #field (aliased as `#in`) method
    module FieldedAnnotation

      DEFAULT_BOOST = 1
      FIELD = :_field
      BOOST = :_boost

      def field
        self[FIELD]
      end

      def field=(v)
        self[FIELD] = v
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

    end

    def extend_with_module
      FieldedAnnotation
    end


  end
end
