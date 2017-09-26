require 'test_helper'

class CompleteMeTest < ActiveSupport::TestCase
  def test_tree_exists
    completion = CompleteMe.new
    assert_instance_of CompleteMe, completion
  end

  def test_tree_can_have_a_word
    completion = CompleteMe.new
    completion.insert("a")
    assert 1, completion.count
  end

  def test_tree_can_have_multiple_words
    completion = CompleteMe.new
    completion.insert("apple")
    completion.insert("bubble")
    completion.insert("cat")
    assert 3, completion.count
  end

  def test_tree_words_can_have_branches
    completion = CompleteMe.new
    completion.insert("apple")
    completion.insert("application")
    completion.insert("appetizer")
    assert 3, completion.count
  end

  def test_tree_has_an_inserted_word
    completion = CompleteMe.new
    completion.insert("apple")
    completion.insert("application")
    completion.insert("appetizer")
    assert completion.have?("apple")
  end

  def test_tree_does_not_have_a_word_we_did_not_insert
    completion = CompleteMe.new
    completion.insert("apple")
    completion.insert("application")
    completion.insert("appetizer")
    refute completion.have?("app")
  end

  def test_tree_can_be_populated_with_dictionary
    completion = CompleteMe.new
    dictionary = File.read("/usr/share/dict/words")
    completion.populate(dictionary)
    assert_equal completion.count, 235886
  end

  def test_tree_has_words_from_dictionary
    completion = CompleteMe.new
    dictionary = File.read("/usr/share/dict/words")
    completion.populate(dictionary)
    assert completion.have?("tree")
    assert completion.have?("xylophone")
    assert completion.have?("zebra")
    assert completion.have?("apple")
  end

  def test_tree_does_not_have_word_that_does_not_exist
    completion = CompleteMe.new
    dictionary = File.read("/usr/share/dict/words")
    completion.populate(dictionary)
    refute completion.have?("askldjaejifeoafj")
  end

  def test_suggest_with_one_word
    completion = CompleteMe.new
    completion.insert("pizza")
    assert_equal completion.suggest("piz"), ["pizza"]
  end

  def test_suggest_with_two_words
    completion = CompleteMe.new
    completion.insert("pizza")
    completion.insert("pizzeria")
    assert_equal completion.suggest("piz"), ["pizza", "pizzeria"]
  end

  def test_suggest_with_whole_dictionary
    completion = CompleteMe.new
    dictionary = File.read("/usr/share/dict/words")
    completion.populate(dictionary)
    assert_equal completion.suggest("piz"), ["pize", "pizza", "pizzeria", "pizzicato", "pizzle"]
  end

  def test_select_with_two_words
    completion = CompleteMe.new
    completion.insert("pizza")
    completion.insert("pizzeria")
    completion.suggest("piz")
    completion.select("piz", "pizza")
    assert_equal completion.suggest("piz"), ["pizza", "pizzeria"]
  end

  def test_select_with_five_words
    completion = CompleteMe.new
    completion.insert("pizza")
    completion.insert("pizzeria")
    completion.insert("pize")
    completion.insert("pizzicato")
    completion.insert("pizzle")
    completion.suggest("piz")
    completion.select("piz", "pizza")
    assert_equal completion.suggest("piz"), ["pizza", "pizzeria", "pizzicato", "pizzle", "pize"]
  end

  def test_select_with_many_words
    completion = CompleteMe.new
    dictionary = File.read("/usr/share/dict/words")
    completion.populate(dictionary)
    completion.suggest("piz")
    completion.select("piz", "pizza")
    assert_equal completion.suggest("piz"), ["pizza", "pize", "pizzeria", "pizzicato", "pizzle"]
  end
end
