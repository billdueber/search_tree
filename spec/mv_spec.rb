require_relative 'spec_helper'
require 'search_tree/factory/fielded_multi_payload_leaf_factory'

describe "MutiValued payloads" do
  before do
    @f = SearchTree::Factory::MultiPayloadLeafFactory.new
  end

  it "Forces an array for payload" do
    one = @f.leaf_node('one')
    assert_equal ['one'], one.payload
  end

  it "doesn't wrap an array for payload" do
    one = @f.leaf_node( ['one'] )
    assert_equal ['one'], one.payload
  end

  it "passes the mv-ness along" do
    one = @f.leaf_node('one')
    onetwo = one & 'two'
    assert_equal %w[two], onetwo.right_child.payload
  end

  it "produces a new mv node when the payload is added to" do
    one = @f.leaf_node('one')
    two = one.with_additional_payload('two')
    assert_equal %w[one two], two.payload
    assert_equal ['one'], one.payload
  end

end

describe "MV payloads on fielded nodes" do
  before do
    @f = SearchTree::Factory::FieldedMultiPayloadLeafFactory.new
    @one = @f.leaf_node('one')
    @two = @f.leaf_node('two')
  end

  it "supports both fields and multi-valued paylaods" do
    @one.field = 'title'
    double = @one.with_additional_payload 'three'
    assert_equal 'title', double.field
    assert_equal %w[one three], double.payload
  end

  it "transmits mvf-ness (just f, really) to binary nodes" do
    x = (@one & @two)
    x.field = 'title'
    assert_equal 'title', x.field
  end

end
