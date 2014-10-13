class Taxonomy < ActiveRecord::Base
  extend ActsAsTree::TreeWalker
  acts_as_tree order: 'rank'

  has_many :genomes

  def parent_tree
    tree = []
    while true;

      @node = self

      while !@node.name == 'root'
        tree << @node
        @node = @node.parent
      end

    end
    return tree
  end
end
