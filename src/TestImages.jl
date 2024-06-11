module TestImages
using FileIO, AxisArrays, OffsetArrays
using Pkg.Artifacts
using StringDistances
using ColorTypes
using ColorTypes.FixedPointNumbers
using NDTools: reorient
using StaticArrays
const artifacts_toml = abspath(joinpath(@__DIR__, "..", "Artifacts.toml"))

export testimage, testimage_dip3e

include("testimage_dip3e.jl")

# TODO: export shepp_logan when we remove Images.shepp_logan
# https://github.com/JuliaImages/Images.jl/pull/904
# export shepp_logan

const remotefiles = [
    "airplaneF16.tiff",
    "autumn_leaves.png",
    "barbara_color.png",
    "barbara_gray_512.bmp",
    "bark_512.tiff",
    "bark_he_512.tiff",
    "beach_sand_512.tiff",
    "beach_sand_he_512.tiff",
    "blobs.gif",
    "brick_wall_512.tiff",
    "brick_wall_he_512.tiff",
    "calf_leather_512.tiff",
    "calf_leather_he_512.tiff",
    "cameraman.tif",
    "chelsea.png",
    "coffee.png",
    "earth_apollo17.jpg",
    "fabio_color_256.png",
    "fabio_color_512.png",
    "fabio_gray_256.png",
    "fabio_gray_512.png",
    "grass_512.tiff",
    "grass_he_512.tiff",
    "hela-cells.tif",
    "herringbone_weave_512.tiff",
    "herringbone_weave_he_512.tiff",
    "house.tif",
    "jetplane.tif",
    "lake_color.tif",
    "lake_gray.tif",
    "lena_color_256.tif",
    "lena_color_512.tif",
    "lena_gray_16bit.png",
    "lena_gray_256.tif",
    "lena_gray_512.tif",
    "lighthouse.png",
    "lilly.jpg",
    "livingroom.tif",
    "m51.tif",
    "mandril_color.tif",
    "mandril_gray.tif",
    "mandrill.tiff",
    "monarch_color.png",
    "monarch_color_256.png",
    "moonsurface.tiff",
    "morphology_test_512.tiff",
    "mountainstream.png",
    "mri-stack.tif",
    "multi-channel-time-series.ome.tif",
    "peppers_color.tif",
    "peppers_gray.tif",
    "pigskin_512.tiff",
    "pigskin_he_512.tiff",
    "pirate.tif",
    "plastic_bubbles_512.tiff",
    "plastic_bubbles_he_512.tiff",
    "raffia_512.tiff",
    "raffia_he_512.tiff",
    "resolution_test_1920.tif",
    "resolution_test_512.tif",
    "simple_3d_ball.tif",
    "simple_3d_psf.tif",
    "straw_512.tiff",
    "straw_he_512.tiff",
    "sudoku.tiff",
    "toucan.png",
    "walkbridge.tif",
    "water_512.tiff",
    "water_he_512.tiff",
    "woman_blonde.tif",
    "woman_darkhair.tif",
    "wood_grain_512.tiff",
    "wood_grain_he_512.tiff",
    "woolen_cloth_512.tiff",
    "woolen_cloth_he_512.tiff"
]

"""
    img = testimage(filename; download_only=false, [ops...])

Load test image that partially matches `filename`, the first match is used if there're more
than one.

If `download_only=true`, the full filepath is returned.
Any other keyword arguments `ops` will be passed to image IO backend through `FileIO.load`.

# Example

```julia
julia> using TestImages
julia> img = testimage("cameraman.tif"); # fullname
julia> img = testimage("cameraman"); # without extension works
julia> img = testimage("c"); # with only partial name also works
```

# Extended help

The following is a complete list of testimages, you can also check them at
https://testimages.juliaimages.org/

$(reduce((x, y)->join([x, "\n - \`\"", splitext(y)[1], "\"\`"]), sort(remotefiles); init=""))
"""
function testimage(filename; download_only::Bool = false, nowarn=false, ops...)
    imagefile = image_path(full_imagename(filename))

    if !nowarn && startswith(basename(imagefile), "lena_")
        @warn "Usage of \"lena\" is not recommended, and the image may be removed in a later release. See https://womenlovetech.com/losing-lena-why-we-need-to-remove-one-image-and-end-techs-original-sin/ for more information." maxlog=1
    end

    download_only && return imagefile

    @debug "load image: $(basename(imagefile))"
    img = load(imagefile; ops...)
    if basename(imagefile) == "mri-stack.tif"
        # orientation is posterior-right-superior,
        # see http://www.grahamwideman.com/gw/brain/orientation/orientterms.htm
        return AxisArray(img, (:P, :R, :S), (1, 1, 5))
    elseif basename(imagefile) == "simple_3d_psf.tif"
        # kernel center is at (0, 0, 0)
        return OffsetArray(convert(Array{Gray{N0f8},3}, img), (-33, -33, -33))
    end
    img
end

"""
    fullname = full_imagename(shortname)

Get the first match of `shortname` in `TestImages.remotefiles`
"""
function full_imagename(filename)
    idx = findfirst(remotefiles) do x
        startswith(x, filename)
    end
    if idx === nothing
        warn_msg = "\"$filename\" not found in `TestImages.remotefiles`."

        best_match = _findnearest(filename)
        if isnothing(best_match[2])
            similar_matches = remotefiles[_findall(filename)]
            if !isempty(similar_matches)
                similar_matches_msg = "  * \"" * join(similar_matches, "\"\n  * \"") * "\""
                warn_msg = "$(warn_msg) Do you mean one of the following?\n$(similar_matches_msg)"
            end
            throw(ArgumentError(warn_msg))
        else
            idx = best_match[2]
            @warn "$(warn_msg) Load \"$(remotefiles[idx])\" instead."
        end
    end
    return remotefiles[idx]
end

function image_path(imagename)
    ensure_artifact_installed("images", artifacts_toml)

    image_dir = artifact_path(artifact_hash("images", artifacts_toml))
    return joinpath(image_dir, imagename)
end

_findall(name; min_score=0.6) = findall(name, remotefiles, JaroWinkler(), min_score=min_score)
_findnearest(name; min_score=0.8) = findnearest(name, remotefiles, JaroWinkler(), min_score=min_score)


"""
    phantom = shepp_logan(N, [M=N]; high_contrast=true)

Output the NxM Shepp-Logan phantom, which is a standard test image usually used
for comparing image reconstruction algorithms in the field of computed
tomography (CT) and magnetic resonance imaging (MRI).

If the argument `M` is omitted, the phantom is of size `NxN`. When setting the keyword argument
`high_constrast` to false, the CT version [1] of the phantom is created. Otherwise, the high contrast
MRI version [2] is calculated.

# References

[1] Shepp, Lawrence A., and Benjamin F. Logan. "The Fourier reconstruction of a head section." _IEEE Transactions on nuclear science_ 21.3 (1974): 21-43.

[2] Toft, Peter Aundal. "The Radon transform-theory and implementation." (1996): 201.

[3] Jain, Anil K. Fundamentals of digital image processing. _Prentice-Hall, Inc._, (1989): 439.
"""
function shepp_logan(::Type{T}, N::Int, M::Int, O::Int; high_contrast::Bool=true, highContrast=nothing) where {T}
    #println("shepp_logan function called")
    if !isnothing(highContrast)
        # compatbitity to Images.shepp_logan
        # remove this when we remove Images.shepp_logan
        Base.depwarn("keyword `highContrast` is deprecated, use `high_contrast` instead.", :shepp_logan)
    end
    x = reorient(Array(range(-1, stop=1, length=M)), Val(1))
    y = reorient(Array(range(-1, stop=1, length=N)), Val(2))
    if O == 1
        z = [0.0]
    else
        z = reorient(Array(range(-1, stop=1, length=O)), Val(3))
        #println("z: ", z)
    end
    #z = Array(range(-1, stop=1, length=O))

    # follow the notation in [2]
    A = high_contrast ?
          # high contrast (MRI) version of the phantom -- [2] p.201
          (1.0 , -0.8   , -0.2  , -0.2  , 0.1 , 0.1  ,  0.1  ,  0.1  ,  0.1  ,  0.1  ) :
          # original (CT) version of the phantom -- [1]
          (2.0 , -0.98  , -0.02 , -0.02 , 0.01, 0.01 ,  0.01 ,  0.01 ,  0.01 ,  0.01 )
          # [3] p.439 uses the following setting for the CT version
          # and is used by MATLAB's built-in `phantom` with method `Shepp-Logan`
        # (1.0 , -0.98  , -0.02 , -0.02 , 0.01, 0.01 ,  0.01 ,  0.01 ,  0.01 ,  0.01 )
    x₀ =  (0.0 ,  0.0   ,  0.22 , -0.22 , 0.0   , 0.0  ,  0.0  , -0.08 ,  0.0  ,  0.06 )
    y₀ =  (0.0 , -0.0184,  0.0  ,  0.0  , 0.35  , 0.1  , -0.1  , -0.605, -0.605, -0.605)
    z₀ =  (0.0 ,  0.0   ,  0.0  ,  0.0  , -0.15 , 0.25 ,  0.25 ,  0.0  ,  0.0  ,  0.0)
    a  =  (0.69,  0.6624,  0.11 ,  0.16 , 0.21  , 0.046,  0.046,  0.046,  0.023,  0.023)
    b  =  (0.92,  0.874 ,  0.31 ,  0.41 , 0.25  , 0.046,  0.046,  0.023,  0.023,  0.046)
    c  =  (0.81,  0.780 ,  0.22 ,  0.28 , 0.41  , 0.050,  0.050,  0.050,  0.020,  0.020)
    ϕ  =  (0.0 ,  0.0   , -18.0 ,  18.0 , 0.0   , 0.0  ,  0.0  ,  0.0  ,  0.0  ,  0.0  )
    θ  =  (0.0 ,  0.0   ,   0.0 ,   0.0 , 0.0   , 0.0  ,  0.0  ,  0.0  ,  0.0  ,  0.0  )
    ψ  =  (0.0 ,  0.0   ,  10.0 ,  10.0 , 0.0   , 0.0  ,  0.0  ,  0.0  ,  0.0  ,  0.0  )

    @inline function mat_mul(t::SVector{N, T}, matrix_c::SMatrix{N,N,T})::SVector{N,T} where {N,T}
        return matrix_c * t
    end

    @inline function mat_div(t::SVector{N, T}, v::SVector{N, T})::SVector{N,T} where {N,T}
        return t ./ v
    end
    @inline function sum_abs2(t::SVector{N, T})::T where {N,T}
        return sum(abs2.(t))
    end

    P = zeros(T, N, M, O)
    for l = 1:length(ϕ)
        if ϕ[l] == 0.0 && θ[l] == 0.0 && ψ[l] == 0.0

            R = SMatrix{3, 3, Float64}([
               1.0  0.0  0.0;
               0.0  1.0  0.0;
               0.0  0.0  1.0 
            ])
        else
            sinϕ, cosϕ = sincosd(ϕ[l])
            sinθ, cosθ = sincosd(θ[l])
            sinψ, cosψ = sincosd(ψ[l])

            R = SMatrix{3, 3, Float64}([
                (cosψ*cosϕ-cosθ*sinψ*sinϕ)  (cosψ*sinϕ+cosθ*sinψ*cosϕ)  (sinψ*sinθ);
                (-sinψ*cosϕ-cosθ*cosψ*sinϕ) (-sinψ*sinϕ+cosθ*cosψ*cosϕ) (cosψ*sinθ);
                (sinθ*sinϕ)                     (-sinθ*cosϕ)                   (cosθ) 
            ])
        end
        P .+= A[l] .* (sum_abs2.(mat_div.(mat_mul.(SVector{3, Float64}.(x .- x₀[l], y .- y₀[l], z .- z₀[l]), Ref(R)) , Ref(SVector{3, Float64}(a[l], b[l], c[l])))) .<= 1.0)

    end
    return P
end
shepp_logan(N::Integer, M::Integer, O::Integer; kwargs...) = shepp_logan(Float64, Int(N), Int(M), Int(O); kwargs...)
shepp_logan(N::Integer, M::Integer; kwargs...) = shepp_logan(Float64, Int(N), Int(M), 1; kwargs...)[:, :, 1]
shepp_logan(N::Integer; kwargs...) = shepp_logan(Float64, Int(N), Int(N), 1; kwargs...)[:, :, 1]

function _precompile_()
    ccall(:jl_generating_output, Cint, ()) == 1 || return nothing
    @assert precompile(image_path, (String,))
    @assert precompile(testimage, (String,))
    @assert precompile(shepp_logan, (Int,Int))
end
VERSION >= v"1.4.2" && _precompile_() # https://github.com/JuliaLang/julia/pull/35378

end # module
