using TestImages, FixedPointNumbers, Colors, AxisArrays
using Test

img = testimage("cameraman")
@test isa(img, Matrix{Gray{N0f8}})
img = testimage("mri-stack")
@test isa(img, AxisArray)
@test map(step, axisvalues(img)) == (1,1,5)
@test_nowarn testimage("c")
@test_throws ArgumentError testimage("nonexistence.png")
