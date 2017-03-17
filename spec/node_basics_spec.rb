require_relative 'spec_helper'

describe "node creation and combination" do

  before do
    @pl = 'test_payload'
    @l = SearchTree::LeafNode.new(@pl)
  end

  describe "leaves with AND and OR" do
    it "makes a basic leaf" do
      assert_equal :leaf, @l.node_type
      assert_equal @pl, @l.payload
    end

    it "can be ANDed" do
      anode = @l.and(SearchTree::LeafNode.new(3))
      assert_equal :and,  anode.node_type
      assert_equal :leaf, anode.right_child.node_type
      assert_equal 3,     anode.right_child.payload
    end

    it "works the same with & or #and" do
      anode1 = @l.and(SearchTree::LeafNode.new(3))
      anode2 = @l & SearchTree::LeafNode.new(3)
      assert_equal anode1, anode2
      refute_equal anode1.object_id, anode2.object_id
    end

    it "can be ORd" do
      onode1 = @l.or(SearchTree::LeafNode.new(3))
      assert_equal :or, onode1.node_type
      assert_equal :leaf, onode1.left_child.node_type
      assert_equal 3,     onode1.right_child.payload
    end

    it "works the same with | and #or" do
      onode1 = @l.or(SearchTree::LeafNode.new(3))
      onode2 = @l.or(SearchTree::LeafNode.new(3))
      assert_equal onode1, onode2
      refute_equal onode1.object_id, onode2.object_id
    end
  end

  describe "simple NOT stuff" do
    it "will NOT a leaf" do
      assert_equal :not, (@l.not.node_type)
    end

    it "works with ! for NOT" do
      assert_equal :not,   (!@l).node_type
      assert_equal @l.not, !@l
    end

    it "will allow nots to cancel each other out" do
      assert_equal @l, !(!@l)
    end
  end
end
