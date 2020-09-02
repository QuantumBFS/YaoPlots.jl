using YaoExtensions, YaoPlots
using Compose
Compose.set_default_graphic_size(20cm, 20cm)

vizcircuit(qft_circuit(5))
vizcircuit(variational_circuit(5))
vizcircuit(control(5, (2,-3), 4=>X))
