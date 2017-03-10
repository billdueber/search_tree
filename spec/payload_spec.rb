require_relative 'spec_helper'

describe "simple payload objects" do
  describe "binary" do
    it "has two children" do
      skip
      b = SearchTree::Payload::Binary.new(1,2)
      assert 1, b.left_child
      assert 2, b.right_child
    end
  end
end
