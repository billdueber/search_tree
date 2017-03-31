require_relative 'spec_helper'

describe "PayloadCollector transformation" do
  before do
    @f = SearchTree::Factory::DefaultFactory.new
    @a = @f.leaf_node('a')
    @abc = (@a & 'b' | 'c')
    @payload_transform = SearchTree::Transform::PayloadCollector.new
  end

  describe "payload transform" do
    it "works on a single node" do
      assert_equal ['a'], @payload_transform[@a]
    end

    it "does a simple and" do
      assert_equal ['a', 'b'], @payload_transform[@a & 'b']
    end

    it "does a simple or" do
      assert_equal ['a', 'b'], @payload_transform[@a | 'b']
    end

    it "does a simple not" do
      assert_equal ['a'], @payload_transform[!@a]
    end

    it "works on an arbitrarily complex tree" do
      t = ((@a & 'b') | 'c') & !(@abc | 'd')
      assert_equal ['a', 'b', 'c', 'a', 'b', 'c', 'd'], @payload_transform[t]
    end
  end

end
