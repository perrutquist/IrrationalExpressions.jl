# IrrationalExpressions.jl

[![Build Status](https://travis-ci.org/perrutquist/IrrationalExpressions.jl.svg?branch=master)](https://travis-ci.org/perrutquist/IrrationalExpressions.jl)

[![Coverage Status](https://coveralls.io/repos/perrutquist/IrrationalExpressions.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/perrutquist/IrrationalExpressions.jl?branch=master)

[![codecov.io](http://codecov.io/github/perrutquist/IrrationalExpressions.jl/coverage.svg?branch=master)](http://codecov.io/github/perrutquist/IrrationalExpressions.jl?branch=master)

IrrationalExpressions is a Julia module that makes expressions like `2π` behave as irrational numbers, rather than `Float64`.

Julia has a few irrational constants, like `π` and `e`. Arbitrary precision packages, like BigFloat, may provide conversion methods that yield these constants with the desired precision. However, any arithmetic operation that happens before conversion defaults to Float64, and this may lead to subtle bugs. For example, `2π*x` will only be correct to about 16 decimal places, even if `x` has higher precision. It must be written as `2(π*x)`.

```
julia> BigFloat(π) + BigFloat(-π) # We might expect this to be 0.
1.224646799147353177226065932275001058209749445923078164062861980294536250318213e-16

julia> typeof(-π)
Float64

julia> using IrrationalExpressions
<A bunch of warnings...>

julia> BigFloat(π) + BigFloat(-π)
0.000000000000000000000000000000000000000000000000000000000000000000000000000000

julia> typeof(-π)
IrrationalExpressions.IrrationalExpr
```

Loading this module will generate a number of warnings about methods being overwritten.
It would be nice to be able to turn these warnings off. See https://github.com/JuliaLang/julia/pull/14759
