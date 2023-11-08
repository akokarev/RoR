require_relative 'ask.rb'
class Menu
  attr_reader :promt, :action, :option

  def initialize(promt, option = '', action)
    raise 'Приглашение должно быть строка' unless promt.class == String
    raise 'Ответ должен быть строка' unless option.class == String
    raise 'Действие должно быть процедура или массив подменю' unless action.class == Proc || action.class == Array
    @promt = promt
    @action = action
    @option = option
  end

  def run(pre_choice=nil)
    if action.class == Proc
      action[]
      return pre_choice
    else
      if pre_choice
        choice = pre_choice
      else
        puts "\n=== #{promt} ==="
        action.each { |act| puts "(#{act.option}) #{act.promt}"}
        puts '(.) Exit\\UP'
        choice = ask("Ваш выбор: ")
        puts
      end
      
      choices = choice.split(' ',2)
      choice = choices[0]
      choice.upcase! if choice
      next_choice = choices[1]
      
      action.each { |act| next_choice = act.run(next_choice) if act.option.upcase == choice} 
      next_choice = self.run(next_choice) unless ['.', 'EXIT', 'E', 'Е'].include?(choice)
      return next_choice
    end
  end

end
