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

import Base: +, -, *, /, convert, promote_rule, show

immutable IrrationalExpr{op, N} <: Real
  args::NTuple{N,Union{IrrationalExpr, Irrational, Rational, Integer}}
end

@generated convert{T<:AbstractFloat,op,N}(::Type{T}, x::IrrationalExpr{op,N}) =
  Expr(:call, op, [Expr(:call, :convert, T, :( x.args[$i] )) for i=1:N]...)

promote_rule{T1<:AbstractFloat, T2<:IrrationalExpr}(::Type{T1}, ::Type{T2}) = T1
promote_rule{T2<:IrrationalExpr}(::Type{BigFloat}, ::Type{T2}) = BigFloat

## Unary operators
(+)(x::IrrationalExpr) = x
(-)(x::IrrationalExpr) = IrrationalExpr{:(-),1}((x,))
(-)(x::Irrational) = IrrationalExpr{:(-),1}((x,))

## Binary operators
ops = (:(+), :(-), :(*), :(/))
types = (IrrationalExpr, Irrational, Rational, Integer)
for op in ops, i in eachindex(types), j in eachindex(types)
  if i<=2 || j<=2
    @eval $op(x::$(types[i]), y::$(types[j])) = IrrationalExpr{Symbol($op),2}((x,y))
  end
end

# We define getexpr() as a conveninent middle step to get to strings,
# but this also allows eval(getexpr(x)) as a roundabout way to get x.
getexpr(x) = x
getexpr{sym}(::Irrational{sym}) = sym
getexpr{op,N}(x::IrrationalExpr{op,N}) = Expr(:call, op, map(getexpr,x.args)...)

show(io::IO, x::IrrationalExpr) = print(io, string(getexpr(x)), " = ", string(Float64(x))[1:end-2], "...")

end # module
