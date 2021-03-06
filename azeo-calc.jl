## for calculating azeotrope composition

using NLsolve

## Fitted margules constants for 30C, 50C, 90C, 150C (left to right)
## A21 for An[1,:] and A21 for An[2,:]
An = [
    0.945889 0.911357 0.831135 0.831923;
    1.500865 1.602202 1.598779 1.502728
]

include("base.jl")

## calculate vapor pressure at temperature
function pressure(x; T=30,
        antoine_l1=antoine_ethanol1,
        antoine_l2=antoine_water1,
        A=An)
    l1_vp = antoine_vp(T, antoine_l1...)
    l2_vp = antoine_vp(T, antoine_l2...)
    return x * γ1(x, A...) * l1_vp + (1-x) * γ2(x, A...) * l2_vp
end

println("Calculations for 30C:")
println("---------\n")

## Method 1:
function master_eq(x1; T=30, 
        antoine_l1=antoine_ethanol1,
        antoine_l2=antoine_water1,
        A=@view An[:,1])
    l1_vp = antoine_vp(T, antoine_l1...)
    l2_vp = antoine_vp(T, antoine_l2...)
    return γ1(x1[1], A...) * l1_vp - γ2(x1[1], A...) * l2_vp
end

solution1 = nlsolve(master_eq, [1.0]; method=:newton)
println("Nonlinear equation solver solution:")
println(solution1,'\n')

## Method 2:

using Polynomials

function master_eq2(A; T=30, 
        antoine_l1=antoine_ethanol1,
        antoine_l2=antoine_water1)
    A21, A12 = A
    α = 2*A21 - A12; β = -2*(A21 - A12)
    l1_vp = antoine_vp(T, antoine_l1...)
    l2_vp = antoine_vp(T, antoine_l2...)
    return Polynomial([α + β + log(l1_vp/l2_vp), -2α-3β, 3*β/2])
end

solution2 = roots(master_eq2(@view An[:,1]))
println("Polynomial equation solver solution:")
println(solution2)
println("Pressure: ", pressure(solution2[1]; A=@view An[:,1]), '\n')

## use the polynomial solver for the rest of the calculations
println("Polynomial equation solver solutions for higher temperatures:")
println("---------\n")

println("Calculations for 50C:")
T50 = roots(master_eq2(@view An[:,2]; T=50))
println(T50)
println("Pressure: ", pressure(T50[1]; T=50, A=@view An[:,2]), '\n')

println("Calculations for 90C:")
T90 = roots(master_eq2(@view An[:,3]; T=90,
                antoine_l1=antoine_ethanol2))
println(T90)
println("Pressure: ", pressure(T90[1]; T=90,
                antoine_l1=antoine_ethanol2,
                A=@view An[:,3]), '\n')

println("Calculations for 150C:")
T150 = roots(master_eq2(@view An[:,4]; T=150,
                antoine_l1=antoine_ethanol2,
                antoine_l2=antoine_water2))
println(T150)
println("Pressure: ", pressure(T150[1]; T=150,
                antoine_l1=antoine_ethanol2,
                antoine_l2=antoine_water2,
                A=@view An[:,4]), '\n')
