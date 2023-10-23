#Thinknetica Ruby on Rails
#Part 2. Задание 4. Квадратное уравнение.
#(c)2023 Anton Kokarev

puts 'Введите коэффициенты квадратного уровнения:'
print 'a = '
a = gets.chomp.to_i
print 'b = '
b = gets.chomp.to_i
print 'c = '
c = gets.chomp.to_i

d = b**2 - 4*a*c

if d < 0
  puts "D = #{d}. Действительных корней нет!"
elsif d == 0
  x1 = (-b / (2*a)
  puts "D = #{d}, x1 = #{x1}"
else    
  x1 = (-b + Math.sqrt(d)) / (2*a)
  x2 = (-b - Math.sqrt(d)) / (2*a)
  puts "D = #{d}, x1 = #{x1}, x2 = #{x2}"
end
