#Thinknetica Ruby on Rails
#Part 3. Задание 5. Високосный год.
#(c)2023 Anton Kokarev

print "Укажите дату (ДД.ММ.ГГГГ):"
dd,mm,year = gets.chomp.split('.').map(&:to_i)

is_leap = (year % 400 == 0) || ( year % 4 == 0 && year % 100 != 0 )
months = [31, (is_leap ? 29 : 28), 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

pos = dd
index=0
while index <= mm-2 do
  pos += months[index]
  index += 1
end

puts "Порядковый номер даты #{pos}"