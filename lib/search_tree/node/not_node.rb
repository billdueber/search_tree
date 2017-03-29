require_relative 'generic_node'

module SearchTree
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

    def as_string
      "(NOT #{payload.only_child.as_string})"
    end


  end

end
