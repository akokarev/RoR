#Thinknetica Ruby on Rails
#Part 1. Задание 4. Квадратное уравнение.
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
  puts "Действительных корней нет!"
else
  sqrt_d = Math.sqrt(d)
  x1 = (-b + sqrt_d) / (2*a)
  x2 = (-b - sqrt_d) / (2*a)

  print "D = #{d}, x1 = #{x1}"
  print ", x2 = #{x2}" if d > 0
  puts
end
