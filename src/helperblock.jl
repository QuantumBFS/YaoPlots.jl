using YaoBlocks
export ContinuousBlockMarker

"""
    ContinuousBlockMarker{BT,N} <: TagBlock{N}

A marker to mark a circuit applying on a continous block for better plotting.
"""
struct ContinuousBlockMarker{BT<:AbstractBlock,N} <: TagBlock{BT,N}
    content::BT
    name::String
end

YaoBlocks.content(cb::ContinuousBlockMarker) = cb.content
function ContinuousBlockMarker(x::BT, name::String) where {N,BT<:AbstractBlock{N}}
    ContinuousBlockMarker{BT,N}(x, name)
end

function is_continuous_chunk(x)
    length(x) == 0 && return true
    return length(x) == maximum(x)-minimum(x)+1
end

YaoBlocks.PropertyTrait(::ContinuousBlockMarker) = YaoBlocks.PreserveAll()
YaoBlocks.mat(::Type{T}, blk::ContinuousBlockMarker) where {T} = mat(T, content(blk))
YaoBlocks.apply!(reg::YaoBlocks.AbstractRegister, blk::ContinuousBlockMarker) = apply!(reg, content(blk))
YaoBlocks.chsubblocks(blk::ContinuousBlockMarker, target::AbstractBlock) = ContinuousBlockMarker(target, blk.name)

Base.adjoint(x::ContinuousBlockMarker) = ContinuousBlockMarker(adjoint(content(x)), endswith(x.name, "†") ? x.name[1:end-1] : x.name*"†")
Base.copy(x::ContinuousBlockMarker) = ContinuousBlockMarker(copy(content(x)), x.name)
YaoBlocks.Optimise.to_basictypes(block::ContinuousBlockMarker) = block

