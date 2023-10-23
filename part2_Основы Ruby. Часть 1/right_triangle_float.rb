#Thinknetica Ruby on Rails
#Part 1. Задание 3. Прямоугольный треугольник.
#Вариант решения с плавающей точкой.
#(c)2023 Anton Kokarev

puts 'Определение типа треугольника по сторонам'
puts 'Введите стороны треугольника:'
print 'a = '
a = gets.chomp.to_f
print 'b = '
b = gets.chomp.to_f
print 'c = '
c = gets.chomp.to_f


if a + b <= c || b + c <= a || a + c <= b
  abort "Треугольник со сторонами #{a} #{b} #{c} невозможен!"
end


if a == b && b == c 
  puts "Треугольник равносторонний"
else
  is_simple = true
  
  if a == b || a == c || b == c
    puts "Треугольник равнобедреный"
    is_simple = false
  end
  
  sorted_sides = [a, b, c].sort
  hypotenuse = sorted_sides[2]
  if hypotenuse**2 == sorted_sides[0]**2 + sorted_sides[1]**2
    puts "Треугольник прямоугольный"
    is_simple = false
  end

  if is_simple 
    puts "Обычный треугольник"
  end
end
