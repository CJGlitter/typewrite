class Typewrite
  def self.write(input, type_rate = 0.1, punc_rate = 1.5, new_line = true)
    input_array = input.split('')
    input_array.each do |char|
      print char
      puncs = ['.','?','!',]
      sleep(punc_rate) if puncs.include?(char)
      sleep(type_rate) if new_line?
    end
    print "\n"
  end
end
