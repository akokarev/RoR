#Thinknetica Ruby on Rails
#Part 1. Задание 1. Идеальный вес.
#(c)2023 Anton Kokarev

puts "Вычисление идеального веса"
print 'Ваше имя: '
name = gets.chomp.capitalize

print 'Ваш рост: '
height = gets.chomp.to_i

optimal_weight = (height - 110)*1.15 #Оптимальный вес
puts (optimal_weight <= 0) ? "#{name}, Ваш вес уже оптимальный" : 
  "#{name}, Ваш идеальный вес #{optimal_weight} кг"
  