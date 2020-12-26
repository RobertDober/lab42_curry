[![Gem Version](https://badge.fury.io/rb/lab42_curry.svg)](http://badge.fury.io/rb/lab42_curry)
![CI](https://github.com/robertdober/lab42_curry/workflows/CI/badge.svg)

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
    let(:add_to_30) { curry(:adder, rt_arg, 3)  } 
```
Then we see that
```ruby
    expect( add_to_30.(1, 5) ).to eq(531)
```
#### Total control over argument order...

... can be achieved by passing the index of the positional argument to be used into `Lab42::Curry.runtime_arg` 

Given the total reorder form
```ruby
    let(:mul_decrement) { curry(:adder, runtime_arg(2), runtime_arg(0), 1) } # now first argument is c (index 2) and second a (index 0) and b = 1
```
Then we have
```ruby
    expect( mul_decrement.(2, 3) ).to eq(213)
```

#### Picking a positon for a compiletime argument

It might be cumbersome to write things like: `curry(..., rt_arg, rt_arg, ..., rt_arg, 42)` 

Therefore we can express the same much more concisely with `Lab42::Curry.compiletime_args`, and its alias `ct_args` 

Given
```ruby
    let(:doubler) { curry(:adder, ct_args(2 => 2)) } # same as curry(:adder, rt_arg, rt_arg, 2)
```
Then we get
```ruby
    expect( doubler.(4, 3) ).to eq(234)
```

**N.B.** that we could have defined `add_to_30` as `curry(:adder, rt_arg, 3, rt_arg)` of course


#### Error Handling

When you indicate values for the same position multiple times 
Then the `ArgumentCompiler` saves you:
```ruby
    expect{ curry(:adder, 1, ct_args(0 => 1)).() }.to raise_error(Lab42::Curry::DuplicatePositionSpecification)
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
# LICENSE

Copyright 2020,1 Robert Dober robert.dober@gmail.com

Apache-2.0 [c.f LICENSE](LICENSE)
