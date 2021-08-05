## TODO: HANDLING CONSTANT TEMPERATURE data
# in this case, the saturation vapor pressures are constant
# so all that has to be done is to fit parameters by least
# squares fitting
# as it is only a part of a demonstration, there will be no
# complicated weight function for now; we assume homoskedasticity

# for the constant temperature dataset starting params
A0 = [1.5, 1.5]

include("base.jl")

function pressure(x1;
            T=30,
            antoine_l1=antoine_ethanol1,
            antoine_l2=antoine_water1,
            A=A0)
    ## calculate the vapor pressures at the temperature
    l1_vp = antoine_vp(T, antoine_l1...)
    l2_vp = antoine_vp(T, antoine_l2...)
    ## use modified raoult's law to calculate total pressure
    return (l1_vp * γ1(x1, A...) * x1) + (l2_vp * γ2(x1, A...) * (1-x1))
end

pressure_etwat30(xs, An) = pressure.(xs; A=An)
pressure_etwat50(xs, An) = pressure.(xs; T=50, A=An)
pressure_etwat90(xs, An) = pressure.(xs; T=90,
        antoine_l1=antoine_ethanol2,
        A=An)
pressure_etwat150(xs, An) = pressure.(xs; T=150,
        antoine_l1=antoine_ethanol2,
        antoine_l2=antoine_water2,
        A=An)

using LsqFit

## first is to load the constant temperature data
dataT30 = CSV.File("data/ethanol-water/T30.csv") |> DataFrame
xdataT30 = collect(dataT30[!,:x1])
## pressure data is in kPa so convert to mmHg
PdataT30 = collect(dataT30[!,:P]) .* (760 / 101.325)

## here are other constant temperature data
dataT50 = CSV.File("data/ethanol-water/T50_2.csv") |> DataFrame
xdataT50 = collect(dataT50[!,:x1])
PdataT50 = collect(dataT50[!,:P]) .* (760 / 101.325)

dataT90 = CSV.File("data/ethanol-water/T90_2.csv") |> DataFrame
xdataT90 = collect(dataT90[!,:x1])
PdataT90 = collect(dataT90[!,:P]) .* (760 / 101.325)

dataT150 = CSV.File("data/ethanol-water/T150.csv") |> DataFrame
xdataT150 = collect(dataT150[!,:x1])
PdataT150 = collect(dataT150[!,:P]) .* (760 / 101.325)

# make the models
println("Fitting for constant temperature VLE data: 30C")
model30 = curve_fit(pressure_etwat30, xdataT30, PdataT30, A0)
println(coef(model30))
println(model30.resid ./ PdataT30)

println("Fitting for constant temperature VLE data: 50C")
model50 = curve_fit(pressure_etwat50, xdataT50, PdataT50, A0)
println(coef(model50))
println(model50.resid ./ PdataT50)

println("Fitting for constant temperature VLE data: 90C")
model90 = curve_fit(pressure_etwat90, xdataT90, PdataT90, A0)
println(coef(model90))
println(model90.resid ./ PdataT90)

println("Fitting for constant temperature VLE data: 150C")
model150 = curve_fit(pressure_etwat150, xdataT150, PdataT150, A0)
println(coef(model150))
println(model150.resid ./ PdataT150)
