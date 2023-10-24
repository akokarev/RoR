#Thinknetica Ruby on Rails
#Part 3. Задание 3. Числа Фибоначи до 100.
#(c)2023 Anton Kokarev

fib = [0, 1]

next_fib = 0
fib << next_fib while ( (next_fib = fib[-2] + fib[-1]) < 100 )

puts fib
