require_relative 'spec_helper'
require 'search_tree/payload'

describe "simple unary payloads" do
  before do
    @u1 = SearchTree::Payload::Unary.new(only_child: 1)
    @u2 = SearchTree::Payload::Unary.new(only_child: 2)
    @u1_1 = SearchTree::Payload::Unary.new(only_child: 1)
    @u2_2 = SearchTree::Payload::Unary.new(only_child: 2)

  end

  it "responds to only_child" do
    assert @u1.respond_to? :only_child
    assert_equal 1, @u1.only_child
  end

  it "cannot be reset after creation" do
    assert_raises { @u1.only_child = 3 }
  end

  it "can duplicate itself" do
    ux = @u1.dup
    assert_equal @u1.only_child, ux.only_child
  end

end
