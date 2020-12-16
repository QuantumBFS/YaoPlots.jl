using YaoPlots, Yao
using Test

@testset "ContinuousBlockMarker" begin
    x = put(5, (2,3)=>matblock(rand_unitary(4)))
    cb = ContinuousBlockMarker(x, "x")
    @test mat(copy(cb)) == mat(cb)
    @test isunitary(cb)
    @test ishermitian(cb) == ishermitian(x)
    @test isreflexive(cb) == isreflexive(x)
    @test mat(cb) == mat(x)
    reg = rand_state(5)
    @test apply!(copy(reg), cb) ≈ apply!(copy(reg), x)
    @test cb' isa ContinuousBlockMarker && mat(cb') ≈ mat(cb)'
    @test (cb').name == "x†" && (cb'').name == "x"

    y = put(5, (3,4)=>matblock(rand_unitary(4)))
    cc = chsubblocks(cb, y)
    @test YaoPlots.is_continuous_chunk([1,2,3]) == true
    @test YaoPlots.is_continuous_chunk([1,2,4]) == false
    @test YaoPlots.is_continuous_chunk([3,2,4]) == true
    
    c1 = chain(5, [ContinuousBlockMarker(put(5, (2,3)=>SWAP), "SWAP"), ContinuousBlockMarker(put(5, 2=>I2), "id"), put(5, 2=>ContinuousBlockMarker(X, "X")), control(5, (5,3), (2,4,1)=>ContinuousBlockMarker(put(3, (1,3)=>SWAP), "SWAP"))])
    c2 = chain(5, [ContinuousBlockMarker(put(5, (2,3)=>SWAP), "SWAP"), ContinuousBlockMarker(put(5, 2=>I2), "id"), put(5, 2=>ContinuousBlockMarker(X, "X")), control(5, (5,3), (2,4,1)=>ContinuousBlockMarker(put(3, (1,2)=>SWAP), "SWAP"))])

    @test vizcircuit(c1) isa Context
    @test_throws ErrorException vizcircuit(c2)
end