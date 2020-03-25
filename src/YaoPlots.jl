compose_demo_v2.jl

# plots a demo quantum circuit in julia with compose julia framework 
# Greenberger-Horne-Zeilinger (GHZ) state with Quantum Circuit 

# import Pkg; Pkg.add("Yao")
# import Pkg; Pkg.add("Compose")
# using Compose
# using Yao, Compose, Colors, Measures

module YaoPlots

export plot
using Yao, Compose, Colors, Measures

# Size of quantum circuit 
set_default_graphic_size(14cm,4cm)

# square(ctx, name) where name = name of your quantum circuit 
function square(ctx, name)
    compose(ctx,
        (context(), text(0.5, 0.5, name, hcenter, vcenter), font("Helvetica-Bold")),
        (context(), rectangle(), fill("transparent"), stroke("black")),
    )
end

line_position(n, k) = grid_height(n) / 2 + (k - 1) * (interval_v(n) + grid_height(n))

# connector() plots the dash lines connecting the boxes for
# :: A return type can also be specified in the function declaration using the :: operator. This converts the return value to the specified type.

function connector(ctx::Context, x0, x1, xs, ys)
    @assert length(xs) == length(ys) "number of qubits mismatch"
    out = compose(ctx); n = length(xs)
    # xs,ys = list for size of circuit
    for (x, y) in zip(xs, ys)
        compose!(out, (context(), line([(x0, line_position(n, x)), (x1, line_position(n, y))]), stroke("black")))
    end
    return out
end

# AbstractBlock = data type declaration the block representing the quantum circuit 
# Currently only takes 1 qubit
plot(x::AbstractBlock; figsize=(10cm, 1cm), fontsize=10) = compose(context(0, 0, figsize...),
    connector(context(0.0, 0), 0, 0.1, 1:nqubits(x), 1:nqubits(x)),
    compose(context(0.1, 0, 0.8, 1), x),
    connector(context(0.9, 0), 0, 0.1, 1:nqubits(x), 1:nqubits(x))
)

plot(x) = compose()


# Add gates - TODO: right now only have X and H 
Compose.compose(ctx::Context, x::AbstractBlock) = compose!(copy(ctx), x)
Compose.compose(ctx::Context, x::AbstractBlock) = compose!(copy(ctx), x)
Compose.compose!(ctx::Context, x::XGate) = square(ctx, "X") # Pauli X
Compose.compose!(ctx::Context, x::YGate) = square(ctx, "Y") # Pauli Y
Compose.compose!(ctx::Context, x::ZGate) = square(ctx, "Z") # Pauli Z
Compose.compose!(ctx::Context, x::HGate) = square(ctx, "H") # Hadamard H
Compose.compose!(ctx::Context, x::MGate) = square(ctx, "M") # Measurement Gate [M symbol]

# Do not work yet
# Compose.compose!(ctx::Context, x::SGate) = square(ctx, "S") # Phase(S,P)
# Compose.compose!(ctx::Context, x::TGate) = square(ctx, "T") # pi/8 (T)
# Compose.compose!(ctx::Context, x::CNOTGate) = square(ctx, "CNOT") # Controlled Not
# Compose.compose!(ctx::Context, x::CZGate) = square(ctx, "CZ") # Controlled Z 
# Compose.compose!(ctx::Context, x::SWAPGate) = square(ctx, "SWAP") # SWAP
# Compose.compose!(ctx::Context, x::ToffoliGate) = square(ctx, "Toffoli") # Toffoli(CCNOT, CCX, TOFF)


grid_width(l::Int; α=0.4) = 1/(l * exp(α * (l - 1)))
interval_h(l::Int; α=0.4) = l == 1 ? 0 : (exp(α * (l - 1)) - 1) / ((l - 1) * exp(α * (l - 1)))

grid_height(n::Int; α=0.4) = 1/(n * exp(α * (n - 1)))
interval_v(n::Int; α=0.4) = n == 1 ? 0 : (exp(α * (n - 1)) - 1) / ((n - 1) * exp(α * (n - 1)))

#TODO: print a circle/dot - for CNOT gates and have it connect to different wires given two inputs 

function filled_black_Circle_Node()
filled_black_circle = [compose(context(minwidth=figsize + 2mm, minheight=figsize),
                  circle(0.5, 0.5, figsize/2), fill(LCHab(0.0, 0.0, 0.0)))]


compose(context(), filled_black_circle)


function unfilled_black_Circle_Node()
unfilled_black_circle = [compose(context(minwidth=figsize + 2mm, minheight=figsize),
                    circle(0.5, 0.5, figsize/2), fill(LCHab(0.0, 0.0, 0.0)))]


compose(context(), unfilled_black_circle)





# TODO: print Ket notation for the input qubits for Q_0 to Q_n where n = number of qubits in circuit 
# start at 0 or start at 1?
"""
q0_0
q0_1
.
.
.
q0_n
"""

"""
|0> q0
|0> q1
|0> q2
.
.
.
|0> qn
"""

# Chainblock is one of compose's 15 methods
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

# KronBlock is one of compose's 15 methods
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

"""
TODO: qubit = 2 right now it only works for 1 (don't know how to start this)
TODO: try writing your own software that does this

"""
    
