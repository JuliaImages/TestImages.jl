using TestImages, FixedPointNumbers, Colors, AxisArrays
using Test, ReferenceTests, Suppressor

# make sure all files in remotefiles are valid image files
foreach(TestImages.remotefiles) do img_name
    img = testimage(img_name)
    @test isa(img, AbstractArray{<:Colorant})
end

include("utils.jl")

img = testimage("cameraman")
@test isa(img, Matrix{Gray{N0f8}})
img = testimage("mri-stack")
@test isa(img, AxisArray)
@test map(step, axisvalues(img)) == (1,1,5)
@test_nowarn testimage("c")

# mismatch handling
err_str = @except_str testimage("nonexistence.png") ArgumentError
@test_reference "references/nonexistence_err.txt" err_str

err_str = @except_str testimage("leans") ArgumentError
@test_reference "references/leans_err.txt" err_str

err_str = @except_str testimage("abcd.png") ArgumentError
@test_reference "references/abcd_err.txt" err_str

err_str = @capture_err testimage("leaves.png")
@test_reference "references/leaves_warning.txt" split(err_str, "\n")[1]
