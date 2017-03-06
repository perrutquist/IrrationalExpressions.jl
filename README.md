# IrrationalExpressions.jl

[![Build Status](https://travis-ci.org/perrutquist/IrrationalExpressions.jl.svg?branch=master)](https://travis-ci.org/perrutquist/IrrationalExpressions.jl)

[![Coverage Status](https://coveralls.io/repos/perrutquist/IrrationalExpressions.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/perrutquist/IrrationalExpressions.jl?branch=master)

[![codecov.io](http://codecov.io/github/perrutquist/IrrationalExpressions.jl/coverage.svg?branch=master)](http://codecov.io/github/perrutquist/IrrationalExpressions.jl?branch=master)

IrrationalExpressions is a Julia module that makes expressions like `2π` behave as irrational numbers, rather than `Float64`.

## The Problem

Julia has a few irrational constants, like `π` and `e`. Arbitrary precision packages, like BigFloat, may provide conversion methods that yield these constants with the desired precision. However, any arithmetic operation that happens before conversion defaults to `Float64`.
```
julia> BigFloat(π) + BigFloat(-π)
1.224646799147353177226065932275001058209749445923078164062861980294536250318213e-16

julia> typeof(-π)
Float64
```
This may lead to subtle bugs. For example, `2π*x` will only be correct to about 16 decimal places, even if `x` has higher precision. It must be written as `2(π*x)` in order to get the precision of `x`.

## The Solution

With `IrrationalExpressions`, arithmetic operations don't immediately force conversion to Float64. Instead the expression is kept unevaluated until the target type is known.

```
julia> using IrrationalExpressions
<A bunch of warnings...>

julia> -pi
-π ≈ -3.141592653589793

julia> BigFloat(π) + BigFloat(-π)
0.000000000000000000000000000000000000000000000000000000000000000000000000000000
```

## Supported Operations

`+`, `-`, `*` and `/` are currently supported.

Downconversion occurs when a floating point value is encountered. The resulting type is that of the floating point value.

```
julia> 2*pi
2π ≈ 6.283185307179586

julia> 2*pi + 0.0
6.283185307179586

julia> 2*pi + BigFloat(0)
6.283185307179586476925286766559005768394338798750211641949889184615632812572396
```

Functions in `Base.Math` typically convert to `Float64` when encountering an unknown subtype of `Real`.

```
julia> cos(2π)
1.0

julia> typeof(ans)
Float64
```

## Supported Types

`Integer`, `Rational` and `Irrational` can be used to build irrational expressions.
Care must be taken so that floats are not accidentally created. `(1//2)π` is an `IrrationalExpr`, but `(1/2)π` is a `Float64`.

New floating-point types need not explicitly support conversion from `IrrationalExpr`.
Any subtype of `AbstractFloat` that has conversions from `Integer`, `Rational` and `Irrational` along with the necessary arithmetic operations is automatically supported. (However, it may be necessary to add methods to `convert` and/or `promote_rule` to disambiguate if both classes have general conversions.)

## To-Do-List

* It would be possible to extend this to things like `sqrt(Integer)`, `Integer^Rational`, etc.
* Support for complex-valued irrational expressions, like `pi * im` is still missing.

## Note

Loading this module will generate a number of warnings about methods being overwritten.
It would be nice to be able to turn these warnings off. See https://github.com/JuliaLang/julia/pull/14759
