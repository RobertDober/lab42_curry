[![Gem Version](https://badge.fury.io/rb/lab42_curry.svg)](http://badge.fury.io/rb/lab42_curry)


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
# LICENSE

Copyright 2020,1 Robert Dober robert.dober@gmail.com

Apache-2.0 [c.f LICENSE](LICENSE)
