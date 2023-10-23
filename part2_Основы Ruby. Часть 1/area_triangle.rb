#Thinknetica Ruby on Rails
#Part 2. Задание 2. Площадь треугольника.
#(c)2023 Anton Kokarev

puts "Вычисление площади треугольника по основанию и высоте."
print 'Основание  a = '
a = gets.chomp.to_i

print 'Высота  h = '
h = gets.chomp.to_i

area_triangle = 0.5 * a * h
puts "Площадь треугольника S = 0.5*a*h = 0.5*#{a}*#{h} = #{area_triangle}"
