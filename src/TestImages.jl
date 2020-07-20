module TestImages
using FileIO, AxisArrays
using Pkg.Artifacts
using StringDistances
using ColorTypes
const artifacts_toml = abspath(joinpath(@__DIR__, "..", "Artifacts.toml"))

export testimage, shepp_logan

remotefiles = [
    "autumn_leaves.png" ,
    "blobs.gif" ,
    "cameraman.tif" ,
    "earth_apollo17.jpg" ,
    "fabio_color_256.png" ,
    "fabio_color_512.png" ,
    "fabio_gray_256.png" ,
    "fabio_gray_512.png" ,
    "hela-cells.tif" ,
    "house.tif" ,
    "jetplane.tif" ,
    "lake_color.tif" ,
    "lake_gray.tif" ,
    "lena_color_256.tif" ,
    "lena_color_512.tif" ,
    "lena_gray_256.tif" ,
    "lena_gray_512.tif" ,
    "lena_gray_16bit.png" ,
    "livingroom.tif" ,
    "lighthouse.png" ,
    "mandril_color.tif" ,
    "mandril_gray.tif" ,
    "mandrill.tiff" ,
    "m51.tif" ,
    "moonsurface.tiff" ,
    "mountainstream.png" ,
    "mri-stack.tif" ,
    "multi-channel-time-series.ome.tif" ,
    "peppers_color.tif" ,
    "peppers_gray.tif" ,
    "pirate.tif" ,
    "toucan.png" ,
    "walkbridge.tif" ,
    "woman_blonde.tif" ,
    "woman_darkhair.tif" ,
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
function testimage(filename; download_only = false, ops...)
    imagefile = image_path(full_imagename(filename))

    download_only && return imagefile

    img = load(imagefile; ops...)
    if basename(imagefile) == "mri-stack.tif"
        # orientation is posterior-right-superior,
        # see http://www.grahamwideman.com/gw/brain/orientation/orientterms.htm
        return AxisArray(img, (:P, :R, :S), (1, 1, 5))
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

        best_match = _findmax(filename)
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

_findall(name; min_score=0.6) = findall(name, remotefiles, Winkler(Jaro()), min_score=min_score)
_findmax(name; min_score=0.8) = findmax(name, remotefiles, Winkler(Jaro()), min_score=min_score)


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
function shepp_logan(N::Integer, M::Integer; high_contrast=true)
    x = range(-1, stop=1, length=M)'
    y = range(1, stop=-1, length=N)
  
    centerX = [0, 0, 0.22, -0.22, 0, 0, 0, -0.08, 0, 0.06]
    centerY = [0, -0.0184, 0, 0, 0.35, 0.1, -0.1, -0.605, -0.605, -0.605]
    majorAxis = [0.69, 0.6624, 0.11, 0.16, 0.21, 0.046, 0.046, 0.046, 0.023, 0.023]
    minorAxis = [0.92, 0.874, 0.31, 0.41, 0.25, 0.046, 0.046, 0.023, 0.023, 0.046]
    theta = [0, 0, -0.1pi, 0.1pi, 0, 0, 0, 0, 0, 0]
  
    if high_contrast
        # high contrast (MRI) version of the phantom -- [2] p.201
        grayLevel = [1, -0.8, -0.2, -0.2, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1]
    else
        # original (CT) version of the phantom -- [1]
        grayLevel = [2, -0.98, -0.02, -0.02, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01]
        # [3] p.439 uses the following setting, and is what MATLAB's built-in `phantom` uses
        # grayLevel = [1, -0.98, -0.02, -0.02, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01]
    end
  
    P = zeros(N, M)
    for l = 1:length(theta)
      P .+= grayLevel[l] .* (
             abs2.( (cos(theta[l]) .* (x .- centerX[l]) .+
                sin(theta[l]) .* (y .- centerY[l])) ./ majorAxis[l] ) .+
             abs2.( (sin(theta[l]) .* (x .- centerX[l]) .-
                cos(theta[l]) .* (y .- centerY[l])) ./ minorAxis[l] ) .< 1 )
    end
  
    return Gray{Float64}.(P) # to not depend on ColorVectorSpaces
end
shepp_logan(N::Integer; kwargs...) = shepp_logan(N, N; kwargs...)

end # module
