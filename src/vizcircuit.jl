using Viznet: canvas
using YaoBlocks

export CircuitStyles, CircuitGrid, circuit_canvas

module CircuitStyles
	using Compose
    r = 0.2
	lw = 1pt
	textsize = 16pt
	paramtextsize = 12pt
	fontfamily = "Helvetica Neue"
    G() = compose(context(), rectangle(-r, -r, 2r, 2r), fill("white"), stroke("black"), linewidth(lw))
    C() = compose(context(), circle(0.0, 0.0, r/3), fill("black"))
    X() = compose(context(), xgon(0.0, 0.0, r, 4), fill("black"))
    WG() = compose(context(), rectangle(-1.5*r, -r, 3*r, 2r), fill("white"), stroke("black"), linewidth(lw))
    LINE() = compose(context(), line(), stroke("black"), linewidth(lw))
	TEXT() = compose(context(), text(0.0, 0.0, "", hcenter, vcenter), fontsize(textsize), font(fontfamily))
	PARAMTEXT() = compose(context(), text(0.0, 0.0, "", hcenter, vcenter), fontsize(paramtextsize), font(fontfamily))
	function setlw(_lw)
		global lw = _lw
	end
	function setr(_r)
		global r = _r
	end
	function settextsize(_textsize)
		global textsize = _textsize
	end
	function setparamtextsize(_paramtextsize)
		global paramtextsize = _paramtextsize
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
		if length(txt) >= 3
			CircuitStyles.PARAMTEXT() >> (c[i, j], txt)
		elseif length(txt) >= 1
			CircuitStyles.TEXT() >> (c[i, j], txt)
		end
		if k!=1
			CircuitStyles.LINE() >> c[(i, j); (i, jpre)]
		end
		jpre = j
    end

	jmin, jmax = min(locs..., nline(c)), max(locs..., 1)
	for j = jmin:jmax
		CircuitStyles.LINE() >> c[(i, j); (c.frontier[j], j)]
		c.frontier[j] = i
	end
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
	draw!.(Ref(c), subblocks(p))
end

function draw!(c::CircuitGrid, p::PutBlock{N,1}) where N
    _draw!(c, [(p.locs..., get_brush_text(p.content)...)])
end

function draw!(c::CircuitGrid, cb::ControlBlock{N,GT,C,1}) where {N,GT,C}
    locs = [cb.ctrl_locs..., cb.locs...]
	_draw!(c, [[(loc, CircuitStyles.C(), "") for loc=cb.ctrl_locs]..., (cb.locs..., get_brush_text(cb.content)...)])
end

for (GATE, SYM) in [(:XGate, :Rx), (:YGate, :Ry), (:ZGate, :Rz)]
	@eval get_brush_text(b::RotationGate{1,T,<:$GATE}) where T = (CircuitStyles.WG(), "$($(SYM))$(Base.REPLCompletions.latex_symbols["\\_$(pretty_angle(b.theta))"]))")
end

pretty_angle(theta) = theta
pretty_angle(theta::Float64) = round(theta; digits=2)

get_brush_text(b::ShiftGate) = (CircuitStyles.WG(), "ϕ($(pretty_angle(b.theta)))")
get_brush_text(b::PhaseGate) = (CircuitStyles.WG(), "$(pretty_angle(b.theta))im")
get_brush_text(b::T) where T<:ConstantGate = (CircuitStyles.G(), string(T.name.name)[1:end-4])

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
	a, b = depth(c)+1, nline
	Compose.set_default_graphic_size(a*2.5*cm, b*2.5*cm)
	compose(context(0.5/a, -0.5/b, 1/a, 1/b), g)
end

Base.:>>(blk::AbstractBlock, c::CircuitGrid) = draw!(c, blk)
Base.:>>(blk::Function, c::CircuitGrid) = blk(nline(c)) >> c
