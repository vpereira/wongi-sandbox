require 'wongi-engine'
require './calculator'

include Wongi::Engine
include Wongi::Engine::DSL

ENGINE = Wongi::Engine.create

def send_results_to_engine(operator, operand_a, operand_b)
  calculator = Calculator.new
  calculator.push(operand_a)
  calculator.push(operand_b)
  calculator.send(operator.to_sym)
  result = calculator.pop

  ENGINE << ["#{operand_a} #{operator} #{operand_b}", :results, result]
end

my_ruleset = ruleset "Calculator" do
  rule 'multiply' do
    forall do
      has :A, :*, :B
    end
    make do
      action do |token|
        send_results_to_engine(:multiply, token[:A], token[:B])
      end
    end
  end

  rule 'results' do
    forall do
      has :Operation, :results, :Result
    end

    make do 
      action do |token|
        puts "#{token[:Operation]}: #{token[:Result]}"
      end
    end
  end
  rule 'add' do
    forall do
      has :A, :+, :B
    end
    make do
      action do |token|
        send_results_to_engine(:add, token[:A], token[:B])
      end
    end
  end

  rule 'subtract' do
    forall do
      has :A, :-, :B
    end
    make do
      action do |token|
        send_results_to_engine(:subtract, token[:A], token[:B])
      end
    end
  end

  rule 'divide' do
    forall do
      has :A, :/, :B
      # you cannot divide by 0
      diff :A, 0
    end
    make do
      action do |token|
        send_results_to_engine(:divide, token[:A], token[:B])
      end
    end
  end
end

ENGINE << my_ruleset

ENGINE << [5, :*, 10]
ENGINE << [10, :+, 5]
ENGINE << [20, :-, 5]
ENGINE << [50, :/, 10]
ENGINE << [1, :/, 0]
ENGINE << [0, :/, 0]
