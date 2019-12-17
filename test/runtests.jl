using TestImages, FixedPointNumbers, Colors, AxisArrays
using Test

# make sure all files in remotefiles are valid image files
foreach(TestImages.remotefiles) do img_name
    img = testimage(img_name)
    @test isa(img, AbstractArray{<:Colorant})
end

img = testimage("cameraman")
@test isa(img, Matrix{Gray{N0f8}})
img = testimage("mri-stack")
@test isa(img, AxisArray)
@test map(step, axisvalues(img)) == (1,1,5)
@test_nowarn testimage("c")
@test_throws ArgumentError testimage("nonexistence.png")
