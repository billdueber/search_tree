require_relative 'spec_helper'

describe "SearchString transformation" do
  before do
    @f = SearchTree::Factory::DefaultFactory.new
    @a = @f.leaf_node('a')
    @abc = (@a & 'b' | 'c')
    @ss_transform = SearchTree::Transform::SearchString.new
  end


  it "works on a single node" do
    assert_equal 'a', @ss_transform[@a]
  end

  it "does a simple and" do
    assert_equal '(a AND b)', @ss_transform[@a & 'b']
  end

  it "does a simple or" do
    assert_equal '(a OR b)', @ss_transform[@a | 'b']
  end

  it "does a simple not" do
    assert_equal 'NOT a', @ss_transform[!@a]
  end

  it "works on an arbitrarily complex tree" do
    t = ((@a & 'b') | 'c') & !(@abc | 'd')
    assert_equal '(((a AND b) OR c) AND NOT (((a AND b) OR c) OR d))',
        @ss_transform[t]
  end

  it "composes, in a way that makes you trust it" do
    t = ((@a & 'b') | 'c') & !(@abc | 'd')
    p1 = @ss_transform[@a & 'b']
    p2 = @ss_transform[@f.leaf_node('c')]
    p3 = @ss_transform[@abc]
    p4 = @ss_transform[@f.leaf_node('d')]

    assert_equal "((#{p1} OR #{p2}) AND NOT (#{p3} OR #{p4}))", @ss_transform[t]

  end

end
