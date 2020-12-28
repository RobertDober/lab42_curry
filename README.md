[![Gem Version](http://img.shields.io/gem/v/lab42_curry.svg)](https://rubygems.org/gems/lab42_curry)
[![CI](https://github.com/robertdober/lab42_curry/workflows/CI/badge.svg)](https://github.com/robertdober/lab42_curry/actions)
[![Coverage Status](https://coveralls.io/repos/github/RobertDober/lab42_curry/badge.svg?branch=master)](https://coveralls.io/github/RobertDober/lab42_curry?branch=master)

# Lab42::Curry

Name says it all..

Curry functions and methods at will, reorder, define placeholders anywhere, positional and named args

**N.B.** All these code examples are verified with [the speculate_about gem](https://rubygems.org/gems/speculate_about/)

## So what does it do?

### Context Positional Parameters

The simplest and classical way to curry a function (I include _methods_ when I say function) is by providing the first
`n` parameters to a function needing `m` parameters and thusly defining a function that needs now `m - n` parameters.

Given such a simple funcion
```ruby
    def adder(a, b, c); a + 10*b + 100*c end
    let(:add_to_1) {curry(:adder, 1)}
    # Equivalent to Elixir's &adder(1, &1, &2)
```
**N.B.** that `Lab42::Curry` has been included into Examples **and** ExampleGroups in `spec/spec_helper.rb`

Then very unsurprisingly:
```ruby
    expect(add_to_1.(2, 3)).to eq(321)
```

We call the arguments passed into `curry` the _compiletime arguments_, and the arguments passed into the
invocation of the _curried function_, which has been returned by the invocation of `curry`, the _runtime arguments_.

In our case the _compiletime arguments_ were `[1]`  and the _runtime arguments_ were `[2, 3]`

### Reordering

There are several methods of reordering arguments, the simplest is probably using _placeholders_.

When a placeholder is provided (`Lab42::Curry.runtime_arg` aliased as `rt_arg` )
```ruby
    let(:add_to_30) { curry(:adder, rt_arg, 3) }
    # Equivalent to Elixir's &adder(&1, 3, &2)
```
Then we see that
```ruby
    expect( add_to_30.(1, 5) ).to eq(531)
```
#### Total control over argument order...

... can be achieved by passing the index of the positional argument to be used into `Lab42::Curry.runtime_arg`

Given the total reorder form
```ruby
    let(:twohundred_three) { curry(:adder, runtime_arg(2), runtime_arg(0), 1) }
    # now first argument is c (index 2) and second a (index 0) and b = 1
    # Like Elixir's &adder(&2, 1, &1)
```
Then we have
```ruby
    expect( twohundred_three.(2, 3) ).to eq(213)
```

#### Picking a position for a compiletime argument

It might be cumbersome to write things like: `curry(..., rt_arg, rt_arg, ..., rt_arg, 42)`

Therefore we can express the same much more concisely with `Lab42::Curry.compiletime_args`, and its alias `ct_args`

Given
```ruby
    let(:twohundred) { curry(:adder, ct_args(2 => 2)) }
    # same as curry(:adder, rt_arg, rt_arg, 2)
```
Then we get
```ruby
    expect( twohundred.(4, 3) ).to eq(234)
```

**N.B.** that we could have defined `add_to_30` as `curry(:adder, rt_arg, 3, rt_arg)` of course


#### Error Handling

When you indicate values for the same position multiple times
Then the `ArgumentCompiler` saves you:
```ruby
    expect{ curry(:adder, 1, ct_args(0 => 1)) }.to raise_error(Lab42::Curry::DuplicatePositionSpecification)
```

### Context With proc like objects

Given a lambda
```ruby
    let(:sub) { ->{ _1 - _2} }
    let(:inverse) { curry(sub, rt_arg(1), rt_arg) }
```
Then we will get the negative value
```ruby
    expect( inverse.(2, 1) ).to eq(-1)
```

### Context Keyword Arguments

Given a function which takes keyword arguments like the following
```ruby
    def rectangle(length, width, border: 0, color: )
      [length, width, border, color]
    end
    let(:red_rectangle) { curry(:rectangle, color: :red) }
    let(:wide_bordered) { curry(:rectangle, rt_arg, 999, border: 1) }
```

Then the red rectangle gives us
```ruby
    expect( red_rectangle.(1, 2) ).to eq([1, 2, 0, :red])
    expect( red_rectangle.(1, 2, border: 1) ).to eq([1, 2, 1, :red])
```

Can we override curried values, normally not
Example: cannot override
```ruby
    expect{ red_rectangle.(1, 2, color: :blue) }
      .to raise_error(
        Lab42::Curry::DuplicateKeywordArgument,
        "keyword argument :color is already defined with value :red cannot override with :blue")
```

But we can create a more lenient curry with `curry!`
```ruby
  expect( curry!(:rectangle, 1, 2, color: :red ).(color: :blue) )
    .to eq([1, 2, 0, :blue])
```

### Context Currying Blocks

Often times it is the block which might be the fixed point in a series of computations, for
that reason we will curry a block

Given a function that takes a block
```ruby
    let(:sub_with) { ->(a, b, &blk) { blk.(a - b) } }
    let(:double_diff) { curry( sub_with ) { _1 * 2 } }
```
Then it does just that
```ruby
     expect( double_diff.(22, 1)  ).to eq(42)
```
And of course we can also curry a positional argument
```ruby
    triple_dec = curry( sub_with, rt_arg, 1 ) { _1 * 3 } 
    expect( triple_dec.(15) ).to eq(42)
```

#### Currying on Unbound Methods


Can be a very useful exercise, we will see that `curry` creates a curred function that will bind when called

Given the classical map example:
```ruby
   let(:incrementer) { curry(Enumerable.instance_method(:map)) { _1 + 1} }
```

Then we can use it by  binding it to an `Enumerable` object
```ruby
    expect( incrementer.([1, 2]) ).to eq([2, 3])
```

But we must not provide a block **again**
```ruby
    expect{ incrementer.([]) {_1 + 2} }
      .to raise_error(
        Lab42::Curry::DuplicateBlock,
        "block has already been curried")
```

This again can be authorized by using the more lenient `curry!` version
And therefor
```ruby
    maybe_incrementer = curry!(Enumerable.instance_method(:map)) {_1 + 1}
    expect( maybe_incrementer.([1, 2], &:itself) ).to eq([1, 2])
```


# LICENSE

Copyright 2020,1 Robert Dober robert.dober@gmail.com

Apache-2.0 [c.f LICENSE](LICENSE)
