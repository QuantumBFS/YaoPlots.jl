using Luxor

# Create a graphic file and possibly also display and/or open it
@png juliacircles() 

plot(x::AbstractBlock) = luxor(context(0, 0, figsize...)) # TODO: luxor not defined ???
    Drawing(1000, 1000, "image.png")
    origin()
    background("white")
    sethue("blue")
    fontsize(50)
    text("quantum_circuit_here")

    finish()
    preview()

end

plot(x) = luxor()


# Luxor can construct geometric objects as lists of points -> Yao Chain block 

"""
# boxes 
rulers()
sethue("red")
rect(O, 100, 100, :stroke)
sethue("blue")
box(O, 100, 100, :stroke) # box(corner1,  corner2, vertices=true)
"""



"""
#TODO: is it a function? idk
function luxor(ctx::AbstractBlock)
    
    plot = compose(ctx)

    Drawing(1000, 1000, "image.png")

    origin()
    background("white")
    sethue("blue")
    fontsize(50)
    text("quantum_circuit_here")

    finish()
    preview()

    return plot
end

luxor()
"""