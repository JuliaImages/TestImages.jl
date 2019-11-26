using TestImages

stdfiles = [
    "cameraman.tif" ,
    "house.tif" ,
    "jetplane.tif" ,
    "lake_gray.tif" ,
    "lake_color.tif" ,
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

@info "Downloading standard test images"
foreach(x->testimage(x; download_only=true), stdfiles)
