module TestImages
using FileIO, AxisArrays

export testimage

const imagedir = joinpath(dirname(@__FILE__), "..", "images")

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
    "lake.tif" ,
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

function testimage(filename, ops...)
    isdir(imagedir) || mkpath(imagedir)
    imagefile = joinpath(imagedir, filename)
    if !isfile(imagefile)
        fls = readdir(imagedir)
        havefile = false
        for f in fls
            fname, fext = splitext(f)
            if fname == split(filename, fext)[1]
                imagefile = joinpath(imagedir, f)
                havefile = true
                break
            end
        end

        if !havefile
            @info "Could not find "*filename*" in directory. Checking if it exists in the online repository."
            for f in remotefiles
                fname, fext = splitext(f)
                if fname == split(filename, fext)[1]
                    @info "Found "*filename*" in the online repository. Downloading to the images directory."
                    download(REPO_URL*f*"?raw=true", joinpath(imagedir, f))
                    havefile = true
                    imagefile = joinpath(imagedir, f)
                    break
                end
            end
        end
        havefile || throw(ArgumentError("$filename not found in the directory or the online repository. Here are the contents of the images/ directory:\n$(join(remotefiles, '\n'))"))
    end
    img = load(imagefile, ops...)
    if basename(imagefile) in ["mri-stack.tif",]
        # orientation is posterior-right-superior,
        # see http://www.grahamwideman.com/gw/brain/orientation/orientterms.htm
        return AxisArray(img, (:P, :R, :S), (1, 1, 5))
    end
    img
end

end # module
