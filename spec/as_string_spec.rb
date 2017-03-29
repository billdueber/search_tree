require_relative 'spec_helper'


describe "simple string representations" do
  before do
    @one   = SearchTree::LeafNode.new('one')
    @two   = @one.new_leaf('two')
    @three = @one.new_leaf('three')
    @four  = @one.new_leaf('four')
    @five  = @one.new_leaf('five')
    @six   = @one.new_leaf('six')
  end

  describe "leaf" do
    it "just calls #to_s" do
      assert_equal 'one', @one.to_s
    end
  end

  describe "simple AND/OR/NOT" do
    it "does a two-payload AND" do
      assert_equal 'one AND two', (@one & @two).to_s
    end

    it "does a two-payload OR" do
      assert_equal 'three OR four', (@three | @four).to_s
    end

    it "works with NOT" do
      assert_equal 'NOT six', (!@six).to_s
    end

    it "works with NOT on a pair" do
      assert_equal "NOT (six AND five)", (!(@six & @five)).to_s
    end

  end

  describe "more complex trees" do
    it "works with three left to right" do
      assert_equal "(one AND two) AND three", (@one & @two & @three).to_s
    end

    it "works with four left to right" do
      assert_equal '((one AND two) AND three) AND four', (@one & @two & @three & @four).to_s
    end

    it "groups by operation" do
      assert_equal '(one AND two) OR (three AND four)', (@one & @two | @three & @four).to_s
    end

    it "works with NOT" do
      assert_equal 'one OR (NOT (two AND three))', (@one | !(@two & @three)).to_s
    end

    it "works with double-NOT and a complex tree" do
      assert_equal "one OR (NOT (two AND three))", (!(!(@one | !(@two & @three)))).to_s
    end
  end
end
