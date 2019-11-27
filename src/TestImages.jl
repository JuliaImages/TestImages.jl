module TestImages
using FileIO, AxisArrays
if VERSION >= v"1.3"
    using Pkg.Artifacts
    const artifacts_toml = abspath(joinpath(@__DIR__, "..", "Artifacts.toml"))
end

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
    testimage(filename; download_only=false, [ops...])

Load test image that partially matches `filename`, the first match is used if there're more
than one.

If `download_only=true`, the full filepath is returned.
Any other keyword arguments `ops` will be passed to image IO backend through `FileIO.load`
function.

# Example

```julia
julia> using TestImages
julia> testimage("cameraman.tif") # fullname
julia> testimage("cameraman") # without extension works
julia> testimage("c") # with only partial name also works
```

Use `TestImages.remotefiles` to get a full list of available images. You can also check
https://testimages.juliaimages.org/
"""
function testimage(filename; download_only = false, ops...)
    imagefile = download_artifacts(full_imagename(filename))

    download_only && return imagefile

    img = load(imagefile; ops...)
    if basename(imagefile) == "mri-stack.tif"
        # orientation is posterior-right-superior,
        # see http://www.grahamwideman.com/gw/brain/orientation/orientterms.htm
        return AxisArray(img, (:P, :R, :S), (1, 1, 5))
    end
    img
end

"""get the first match of `filename` in remotefiles"""
function full_imagename(filename)
    idx = findfirst(remotefiles) do x
        startswith(x, filename)
    end
    idx === nothing && throw(ArgumentError("$filename not found in the online repository, use `TestImages.remotefiles` to get a full list of test images."))

    return remotefiles[idx]
end

# Pkg.Artifacts is introduced in julia v1.3.0
if VERSION >= v"1.3"
    function download_artifacts(imagename)
        file_hash = artifact_hash(imagename, artifacts_toml)

        if file_hash === nothing
            file_hash = create_artifact(x->_download_image(x, imagename))
            bind_artifact!(artifacts_toml,
                           imagename,
                           file_hash)
        end

        # this is a trivial operation if artifacts already exist
        artifact_dir = artifact_path(file_hash)
        imagefile = _download_image(artifact_dir, imagename)

        return imagefile
    end
else
    const imagedir = joinpath(dirname(@__FILE__), "..", "images")
    download_artifacts(imagename) = _download_image(imagedir, imagename)
end

function _download_image(imagedir, imagename)
    isdir(imagedir) || mkpath(imagedir)
    imagefile = joinpath(imagedir, imagename)
    if !isfile(imagefile)
        @info "Found "*imagename*" in the online repository. Downloading to the images directory."
        download(REPO_URL*imagename*"?raw=true", imagefile)
    end
    return imagefile
end

end # module
