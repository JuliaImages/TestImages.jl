imagedir = joinpath(dirname(@__FILE__), "..", "images")
if !isdir(imagedir)
    mkdir(imagedir)
end

REPO_URL = "https://github.com/timholy/TestImages.jl/blob/gh-pages/images/"

stdfiles = [
    "cameraman.tif" ,
    "house.tif" ,
    "jetplane.tif" ,
    "lake.tif" ,
    "lena_color_256.tif" ,
    "lena_color_512.tif" ,
    "lena_gray_256.tif" ,
    "lena_gray_512.tif" ,
    "livingroom.tif" ,
    "mandril_color.tif" ,
    "mandril_gray.tif" ,
    "mandrill.tiff" ,
    "peppers_color.tif" ,
    "peppers_gray.tif" ,
    "pirate.tif" ,
    "walkbridge.tif" ,
    "woman_blonde.tif" ,
    "woman_darkhair.tif" ,
]

info("Downloading standard test images")
for f in stdfiles
    fn = joinpath(imagedir, f)
    if !isfile(fn)
        info("Downloading $fn")
        download(REPO_URL*f*"?raw=true", joinpath(imagedir, f))
    end
end

info("Download Completed.")





