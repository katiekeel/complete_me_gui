dictionary = File.read("/usr/share/dict/words")

time = Time.now

dictionary.each_line do |word|
  Word.create!(text: word)
  puts word
end

puts Time.now - time
