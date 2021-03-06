class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :populate_tree
  helper_method :tree

  def populate_tree
    @tree = CompleteMe.new
    dictionary = Word.all.pluck(:text)
    @tree.populate(dictionary)
  end
end
