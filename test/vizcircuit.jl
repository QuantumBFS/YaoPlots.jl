using YaoPlots
using Compose
using Test
using YaoBlocks

@testset "gate styles" begin
	@test YaoPlots.get_brush_text(X)[2] == "X"
	@test YaoPlots.get_brush_text(Rx(0.5))[2] == "Rx(0.5)"
	@test YaoPlots.get_brush_text(shift(0.5))[2] == "ϕ(0.5)"
	@test YaoPlots.get_brush_text(YaoBlocks.phase(0.5))[2] == "0.5im"
end

@testset "circuit canvas" begin
	c = CircuitGrid(5)
	@test YaoPlots.nline(c) == 5
	@test YaoPlots.frontier(c, 2, 3) == 0
	@test YaoPlots.depth(c) == 0
	circuit_canvas(5) do c
		YaoPlots.draw!(c, put(5, 3=>X))
		@test YaoPlots.frontier(c, 1, 2) == 0
		@test YaoPlots.frontier(c, 3, 5) == 1
		@test YaoPlots.depth(c) == 1
	end

	gg = circuit_canvas(5) do c
		put(3=>X) >> c
		control(2, 3=>X) >> c
		chain(5, control(2, 3=>X), put(1=>X)) >> c
		@test YaoPlots.depth(c) == 3
	end
	@test gg isa Context
end
