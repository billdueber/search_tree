require_relative "node/generic_node"
require_relative 'node/and_node'
require_relative 'node/or_node'
require_relative 'node/not_node'
require_relative 'node/leaf_node'

module SearchTree
  # In theory we could add functionality here. For now,
  # the generic node is plenty good enough.
  class Node < GenericNode
  end
end
