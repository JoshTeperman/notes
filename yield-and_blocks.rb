require 'pry'
# Array class method '.each' uses yield under the hood to ...
# yield invokes a block
# yielding an element is like passing the element to some(where)one else to do something to, before it gets passed back and I continue with my code

class Array
  
  def my_print_each
    counter = 0
    while counter < self.length
      p self[counter]
      counter +=1
    end
  end

  def first_yield
    p 'hi within first yield'
    yield
    p 'hi again from within first yield'
  end

  def pass_argument_to_yield
    p 'hi from pass argument to yield'
    yield(5)
    p 'hi again from pass argument to yield'
  end 

  def my_each
    counter = 0
    while counter < self.length
      yield(self[counter])
      counter += 1
    end
  end

  def my_map
    counter = 0
    array = []
    while counter < self.length
      array << yield(self[counter])
      counter += 1
    end
    p array
  end 

end

arr = [5, 4, 3]
arr.my_map do |item|
  item + 2
end

# 1) call the method
# 2) yield
# 3) go into do block
# 4) execute the do block
# 5) go back into method
# 6) execute rest of method
# 7) end

# within each_method create a loop
# pass each item of the array using a while / counter loop
# yield each item of the array (to a do block) within that while loop
# execute the do block logic on the item
# return the (changed) item to the while loop





