using IrrationalExpressions
using Base.Test

@test BigFloat(-π) == -BigFloat(π)
@test BigFloat(-(-π)) == BigFloat(π)
@test BigFloat(2π+1//3) == BigFloat(2)*BigFloat(π)+BigFloat(1//3)

@test isa(π, Irrational)
@test isa(π+1, IrrationalExpressions.IrrationalExpr)
@test isa(π+1.0, Float64)
@test isa(2π+1.0, Float64)
@test isa(π+BigFloat(1), BigFloat)
@test +(1+π) == 1+π
@test string(1+pi) == "1 + π = 4.1415926535897..."
@test string(2π+0.0) == "6.283185307179586"
@test string(2π+BigFloat(0)) == "6.283185307179586476925286766559005768394338798750211641949889184615632812572396"
