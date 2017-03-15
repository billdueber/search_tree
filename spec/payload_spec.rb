require_relative 'spec_helper'
require 'search_tree/payload'

describe "simple unary payloads" do
  before do
    @u1 = SearchTree::Payload::Unary.new(only_child: "one")
    @u2 = SearchTree::Payload::Unary.new(only_child: "two")
    @u1_1 = SearchTree::Payload::Unary.new(only_child: "one-one")
    @u2_2 = SearchTree::Payload::Unary.new(only_child: "two-two")

  end

  it "responds to only_child" do
    assert @u1.respond_to? :only_child
    assert_equal 'one', @u1.only_child
  end

  it "cannot be reset after creation" do
    assert_raises { @u1.only_child = 3 }
  end

  it "can duplicate itself" do
    ux = @u1.dup
    assert_equal @u1.only_child, ux.only_child
  end

  it "isn't the same object on duplication" do
    ux = @u1.dup
    refute_equal @u1.object_id, ux.object_id
    refute_equal @u1.only_child.object_id, ux.only_child.object_id
  end

end

describe "binary payloads" do
  before do
    @b = SearchTree::Payload::Binary.new(left_child: 'left', right_child: 'right')
  end

  it "has both kids" do
    assert_equal 'left', @b.left_child
    assert_equal 'right', @b.right_child
  end

  it "is frozen" do
    assert_raises { @b.left_child = 3 }
  end

  it "dups with different objects" do
    b = @b.dup
    refute_equal @b.object_id, b.object_id
    refute_equal @b.left_child.object_id, b.left_child.object_id
    refute_equal @b.right_child.object_id, b.right_child.object_id
  end
end
