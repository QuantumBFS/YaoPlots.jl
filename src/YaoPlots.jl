module YaoPlots

export plot
using Yao, Compose, Colors, Measures

function square(ctx, name)
    compose(ctx,
        (context(), text(0.5, 0.5, name, hcenter, vcenter), font("Helvetica-Bold")),
        (context(), rectangle(), fill("transparent"), stroke("black")),
    )
end

line_position(n, k) = grid_height(n) / 2 + (k - 1) * (interval_v(n) + grid_height(n))

function connector(ctx::Context, x0, x1, xs, ys)
    @assert length(xs) == length(ys) "number of qubits mismatch"
    out = compose(ctx); n = length(xs)
    for (x, y) in zip(xs, ys)
        compose!(out, (context(), line([(x0, line_position(n, x)), (x1, line_position(n, y))]), stroke("black")))
    end
    return out
end

plot(x::AbstractBlock; figsize=(10cm, 1cm), fontsize=10) = compose(context(0, 0, figsize...),
    connector(context(0.0, 0), 0, 0.1, 1:nqubits(x), 1:nqubits(x)),
    (context(0.1, 0, 0.8, 1), x, Compose.fontsize(fontsize)),
    connector(context(0.9, 0), 0, 0.1, 1:nqubits(x), 1:nqubits(x))
)

Compose.compose(ctx::Context, x::AbstractBlock) = compose!(copy(ctx), x)
Compose.compose!(ctx::Context, x::HGate) = square(ctx, "H")
Compose.compose!(ctx::Context, x::XGate) = square(ctx, "X")

grid_width(l::Int; α=0.4) = 1/(l * exp(α * (l - 1)))
interval_h(l::Int; α=0.4) = l == 1 ? 0 : (exp(α * (l - 1)) - 1) / ((l - 1) * exp(α * (l - 1)))

grid_height(n::Int; α=0.4) = 1/(n * exp(α * (n - 1)))
interval_v(n::Int; α=0.4) = n == 1 ? 0 : (exp(α * (n - 1)) - 1) / ((n - 1) * exp(α * (n - 1)))

function Compose.compose!(ctx::Context, blk::ChainBlock)
    x = 0.0; n = nqubits(blk); l = length(blk)
    out = compose(ctx)

    for (k, each) in enumerate(subblocks(blk))
        out = compose!(out, (context(x, 0, grid_width(l), 1), each))
        prev_x = x # store x to plot lines later
        x = x + (interval_h(l) + grid_width(l))

        if k != lastindex(blk)
            out = compose!(out, connector(context(), prev_x + grid_width(l), x, 1:n, 1:n))
        end
    end
    return out
end

function Compose.compose!(ctx::Context, blk::KronBlock)
    out = compose(ctx)
    y = 0; n = nqubits(blk)
    for k in 1:n
        if k in occupied_locs(blk)
            out = compose!(out, (context(0, y, 1, grid_height(n)), blk[k]))
        else
            out = compose!(out,
                (context(0, y + grid_height(n)/2), line([(0, 0), (1, 0)]), stroke("black"))
            )
        end
        y += interval_v(n) + grid_height(n)
    end
    return out
end

end # module
