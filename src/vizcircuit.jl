using Viznet: canvas
using YaoBlocks

export CircuitStyles, CircuitGrid, circuit_canvas

module CircuitStyles
	using Compose
    r = 0.2
	lw = 1pt
	textsize = 12pt
	fontfamily = "Helvetica Neue"
    G() = compose(context(), rectangle(-r, -r, 2r, 2r), fill("white"), stroke("black"), linewidth(lw))
    C() = compose(context(), circle(0.0, 0.0, r/3), fill("black"))
    X() = compose(context(), xgon(0.0, 0.0, r, 4), fill("black"))
    WG() = compose(context(), rectangle(-1.5*r, -r, 3*r, 2r), fill("white"), stroke("black"), linewidth(lw))
    LINE() = compose(context(), line(), stroke("black"), linewidth(lw))
	TEXT() = compose(context(), text(0.0, 0.0, "", hcenter, vcenter), fontsize(textsize), font(fontfamily))
	function setlw(_lw)
		global lw = _lw
	end
	function setr(_r)
		global r = _r
	end
	function settextsize(_textsize)
		global textsize = _textsize
	end
	function setfontfamily(_fontfamily)
		global fontfamily = _fontfamily
	end
end

struct CircuitGrid
    frontier::Vector{Int}
	w_depth::Float64
	w_line::Float64
end

nline(c::CircuitGrid) = length(c.frontier)
depth(c::CircuitGrid) = frontier(c, 1, nline(c))
Base.getindex(c::CircuitGrid, i, j) = (c.w_depth*i, c.w_line*j)
Base.typed_vcat(c::CircuitGrid, ij1, ij2) = (c[ij1...], c[ij2...])

function CircuitGrid(nline::Int; w_depth=1.0, w_line=1.0)
    CircuitGrid(zeros(Int, nline), w_depth, w_line)
end

function frontier(c::CircuitGrid, args...)
    maximum(i->c.frontier[i], min(args..., nline(c)):max(args..., 1))
end

function _draw!(c::CircuitGrid, loc_brush_texts)
	locs = getindex.(loc_brush_texts, 1)
    i = frontier(c, locs...) + 1
	local jpre
    for (k, (j, b, txt)) in enumerate(loc_brush_texts)
		b >> c[i, j]
		CircuitStyles.LINE() >> c[(i, j); (c.frontier[j], j)]
		if txt!=""
			CircuitStyles.TEXT() >> (c[i, j], txt)
		end
		if k!=1
			CircuitStyles.LINE() >> c[(i, j); (i, jpre)]
		end
		jpre = j
    end
	c.frontier[min(locs..., nline(c)):max(locs..., 1)] .= i
end

function finalize!(c::CircuitGrid)
    i = frontier(c, 1, nline(c)) + 1
	for j=1:nline(c)
		CircuitStyles.LINE() >> c[(i, j-0.2); (i, j+0.2)]
		CircuitStyles.LINE() >> c[(i, j); (c.frontier[j], j)]
	end
	c.frontier .= i
end

function draw!(c::CircuitGrid, b::AbstractBlock)
    error("block type $(typeof(b)) does not support visualization.")
end

function draw!(c::CircuitGrid, p::ChainBlock{N}) where N
	draw!.(subblocks(p), Ref(c))
end

function draw!(c::CircuitGrid, p::PutBlock{N,1}) where N
    _draw!(c, [(p.locs..., get_brush_text(p.content)...)])
end

function draw!(c::CircuitGrid, cb::ControlBlock{N,GT,C,1}) where {N,GT,C}
    locs = [cb.ctrl_locs..., cb.locs...]
	_draw!(c, [[(loc, CircuitStyles.C(), "") for loc=cb.ctrl_locs]..., (cb.locs..., get_brush_text(cb.content)...)])
end

for (GATE, SYM) in [(:XGate, :Rx), (:YGate, :Ry), (:ZGate, :Rz)]
	@eval get_brush_text(b::RotationGate{1,T,<:$GATE}) where T = (CircuitStyles.WG(), "$($(SYM))($(b.theta))")
end

get_brush_text(b::ShiftGate) = (CircuitStyles.WG(), "ϕ($(b.theta))")
get_brush_text(b::PhaseGate) = (CircuitStyles.WG(), "$(b.theta)im")
get_brush_text(b::T) where T<:ConstantGate = (CircuitStyles.G(), string(T)[1:end-4])

get_cbrush_text(b::AbstractBlock) = get_brush_text(b)
get_cbrush_text(b::XGate) = (CircuitStyles.X(), "")
get_cbrush_text(b::ZGate) = (CircuitStyles.C(), "")

# front end
function circuit_canvas(f, nline::Int)
	c = CircuitGrid(nline)
	g = canvas() do
	   f(c)
       finalize!(c)
	end
	n = max(depth(c)+1, nline)
	compose(context(0.5/n, -0.5/n, 1/n, 1/n), g)
end

Base.:>>(blk::AbstractBlock, c::CircuitGrid) = draw!(c, blk)
Base.:>>(blk::Function, c::CircuitGrid) = blk(nline(c)) >> c
