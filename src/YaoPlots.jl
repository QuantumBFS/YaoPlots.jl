# YaoPlots.jl 
#This is a component package module for [Yao.jl](https://github.com/QuantumBFS/Yao.jl)

# User can run using YaoPlots using export plot function. Exports are the public API: internal functionality should not be export. Anything else must be qualified by  package name (YaoPlots.not_exported).ed!
export Plot, output_string, added_function 


# __precompile__()
# Option to disable precompile package
# __precompile__(false)

module YaoPlots

using Yao, Compose, Colors, Measures

# This module contains the end user facing API for drawing quantum circuits.
# There are multiple backends available:
#
#   Luxor.jl
#   PyPlot.jl
#   PlotlyJS.jl
#   GR.jl
#   UnicodePlots.jl
#   Gadfly.jl
#   VegaLite.jl
#   Compoise.jl 
#
# Final port export is a function to drawing a quantum circuit object with any of the backends.
"""


# Define abstract types ???
abstract AbstractMyType
abstract AbstractMyType2 <: AbstractMyType
"""
    AbstractBlock
Abstract type for quantum circuit blocks.
"""
abstract type AbstractBlock{N} 
end



# File includes
include("output_string.jl")
include("YaoPlots.jl")
include("utils.jl")


end # YaoPlots


