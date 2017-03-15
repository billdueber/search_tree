require 'dry-initializer'
require 'dry-equalizer'

module SearchTree
  module Payload
    class Binary
      extend Dry::Initializer::Mixin
      include Dry::Equalizer(:sorted_children)

      option :left_child
      option :right_child

      def dup
        self.class.new(left_child: left_child.dup, right_child: right_child.dup)
      end

      def pretty_print(q)
        {left: left_child, right: right_child}.pretty_print(q)
      end

      # We don't care about the order of operations for a
      # boolean operation like AND or OR, so we don't
      # differentiate based on order for equality
      def sorted_children
        [left_child.hash, right_child.hash].sort
      end

      def values
        left_child.values + right_child.values
      end

    end


    class Unary
      extend Dry::Initializer::Mixin
      include Dry::Equalizer(:only_child)

      option :only_child

      def values
        only_child.values
      end

      def pretty_print(q)
        only_child.pretty_print(q)
      end

      def dup
        self.class.new(only_child: only_child.dup)
      end
    end
  end


end
