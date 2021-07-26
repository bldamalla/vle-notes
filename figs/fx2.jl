## figs/fx2.jl

using Plots; gr()
using LaTeXStrings

f(x) = log(x/(1-x)) / (2x - 1)
g(x) = 2 * x * (1-x) * f(x)

xs = 0.01:0.001:0.99

## start plotting the function

plot(xs, g.(xs); label=nothing)
xlabel!(L"$x_1$")
ylabel!(L"$2x_1x_2f(x_1)$")

savefig("figs/fx2.png")

