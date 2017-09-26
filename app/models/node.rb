class Node 
  attr_reader :data

  attr_accessor :children, :term, :suggestions

  def initialize(letter)
    @data = letter
    @children = {}
    @term = false
    @suggestions = {}
  end
end
