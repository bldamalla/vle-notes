## for calculating azeotrope composition

using NLsolve

An = [0.9459, 1.5009] ## A21, A12

include("base.jl")

## Method 1:
function master_eq(x1; T=30, 
        antoine_l1=antoine_ethanol,
        antoine_l2=antoine_water,
        A=An)
    l1_vp = antoine_vp(T, antoine_l1...)
    l2_vp = antoine_vp(T, antoine_l2...)
    return γ1(x1[1], A...) * l1_vp - γ2(x1[1], A...) * l2_vp
end

solution1 = nlsolve(master_eq, [1.0]; method=:newton)

## Method 2:

using Polynomials

function master_eq3(; T=30, 
        antoine_l1=antoine_ethanol,
        antoine_l2=antoine_water,
        A=An)
    A21, A12 = A
    α = 2*A21 - A12; β = -2*(A21 - A12)
    println(α,β)
    l1_vp = antoine_vp(T, antoine_l1...)
    l2_vp = antoine_vp(T, antoine_l2...)
    println(α + β + log(l1_vp/l2_vp))
    return Polynomial([α + β + log(l1_vp/l2_vp), -2α-3β, 3*β/2])
end

solution3 = roots(master_eq3())
