require_relative 'spec_helper'


describe "fielded search" do
  before do
    @ff = SearchTree::Factory::FieldedSearchFactory.new
  end

  it "produces a non-fielded leaf" do
    assert_equal 'one', @ff.leaf_node('one').to_s
  end

  it "produces a fielded leaf" do
    assert_equal 'title:(one)', @ff.leaf_node('one').in('title').to_s
  end

  it "works with a boost" do
    assert_equal 'title^5:(one)', @ff.leaf_node('one').in('title', with_boost: 5).to_s
  end

  it "works on a binary node" do
    n = (@ff.leaf_node('one') & 'two').in('title')
    assert_equal "title:(one AND two)", n.to_s
  end
end
