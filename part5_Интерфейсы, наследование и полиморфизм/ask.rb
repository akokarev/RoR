def ask(question, default_answer=nil)
  print(question)
  answer = gets.chomp
  answer = (answer=="") ? default_answer : answer
end

def ask_i(question, default_answer=nil)
  ask(question, default_answer).to_i
end
