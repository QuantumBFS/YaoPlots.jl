# Internal file
# Here we write some Julia code!

# Note that for writing package code, you should try to keep your functions "loose"
# output_string(s::Symbol) = string(s)

# This definition is normally a bad idea because the functions will work on
# many other types! Note that the `::Symbol` only does dispatch and does not
# improve performance! For details on this, see
# http://www.stochasticlifestyle.com/7-julia-gotchas-handle/

output_string(s::Symbol) = string(s)

# On the otherhand, packages should strive to achieve good performance and generality.
# This is usually done through good usage of types. In Julia, you must strictly
# define the types on the fields for your types in order to get good performance.

type BadPerformance
  A
end

# will get bad performance. Instead, if you know the type that A should be:

type GoodPerformance
  A::Float64
end

# But again, libraries should strive to be type-generic. If our algorithm should
# work on any floating point number, you should do:

type GoodPerformanceAnyFloat{T<:AbstractFloat}
  A::T
end

# Note that this is not the same as

type BadPerformanceAnyFloat
  A::AbstractFloat
end

# where this way uses an abstract type on the field, and thus has bad performance.
# Note that using a type parameter gives good performance, even if it's un-restricted:

type GoodPerformanceAny{T}
  A::T
end
