using IrrationalExpressions
using Base.Test

@test BigFloat(-π) == -BigFloat(π)
@test BigFloat(2π+1//3) == BigFloat(2)*BigFloat(π)+BigFloat(1//3)

@test isa(π, Irrational)
@test isa(π+1, IrrationalExpressions.IrrationalExpr)
@test isa(π+1.0, Float64)

@test string(1+pi) == "1 + π = 4.1415926535897..."
