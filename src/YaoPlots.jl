# YaoPlots.jl Package Main Module Outline

# import Pkg; Pkg.add("Yao")
# import Pkg; Pkg.add("Compose")

# Set  package to precompile
__precompile__()
# If not going to precompile package, use option to disable it
# __precompile__(false)

module YaoPlots

# At the top of the package module, import dependencies:
using Yao, Compose, Colors, Measures


# Define abstract types ???
abstract AbstractMyType
abstract AbstractMyType2 <: AbstractMyType

# What functionality is exported by a package: Only values which are exported enter the namespace, anything else must be qualified by the package name (ExamplePackage.not_exported).
# Exports are the public API: internal functionality should not be exported!

export plot, output_string, added_function # User can run using YaoPlots using export plot function 
 


# Code in other files
include("output_string.jl")
include("compose_demo_v2.jl")
include("utils.jl")


end # module


