require_relative 'modules/accessors.rb'

class Test
  extend Acсessors

  attr_accessor_with_history :a, :b
end

x = Test.new
puts ("Начальное значение @a = #{x.a.inspect}")

5.times do |i|
  x.a = i
  puts ("Присвоено значение #{i}:  @a=#{x.a}  @a_history=#{x.a_history}")
end
