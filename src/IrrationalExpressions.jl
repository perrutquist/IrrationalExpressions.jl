"""
A module that makes expressions like `-π` behave like Irrational, rather
than Float64.

Generates IrrationalExpr objects when arithmetic operations are applied to
objects of type Irrational, and these operations are carried out in the
destination type when type conversion occurs.

For example, `BigFloat(π) + BigFloat(-π)` will evaluate to BigFloat(0),
rather than to approximately 1.2e-16.
"""

module IrrationalExpressions

# This module has no exports (for now).

import Base: +, -, *, /, convert, promote_rule

immutable IrrationalExpr <: Number
  op::Symbol
  args::Tuple
end

convert{T<:AbstractFloat}(::Type{T}, x::IrrationalExpr) =
  eval(Expr(:call, x.op, map(a->convert(T,a), x.args)...))

promote_rule{T<:AbstractFloat}(::Type{T}, ::Type{IrrationalExpr}) = T

## Unary operators
(+)(x::IrrationalExpr) = x
(-)(x::IrrationalExpr) = IrrationalExpr(:(-), (x,))
(-)(x::Irrational) = IrrationalExpr(:(-), (x,))

## Binary operators
ops = (:(+), :(-), :(*), :(/))
types = (Irrational, IrrationalExpr, Integer, Rational)
for op in ops, i in eachindex(types), j in eachindex(types)
  if i<=2 || j<=2
    @eval $op(x::$(types[i]), y::$(types[j])) = IrrationalExpr(Symbol($op), (x,y))
  end
end

end # module
