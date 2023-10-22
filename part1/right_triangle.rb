#Thinknetica Ruby on Rails
#Part 1. Задание 3. Прямоугольный треугольник.
#(c)2023 Anton Kokarev

puts 'Определение типа треугольника по сторонам'
puts 'Введите стороны треугольника:'
print 'a = '
a = gets.chomp.to_i
print 'b = '
b = gets.chomp.to_i
print 'c = '
c = gets.chomp.to_i


if a + b <= c || b + c <= a || a + c <= b
  abort "Треугольник со сторонами #{a} #{b} #{c} невозможен!"
end


sorted_sides = [a, b, c].sort
hypotenuse = sorted_sides[2]

if a == b && b == c
  puts "Треугольник равносторонний"

elsif a == b || a == c || b == c
  puts "Треугольник равнобедреный"

elsif hypotenuse**2 == sorted_sides[0]**2 + sorted_sides[1]**2
    puts "Треугольник прямоугольный"

else
  puts "Обычный треугольник"

end
