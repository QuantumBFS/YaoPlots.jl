# Catlab.jl 
# Wiring Diagrams in Julia 
# Symbolic expressions are displayed using LaTeX and wiring diagrams are visualized using Graphviz or TikZ.

# Outputs a LaTex Graphics object Catlab.Graphics.TikZ.Document
using Catlab.WiringDiagrams, Catlab.Graphics, Catlab.Doctrines
import Catlab.Graphics: Graphviz
import TikzPictures


# Expression to diagram
function show_diagram(d::WiringDiagram)
    to_graphviz(d, orientation=LeftToRight, labels=false)
  end



# Tensor products (expressed as an application of the monoidal category)
A, B, C, D, E = Ob(FreeCartesianCategory, :A, :B, :C, :D, :E)

# Single Wire
to_composejl(id(A))

# Where f and g are possible quantum gates
# f = Hom(:f, A, B)
# g = Hom(:g, B, A)


A, B, C, D = Ob(FreeSymmetricMonoidalCategory, :A, :B, :C, :D)

X = Hom(:X, A, B) # Pauli X
Y = Hom(:Y, B, A) # Pauli Y
Z = Hom(:Z, A, B) # Pauli Z
H = Hom(:H, B, A) # Haramard
S = Hom(:S, A, B) # Phase(S,P)
T = Hom(:T, B, A) # pi/8
Z = Hom(:Z, B, A) # Controlled Z (CZ) 
# expr = f ⊗ g

# Single H gate
to_composejl(H)

# Print out multiple gates
to_composejl(X⊗Y⊗Z⊗H⊗S⊗T⊗Z)

# One gate
to_graphviz(f) 

# to_graphviz(compose(f,g)) 
to_graphviz(compose(f,g), # Two gates
    # Graphviz graph attributes
    labels = true, label_attr=:headlabel,
    node_attrs = Dict(
        :fontname => "Courier",
    ),
    edge_attrs = Dict(
        :fontname => "Courier",
        :labelangle => "25",
        :labeldistance => "2",
    ),
    cell_attrs = Dict(
        :bgcolor => "blue",
    )
    )


# Orientation of circuit
# We want left to right (Catlab is default top down)
to_graphviz(composite, orientation=LeftToRight)


show_diagram(to_wiring_diagram(expr)) 


