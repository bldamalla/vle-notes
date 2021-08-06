## figs/press.jl

# fixed temp margules parameters at 90C
A21=0.8311; A12=1.5988;
A = [A21, A12];

## range and resolution of plotting area
xs = 0.0:0.01:1.00

include("../base.jl")

function pressure(x1)
    return x1 * ethanol_satvp * γ1(x1, A...) + 
        (1-x1) * water_satvp * γ2(x1, A...)
end

df_press = CSV.File("data/ethanol-water/T90.csv") |> DataFrame
xdata = collect(df_press[!,:x1])
Pdata = collect(df_press[!,:P]) .* (760 / 101.325)

ethanol_satvp = antoine_vp(90, antoine_ethanol2...)
water_satvp = antoine_vp(90, antoine_water1...)

using Plots; gr()

plot(xs, @. xs * ethanol_satvp; label=nothing, linestyle=:dash, color=:blue)
plot!(xs, @. (1-xs) * water_satvp; label=nothing, linestyle=:dash, color=:orange)
plot!(xs, @. xs * (ethanol_satvp - water_satvp) + water_satvp; label=nothing,
    linestyle=:dash, color=:red)

plot!(xs, @. xs * ethanol_satvp * γ1(xs, A...); label="EtOH", color=:blue)
plot!(xs, @. (1-xs) * water_satvp * γ2(xs, A...); label="Water", color=:orange)
plot!(xs, pressure.(xs); label="Total", color=:red)
scatter!(xdata, Pdata; label="Data", color=:green)
plot!([0,1], [ethanol_satvp, ethanol_satvp]; linestyle=:dot, label="EtOH sat press")
xlabel!("Liquid ethanol mole fraction")
ylabel!("Total vapor pressure (mmHg)")

lens!([0.9, 1], [1180, 1200], inset=(1, bbox(0.60, 0.33, 0.3, 0.3)))

plot!(;legend=:outertopright)

savefig("figs/pressT90.png")
