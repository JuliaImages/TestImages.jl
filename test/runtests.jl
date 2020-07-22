using TestImages, FixedPointNumbers, Colors, AxisArrays
using Test, ReferenceTests
using ImageContrastAdjustment

using TestImages: shepp_logan # will be exported in future release

img = testimage("cameraman")
@test isa(img, Matrix{Gray{N0f8}})
img = testimage("mri-stack")
@test isa(img, AxisArray)
@test map(step, axisvalues(img)) == (1,1,5)
@test_nowarn testimage("c")
@test_throws ArgumentError testimage("nonexistence.png")

@test all([f in TestImages.remotefiles for f in readdir(TestImages.imagedir)])

# Shepp-Logan phantom
@testset "shepp_logan" begin
    @test eltype(shepp_logan(64)) == Gray{Float64}
    @test size(shepp_logan(64)) == (64, 64)
    @test size(shepp_logan(64, 128)) == (64, 128)
    @test shepp_logan(64; high_contrast=true) == shepp_logan(64)

    phantom_ct = shepp_logan(128; high_contrast=false)
    phantom_mri = shepp_logan(128; high_contrast=true)

    # CT value exceeds [0, 1] range, so we need to stretch its value to make references
    # FIXME: ReferenceTests is broken for *.png references
    @test_reference "references/shepp_logan_CT_128.txt" adjust_histogram(phantom_ct, LinearStretching())
    @test_reference "references/shepp_logan_MRI_128.txt" phantom_mri

    _norm(x) = sqrt(sum(abs2, x))
    P = [ 0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0;
          0.0  0.0  1.0  0.2  0.2  1.0  0.0  0.0;
          0.0  0.0  0.2  0.3  0.3  0.2  0.0  0.0;
          0.0  0.0  0.2  0.0  0.2  0.2  0.0  0.0;
          0.0  0.0  0.2  0.0  0.0  0.2  0.0  0.0;
          0.0  0.0  0.2  0.2  0.2  0.2  0.0  0.0;
          0.0  0.0  1.0  0.2  0.2  1.0  0.0  0.0;
          0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0]
    Q = shepp_logan(8)
    @test _norm(P - Q) < 1e-10
    P = [ 0.0  0.0  0.0   0.0   0.0   0.0   0.0  0.0;
          0.0  0.0  2.0   1.02  1.02  2.0   0.0  0.0;
          0.0  0.0  1.02  1.03  1.03  1.02  0.0  0.0;
          0.0  0.0  1.02  1.0   1.02  1.02  0.0  0.0;
          0.0  0.0  1.02  1.0   1.0   1.02  0.0  0.0;
          0.0  0.0  1.02  1.02  1.02  1.02  0.0  0.0;
          0.0  0.0  2.0   1.02  1.02  2.0   0.0  0.0;
          0.0  0.0  0.0   0.0   0.0   0.0   0.0  0.0]
    Q = shepp_logan(8, high_contrast=false)
    @test _norm(P - Q) < 1e-10
end
