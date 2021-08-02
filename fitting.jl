## for fitting margules coefficients from data

γ1(x1, A21, A12) = exp((A12 + 2(A21 - A12)*x1) * (1-x1)^2)
γ2(x1, A21, A12) = exp((A21 + 2(A12 - A21)*(1-x1)) * x1^2)

## be careful of the units
antoine_vp(T, A, B, C) = 10^(A - B/(T+C))

## load the antoine coefficients
using CSV, DataFrames

# these were apparently calibrated using C and mmHg
df_antoine = CSV.File("data/ethanol-water/antoine.csv") |> DataFrame
antoine_ethanol = collect(df_antoine[1,:])
antoine_water = collect(df_antoine[2,:])

## TODO: HANDLING CONSTANT TEMPERATURE data
# in this case, the saturation vapor pressures are constant
# so all that has to be done is to fit parameters by least
# squares fitting
# as it is only a part of a demonstration, there will be no
# complicated weight function for now; we assume homoskedasticity

# for the constant temperature dataset starting params
A0 = [1.5, 1.5]

function pressure(x1;
            T=30,
            antoine_l1=antoine_ethanol,
            antoine_l2=antoine_water,
            A=A0)
    ## calculate the vapor pressures at the temperature
    l1_vp = antoine_vp(T, antoine_l1...)
    l2_vp = antoine_vp(T, antoine_l2...)
    ## use modified raoult's law to calculate total pressure
    return (l1_vp * γ1(x1, A...) * x1) + (l2_vp * γ2(x1, A...) * (1-x1))
end

## in this case the total pressure of the ethanol water system at 30C 
pressure_etwat30(xs, An) = pressure.(xs; A=An)

using LsqFit

## first is to load the constant temperature data
dataT30 = CSV.File("data/ethanol-water/T30.csv") |> DataFrame
xdata = collect(dataT30[!,:x1])
## pressure data is in kPa so convert to mmHg
Pdata = collect(dataT30[!,:P]) .* (760 / 101.325)

# make the model
model30 = curve_fit(pressure_etwat30, xdata, Pdata, A0)
println(coef(model30))
println(model30.resid)
