## figs/fx1.jl

using Plots; gr()
using LaTeXStrings

f(x) = log(x/(1-x)) / (2x - 1)

xs = 0.01:0.001:0.99

## start plotting the function

plot(xs, f.(xs); label=nothing)
xlabel!(L"$x_1$")
ylabel!(L"$f(x_1)$")

savefig("figs/fx1.png")

