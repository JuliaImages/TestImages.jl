using TestImages
using FixedPointNumbers
using AxisArrays
using Colors
using Test

img = testimage("cameraman")
@test isa(img, Matrix{Gray{N0f8}})
img = testimage("mri-stack")
@test isa(img, AxisArray)
@test map(step, axisvalues(img)) == (1,1,5)

nothing
