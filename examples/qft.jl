using YaoExtensions, YaoPlots
using Compose
Compose.set_default_graphic_size(20cm, 20cm)
gg = circuit_canvas(5) do c
	qft_circuit(5) >> c
end
