#Thinknetica Ruby on Rails
#Part 3. Задание 3. Числа Фибоначи до 100.
#(c)2023 Anton Kokarev

fib = [0, 1]

fib << fib[-2] + fib[-1] while (fib.last <= 100)

fib.delete_at(-1) #Последний элемент в любом случае будет больше 100

puts fib