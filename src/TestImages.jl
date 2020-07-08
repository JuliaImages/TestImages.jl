module TestImages
using FileIO, AxisArrays
using Pkg.Artifacts
using StringDistances
const artifacts_toml = abspath(joinpath(@__DIR__, "..", "Artifacts.toml"))

export testimage

REPO_URL = "https://github.com/JuliaImages/TestImages.jl/blob/gh-pages/images/"

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
    file_hash = artifact_hash(imagename, artifacts_toml)

    if file_hash === nothing || !artifact_exists(file_hash)
        new_hash = create_artifact() do artifact_dir
            download(REPO_URL*imagename*"?raw=true", joinpath(artifact_dir, imagename))
        end
        if file_hash === nothing
            bind_artifact!(artifacts_toml,
                           imagename,
                           new_hash)
        end
        file_hash = new_hash
    end
    return joinpath(artifact_path(file_hash), imagename)
end

_findall(name; min_score=0.6) = findall(name, remotefiles, Winkler(Jaro()), min_score=min_score)
_findmax(name; min_score=0.8) = findmax(name, remotefiles, Winkler(Jaro()), min_score=min_score)

end # module
