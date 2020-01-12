> "Prefer composition over inheritance." <br>
Design Patterns: Elements of Reusable Object-Oriented Software

If it is an `is-a`, then use `Inheritance`

If it is a `has-a`, then use `Composition`

# Inheritance

Inheritance is used to create a specialised version of a class.

Inheritance is used when you want to create an object that is a kind of another object.

A class that inherits from a superclass will have all methods, constants, and attributes defined on that parent class, with additional specialised attributes layered on top.

```ruby
class Fruit
  def type
    'food'
  end
end

class Apple < Fruit; end

Apple.new.type
# => 'food'
```

### The Liskov Substitution Principle

The `S` in SOLID.

Your subclasses should be useable in place of your base class. In other words your subclass should not change any of its behaviour so that it can not be used in place of its parent.

```ruby
class Person
  def initialize(name:)
    @name = name
  end

  def first_name
    @name.split[0]
  end
end

josh = Person.new(name: 'Josh Teperman')
=> #<Person:0x00007ff8bd055df8 @name="Josh Teperman">

josh.first_name
=> "Josh"

class Employee < Person
  def initialize(name:)
    @name = name.to_sym
  end
end

kate = Employee.new(name: 'Kate Teperman')
=> #<Employee:0x00007fa87e05c610 @name=:"Kate Teperman">

kate.first_name
=> NoMethodError (undefined method `split' for :"Kate Teperman":Symbol)
```

## When not to use inheritance

If you want to build something from parts. For example, you want to build a car, which needs wheels, an engine, radiator etc.
Those individual pieces are not able to function by themselves, they need to be part of a whole.

In that case, you should use composition instead.

Another red flag is when your subclass is not a true specialization of the parent class & you're just using the parent class to share utility methods.

## Using `super` with inheritance

When `super` is called inside a method, it will search through the inheritance heirarchy for a method with the same name and then invoke it.

```ruby
class BaseClass
  @@numbers = [1, 2, 3]

  def print
    @@numbers
  end
end

class SubClass < BaseClass
  def print
    super + [4, 5, 6]
  end
end

BaseClass.new.print
# => [1, 2, 3]

SubClass.new.print
# => [1, 2, 3, 4, 5, 6]
```

Another way of using `super` is with `initialize`. You can add additional specialized attributes to a subclass.

```ruby
class BaseClass
  def initialize(numbers = [1, 2, 3])
    @numbers = numbers
  end

  def print
    @numbers
  end
end

class SubClass < BaseClass
  def initialize(more_numbers)
    super()
    @more_numbers = more_numbers
  end

  def print
    super + @more_numbers
  end
end

BaseClass.new.print
=> [1, 2, 3]

SubClass.new([4, 5, 6]).print
=> [4, 5, 6, 4, 5, 6]
```

Ok, there's a problem here. When we create an instance of BaseClass, it is successfully assigning the default value of `@numbers` because we're not passing in any arguments.

However, when we try to create an instance of `Subclass`, `super` is called first, which calls `BaseClass` `initialize` method. If `super` is not passed any arguments, it automatically passes all arguments the subclass method was called with, in this case the array `[4, 5, 6]`.

Next, `SubClass` `initialize` method is called, assigning the same array to `@more_numbers`.

To solve this, we can either pass the argument we want directly into `super`:

```ruby
class SubClass < BaseClass
  def initialize(numbers, more_numbers)
    super(numbers)
    @more_numbers = more_numbers
  end
end

array1 = [1, 2, 3]
array2 = [4, 5, 6]

SubClass.new(array1, array2).print
=> [1, 2, 3, 4, 5, 6]
```

Or we can call `super()`, which passes zero arguments, therefore allowing our default `@numbers` value to be assigned:

```ruby
class SubClass < BaseClass
  def initialize(more_numbers)
    super()
    @more_numbers = more_numbers
  end
end

SubClass.new([4, 5, 6]).print
=> [1, 2, 3, 4, 5, 6]
```

# Composition

Composition is used when you want to create an Object from a combination of different parts

For example, say you want to build a computer. It needs a Hard-drive, cpu, a motherboard, screen, keyboard etc.

```ruby
class computer
  def initialize(hard_drive:, cpu:, motherboard:)
    @hard_drive   = HardDrive.new
    @cpu          = Cpu.new
    @motherboard  = Motherboard.new
  end
end
```

# Modules and Composition

## `include` Modules

You can only inherit from one class, but you can mix in as many modules as you like.

You cannot instantiate Modules. Modules are only used for namespacing and grouping common functionlity together.

Say we have a `Mammal` and a `Fish` class, both inheriting from their parent `Animal` class.

```ruby
class Animal; end

class Fish; end
class Mammal; end
```

We can create specialisations of `Animal` by adding functionality to subclasses.

A `Fish`, for example, breathes underwater, and a `Mammal` does not. Therefore we can add a `breathes_underwarter?` method to each:

```ruby
class Fish
  def breathes_underwarter?
    true
  end
end

class Fish
  def breathes_underwarter?
    false
  end
end
```

However, what about swimming, for example? Both `Fish` and `Mammals` can swim, but we don't want to write the same method for both classes, nor should we add the method to `Animal`, as not all `Animals` can swim.

One option is to `include` methods from a separate module in both classes. We can create a `Swimmable` module:

```ruby
module Swimmable
  def swim
    "I'm Swimming"
  end
end

class Fish
  include Swimmable
end

class Mammal
  include Swimmable
end

Fish.new.swim
# => I'm Swimming

Mammal.new.swim
# => I'm Swimming

Cat.new.swim
# => NoMethodError: undefined method `swim' for #<Cat:0x007fc453152308>
```


## Method Lookup Path with `ancestors`

We have three modules and one class `Animal` with the module `Walkable` included.

```ruby
module Walkable
  def walk
    "I'm walking."
  end
end

module Swimmable
  def swim
    "I'm swimming."
  end
end

module Climbable
  def climb
    "I'm climbing."
  end
end
```
```ruby
class Animal
  include Walkable

  def speak
    "I'm an animal, and I speak!"
  end
end

Animal.ancestors
# => [Animal, Walkable, Object, Kernel, BasicObject]
```

```ruby
class Dog < Animal
  include Climbable
  include Swimmable
end

Dog.ancestors
# => [GoodDog, Swimmable, Climbable, Animal, Walkable, Object, Kernel, BasicObject]
```

Some things to note:

- Ruby looks up the method starting from the *last* included module first.
- The module included in the parent class `Animal` also gets included. This means all `Dog` object will have access to methods included in `Animal` class.


## Module namespacing

Namespacing is the practise of organisation a specific group of classes or methods under a module.

To do so, simply create classes nested within a module.

```ruby
module Animals
  module Mammal
    class Dog
      def woof
        "Woof"
      end
    end

    class Cat
      def meow
        "Meow"
      end
    end
  end
end
```

We can call classes in a module with By appending two colons: `::` to the module name.

```ruby
Animals::Mammal.woof
# => Woof

Animals::Cat.meow
# => Meow
```

## Module Methods

```ruby
module MyModule
  def self.module_method
    "I am a module method"
  end
end

MyModule.module_method
# => I am a module method
```
