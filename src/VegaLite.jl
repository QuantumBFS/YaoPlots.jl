plot(x::AbstractBlock; figsize=(10cm, 1cm), fontsize=10) = VegaLite(context(0, 0, figsize...),

)

plot(x) = VegaLite()