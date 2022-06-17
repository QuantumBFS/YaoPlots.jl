module YaoPlots

export plot

plot(;kwargs...) = x->plot(x;kwargs...)

include("helperblock.jl")
include("vizcircuit.jl")
include("zx_plot.jl")

end
