using Documenter
using YaoPlots

makedocs(
    modules = [YaoPlots],
    sitename = "YaoPlots",
    format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true"),
    pages    = Any[
        "Introduction to YaoPlots" => "index.md",
        "Circuit Examples"        => "examples.md",
        "Basic concepts"          => "basics.md",
        "Colors and styles"       => "colors-styles.md",
        "Animation"               => "animation.md",
        "Index"                   => "functionindex.md"
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
deploydocs(
    repo = "https://github.com/QuantumBFS/YaoPlots.jl.git",
    target = "build"
)

