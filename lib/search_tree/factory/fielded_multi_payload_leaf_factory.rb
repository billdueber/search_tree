require 'search_tree/factory/multi_payload_leaf_factory'
require 'search_tree/factory/fielded_search_factory'


module SearchTree::Factory
  class FieldedMultiPayloadLeafFactory < MultiPayloadLeafFactory
    # Override .new so to use the FieldedAnnotation
    # module as a mixin. The happened to work out because
    # MultiPayloadLeafFactory is a class and FieldedSearchFactory
    # is defined solely in terms of the FieldedAnnotation mixin
    # Kinda ugly, and won't usually work for composition.
    def self.new
      super(mixin: SearchTree::Factory::FieldedSearchFactory::FieldedAnnotation)
    end
  end
end
