require_relative 'generic_node'

module SearchTree
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


end
