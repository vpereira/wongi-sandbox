class Calculator
  attr_reader :stack
  
  def initialize
    @stack = []
  end
  
  def push(value)
    stack.push(value)
  end
  
  def add
    push(pop + pop)
  end
  
  def subtract
    push(pop - pop)
  end
  
  def multiply
    push(pop * pop)
  end
  
  def divide
    push(pop / pop)
  end
  
  def pop
    raise 'Empty stack' if stack.empty?
    stack.pop
  end
  
  def clear
    stack.clear
  end

  def to_s
    stack.to_s
  end
end
