#Thinknetica Ruby on Rails
#Part 3. Задание 4. Глассные.
#(c)2023 Anton Kokarev

volwes_chars = "aeoui".chars
volwes_hash = {}

abc = ('a'..'z').to_a

abc.each_with_index do |letter, index|
    volwes_hash [ letter.to_sym ] = index+1 if volwes_chars.include? letter
end

puts volwes_hash
