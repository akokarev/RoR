#Thinknetica Ruby on Rails
#Part 3. Задание 6. Сумма покупок.
#(c)2023 Anton Kokarev

def ask(question)
    print(question)
    gets.chomp
end

puts 'Заполните корзину товаров ("stop" - прекратить)'
cart = {}
loop do
  item_name,item_price,item_count = nil
  break if (item_name = ask('Название: ').to_sym) == :stop
  item_price = ask('Цена: ').to_f
  item_count = ask('Количество:').to_f 
  puts '---'
  cart[item_name] = {price: item_price, count: item_count}
end

puts "Ваша корзина: #{cart}"
sum = 0
cart.each_value {|item| sum += item[:price]*item[:count] }
puts "ИТОГО: #{sum}"
