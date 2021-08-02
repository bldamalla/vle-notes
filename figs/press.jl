## figs/press.jl

# fixed temp margules parameters at 30C
A21=0.9459; A12=1.5009;
A = [A21, A12];

γ1(x1, A21, A12) = exp((A12 + 2(A21 - A12)*x1) * (1-x1)^2)
γ2(x1, A21, A12) = exp((A21 + 2(A12 - A21)*(1-x1)) * x1^2)

xs = 0.0:0.01:1.00

using CSV, DataFrames

df_antoine = CSV.File("data/ethanol-water/antoine.csv") |> DataFrame
antoine_ethanol = collect(df_antoine[1,:])
antoine_water = collect(df_antoine[2,:])

antoine_vp(T, A, B, C) = 10^(A - B/(T+C))
ethanol_satvp = antoine_vp(30, antoine_ethanol...)
water_satvp = antoine_vp(30, antoine_water...)

function pressure(x1)
    return x1 * ethanol_satvp * γ1(x1, A...) + 
        (1-x1) * water_satvp * γ2(x1, A...)
end

df_press = CSV.File("data/ethanol-water/T30.csv") |> DataFrame
xdata = collect(df_press[!,:x1])
Pdata = collect(df_press[!,:P]) .* (760 / 101.325)

using Plots, LaTeXStrings; gr()

plot(xs, @. xs * ethanol_satvp; label=nothing, linestyle=:dash, color=:blue)
plot!(xs, @. (1-xs) * water_satvp; label=nothing, linestyle=:dash, color=:orange)
plot!(xs, @. xs * (ethanol_satvp - water_satvp) + water_satvp; label=nothing,
    linestyle=:dash, color=:red)

plot!(xs, @. xs * ethanol_satvp * γ1(xs, A...); label="EtOH", color=:blue)
plot!(xs, @. (1-xs) * water_satvp * γ2(xs, A...); label="Water", color=:orange)
plot!(xs, pressure.(xs); label="Total", color=:red)
scatter!(xdata, Pdata; label="Data", color=:green)
plot!([0,1], [ethanol_satvp, ethanol_satvp]; linestyle=:dot, label="EtOH sat press")
plot!(;legenf=:bottomright)
xlabel!("Liquid ethanol mole fraction")
ylabel!("Total vapor pressure (mmHg)")

lens!([0.9, 1], [77, 79], inset=(1, bbox(0.60, 0.33, 0.3, 0.3)))

plot!(;legend=:outertopright)

savefig("figs/press.png")
