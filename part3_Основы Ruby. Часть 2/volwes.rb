#Thinknetica Ruby on Rails
#Part 3. Задание 4. Глассные.
#(c)2023 Anton Kokarev

volwes_chars = "euioa".chars
volwes_hash = {}
alphabet = ('a'..'z').to_a

alphabet.each_with_index { |letter, index| 
    volwes_hash [ letter.to_sym ] = index+1 if volwes_chars.include? letter }

puts volwes_hash

# всё решение одной строкой:
#if volwes_hash = {} then puts volwes_hash if ('a'..'z').each_with_index { |letter, index| volwes_hash [ letter.to_sym ] = index+1 if "euioa".chars.include? letter } end
