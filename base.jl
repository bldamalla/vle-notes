## for fitting margules coefficients from data

γ1(x1, A21, A12) = exp((A12 + 2(A21 - A12)*x1) * (1-x1)^2)
γ2(x1, A21, A12) = exp((A21 + 2(A12 - A21)*(1-x1)) * x1^2)

## be careful of the units
antoine_vp(T, A, B, C) = 10^(A - B/(T+C))

## load the antoine coefficients
using CSV, DataFrames

# these were apparently calibrated using C and mmHg
df_antoine = CSV.File("data/ethanol-water/antoine.csv") |> DataFrame
antoine_ethanol1 = collect(df_antoine[1,:])
antoine_ethanol2 = collect(df_antoine[2,:])
antoine_water1 = collect(df_antoine[3,:])
antoine_water2 = collect(df_antoine[4,:])

# vapor pressures at 30C
ethanol_satvp = antoine_vp(30, antoine_ethanol1...)
water_satvp = antoine_vp(30, antoine_water1...)
