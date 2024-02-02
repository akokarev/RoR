require_relative 'modules/accessors.rb'
require_relative 'modules/validation.rb'


class Test
  extend Acсessors
  include Validation

  attr_accessor_with_history :a, :b

  strong_attr_accessor :c, Integer

  validate :a, :type, Integer
  validate :a, :presence

  validate :b, :type, String
  validate :b, :presence
  validate :b, :format, /^[0-9]{3}$/
end

x = Test.new
puts("Начальное значение @a = #{x.a.inspect}")

5.times do |i|
  x.a = i
  puts("Присвоено значение #{i}:  @a=#{x.a}  @a_history=#{x.a_history}")
end

puts
puts("Начальное значение @c = #{x.c.inspect}")
3.times do |i|
  x.c = i
  puts("Присвоено значение #{i}:  @c=#{x.c} Тип: #{x.c.class}")
end

puts
print("Тест присвоения запрещенного типа ")
begin
  x.c = 'test'
  puts("ТЕСТ ПРОВАЛЕН!")
rescue
  puts("Тест пройден.")
end

print("Тест на соответствие типу ")
x.b = '123'
if x.valid?
  puts("Тест пройден.")
else
  puts("ТЕСТ ПРОВАЛЕН!")
end

print("Тест на несоответствие типу ")
x.b = 12345
if x.valid?
  puts("ТЕСТ ПРОВАЛЕН!")
else
  puts("Тест пройден.")
end

print("Тест на пустое значение ")
x.b = nil
if x.valid?
  puts("ТЕСТ ПРОВАЛЕН!")
else
  puts("Тест пройден.")
end

print("Тест на соответствие формату ")
x.b = '123'
if x.valid?
  puts("Тест пройден.")
else
  puts("ТЕСТ ПРОВАЛЕН!")
end

print("Тест на несоответствие формату ")
x.b = 'a1b2c3'
if x.valid?
  puts("ТЕСТ ПРОВАЛЕН!")
else
  puts("Тест пройден.")
end
