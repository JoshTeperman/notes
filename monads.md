# Monads

## Definition

A Monad is a data type and a concept from category theory.

## Monad laws

All Monads obey these three axioms, written in Haskell:

1) Left Identity: `return a >>= f ≡ f a`
2) Right Identity: `m >>= return ≡ m`
3) Associativity: `(m >>= f) >>= g ≡ m >>= (\x -> f x >>= g)`

### Key

- `≡` comparison, means the expressions are the same
- `return` is a default constructor, eg: the `#Success` method for `Result`
- `>>=` is a bind operator. In Ruby this is the `#bind` method
- `\x -> ...` is an anonymous function, or block / lambda in ruby `-> (x) { ... }`
- `f` is a function that accepts a value and returns `Result`
- `m` is a value of type `Result`
- `g` appears to refer to another function `f`

### Left Identity

`return(a) >>= f` is identical to `f.(a)`

Say we have a function `f`:
```ruby
f = -> (x) { Success(x ** 2) }
```

The Left Identity axiom states that there are two ways to call this function that are `≡` equal.

1) wrapping the argument `x` in a Monad and passing the function to `#bind`
2) calling the function with the argument `x` in the normal Ruby way

```ruby
# 1

Success(5).bind(&f)
# => Success(25)

# 2

f.(5)
# => Success(25)
```

This point gives some insight into how Monads are used in ROP. `f` is a function that returns a `Result` Monad.
You can call `f` using normal Ruby and it will simply return `Success` and you're done.
Or, you can pass the argument `x` wrapped in a Monad and bind it to a block, which ... does the same thing, it wrap does some computation on `value` and returns the `Result` wrapped in a `Success` Monad.

If you wanted to, you could take the return `value` of `f` and bind it to another block, and another.

### Right Identity

`m >>= return ≡ m`

If we have a value of type `Result` and we bind it to a `#Success`, the operation won't change anything.

```ruby
Success(x).bind(&method(:Sucess)) # => Success(x)
Success(x).bind(&Dry::Monads::Success) # => Success(x)
Failure(x).bind(&method(:Success)) # => Failure(x)
```

In other words. An operation is always a `:Success`, until it returns a `:Failure`, and then it is always a `:Failure`.

Hence the idea of Railway Oriented Programming.

There are only two tracks. And if the operation deviates from `:Success` to `:Failure` then the operation will always return `:Failure`.

### Associativity

`(m >>= f) >>= g ≡ m >>= (\x -> f x >>= g)`

Broken down, the following two are the same :

1) `(m >>= f) >>= g` :

A `Result` type value is bound to function `f`, the `Result` of which is bound to function `g`

2) `m >>= (\x -> f x >>= g)`

A `Result` is bound and passed as `x` to an anonymous function, which calls funcction `f` with `x` as an argument, the `Result` of which is bound to funcction `g`.

What this is saying is that you can nest operations any way you like, and the result will always be the same.
Nesting appears to refer to using additional anonymous functions to receive value and run operations on `Result`.

```ruby
m = Success(2)

f -> (x) { Success(x ** 2) }
g -> (x) { x > 50 ? Failure(:number_too_large) : Success(x) }

# (m >>= f) >>= g

(m.bind(&f)).bind(&g)
# => Success(4)

# m >>= (\x -> f a >>= g)

m.bind do |x|
  f.(x).bind(&g)
end
# => Success(4)
```



## `Dry-Monad` gem Monads
The `dry-monads` gem provides 5 different Monads:

- `Maybe`- for nil-safe computations, used to represent failure
- `Result`, also known as `Either` - for expressing errors using types and result objects.
- `Try` - to describe computations which may result in an exception
- `List` - for idiomatic typed lists representing carrying multiple values
- `Task` - for asynchronous operations

## `Result`

The `Result` type has become very popular in Railway Oriented Programming where you chain steps, or computations together that you expect to fail at some point.

`Result` provides two constructors `Failure(a)` and `Success(b)`.

It provides a `bind` method that allows you to compose computations by applying a block the value inside the `Success` monad.

```ruby
require 'monads/dry/result'
extend Dry::Monads::Result::Mixin

def foo(x)
  Success(x).bind do |value|
    Success(value ** 2)
  end.bind do |value|
    if value > 50
      Failure(:number_too_large)
    else
      Success(value)
    end
  end
end

foo(5)
# => Success(25)

foo(10)
# => Failure(:number_too_large)
```

Note that:
- `foo` is called with the argument `x` and that argument is wrapped in the `Success` Monad.
- Thereafter `value` refers to the value contained inside the `Success` Monad, the result of the previous computation.
- Chaining `.bind do |value|` on the previous `Return` block allows an additional computation using `value`.
- The block *must* return a `Result` Monad (`Success` or `Failure`)
- You cannot chain `#bind` on to a `Failure` Result, it doesn't do anything.

