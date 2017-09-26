class CompleteMe

  attr_reader :word_counter, :current_node, :letters
  attr_accessor :root

  def initialize
    @root = Node.new(nil)
    @word_counter = 0
  end

  def insert(word)
    current_node = @root
    letters = word.split("")
    letters.each do |letter|
      if current_node.children.key?(letter)
        current_node = current_node.children.dig(letter)
      else
        current_node.children[letter] = Node.new(letter)
        current_node = current_node.children[letter]
      end
    end
    current_node.term = true
    @word_counter += 1
  end

  def have?(word)
    current_node = @root
    letters = word.split("")
    letters.each do |letter|
      if current_node.children.key?(letter)
        current_node = current_node.children.dig(letter)
      end
    end
    return current_node.term
  end

  def count
   @word_counter
  end

  def populate(dictionary)
    dictionary.each_line do |word|
      word_array = word.split("\n")
      word_array.each do |item|
        insert(item.strip)
      end
    end
  end

  def suggest(substring)
    all_words = find_words(substring.chop, end_node_have?(substring))
    p all_words.unshift(smart_suggest(substring)).flatten.compact.uniq
  end

  def end_node_have?(substring)
    current_node = @root
    letters = substring.split("")
    letters.each do |letter|
        current_node = current_node.children[letter]
    end
    current_node
  end

  def find_words(substring, current_node, words = [])
    word = substring + current_node.data
    words << word if current_node.term && words.length < 7
    current_node.children.each do |key, value|
      find_words(word, value, words)
    end
    words
  end

  def select(substring, word_selected)
    current_node = @root
    letters = substring.split("")
    until current_node.data == substring[-1]
      letters.each do |letter|
      current_node = current_node.children[letter]
      end
       insert_suggestions(word_selected, current_node)
    end
  end

  def insert_suggestions(word_selected, current_node)
    if current_node.suggestions.empty?
      current_node.suggestions[word_selected] = 1
    elsif current_node.suggestions.include?(word_selected)
      current_node.suggestions[word_selected] += 1
    else
      current_node.suggestions[word_selected] = 1
    end
  end

  def smart_suggest(substring)
    current_node = @root
    letters = substring.split("")
    until current_node.data == substring[-1]
      letters.each do |letter|
      current_node = current_node.children[letter]
      end
      return collect_suggestions(current_node)
    end
  end

  def collect_suggestions(current_node)
    used_words_array = []
    if current_node.suggestions.empty?
    else
    current_node.suggestions = current_node.suggestions.sort_by {|key, value| value}.reverse
    used_words_array.push(current_node.suggestions.flatten.select {|nums| nums.class == String})
    end
    return used_words_array
  end

end
