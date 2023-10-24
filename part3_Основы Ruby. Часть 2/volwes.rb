#Thinknetica Ruby on Rails
#Part 3. Задание 4. Глассные.
#(c)2023 Anton Kokarev

volwes_chars = "euioa".chars
volwes_hash = {}
alphabet = ('a'..'z')

alphabet.each_with_index do |letter, index|
  if volwes_chars.include? letter
    volwes_hash [ letter.to_sym ] = index+1 
  end
end

puts volwes_hash
