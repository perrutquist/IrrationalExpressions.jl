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

immutable IrrationalExpr{op, TU<:Tuple} <: Real
  args::TU
end

@generated convert{T<:AbstractFloat,op,TU}(::Type{T}, x::IrrationalExpr{op,TU}) =
  Expr(:call, op, [Expr(:call, :convert, T, :( x.args[$i] )) for i=1:length(TU.parameters)]...)

promote_rule{T1<:AbstractFloat, T2<:IrrationalExpr}(::Type{T1}, ::Type{T2}) = T1

## Unary operators
(+)(x::IrrationalExpr) = x
(-)(x::IrrationalExpr) = IrrationalExpr{:(-),Tuple{IrrationalExpr}}((x,))
(-)(x::Irrational) = IrrationalExpr{:(-),Tuple{Irrational}}((x,))

## Binary operators
ops = (:(+), :(-), :(*), :(/))
types = (IrrationalExpr, Irrational, Rational, Integer, Bool)
for op in ops, i in eachindex(types), j in eachindex(types)
  if i<=2 || j<=2
    @eval $op(x::$(types[i]), y::$(types[j])) = IrrationalExpr{Symbol($op),Tuple{$(types[i]),$(types[j])}}((x,y))
  end
end

# Utility function for converting to Expr in a way that makes
# the string generation work as intended.
getsym(x) = x
getsym{sym}(::Irrational{sym}) = sym

# We define conversion to Expr as a conveninent way to get strings,
# but this also alows eval(convert(Expr, x)) as a roundabout way to get x.
convert{op,TU}(::Type{Expr}, x::IrrationalExpr{op,TU}) =
  Expr(:call, op, map(getsym,x.args)...)

show(io::IO, x::IrrationalExpr) = print(io, string(convert(Expr, x)), " ≈ ", Float64(x))

end # module
