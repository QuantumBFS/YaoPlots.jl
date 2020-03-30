plot(x::AbstractBlock; figsize=(10cm, 1cm), fontsize=10) = PlotlyJS(context(0, 0, figsize...),

)

plot(x) = PlotlyJS()