using ZipFile, Compat

function expandzip(fname)
    r = ZipFile.Reader(fname)
    for f in r.files
        fn = basename(f.name)
        if !isempty(fn)
            open(joinpath(imagedir, fn), "w") do s
                write(s, readstring(f))
            end
        end
    end
    close(r)
    rm(fname)
end

imagedir = Pkg.dir("TestImages", "images")
if !isdir(imagedir)
    mkdir(imagedir)
end

# Determine whether standard_test_images has already been installed
stdfiles = ["cameraman.tif", "house.tif", "jetplane.tif", "lake.tif"] # just the first several
have_std = true
for fname in stdfiles
    if !isfile(joinpath(imagedir, fname))
        have_std = false
        break
    end
end
if !have_std
    fname = Pkg.dir("TestImages", "images", "standard_test_images.zip")
    info("Downloading standard test images")
    download("http://www.imageprocessingplace.com/downloads_V3/root_downloads/image_databases/standard_test_images.zip", fname)
    expandzip(fname)
end

# Additional standard files
remotedict = @compat Dict(
    "lighthouse.png" => "http://r0k.us/graphics/kodak/kodak/kodim21.png",
    "mountainstream.png" => "http://r0k.us/graphics/kodak/kodak/kodim13.png",
    "moonsurface.tiff" => "http://sipi.usc.edu/database/download.php?vol=misc&img=5.1.09",
    "mandrill.tiff" => "http://sipi.usc.edu/database/download.php?vol=misc&img=4.2.03",
    "autumn_leaves.png" => "http://www.imagemagick.org/Usage/images/autumn_leaves.png",
    "earth_apollo17.jpg" => "http://upload.wikimedia.org/wikipedia/commons/9/97/The_Earth_seen_from_Apollo_17.jpg",
    "toucan.png" => "http://www.libpng.org/pub/png/img_png/stefan_full_rgba.png",
    "mri-stack.tif" => "http://imagej.nih.gov/ij/images/mri-stack.zip",
    "m51.tif" => "http://imagej.nih.gov/ij/images/m51.tif",
    "hela-cells.tif" => "http://imagej.nih.gov/ij/images/hela-cells.zip",
    "blobs.gif" => "http://imagej.nih.gov/ij/images/blobs.gif",
    "multi-channel-time-series.ome.tif" => "http://www.openmicroscopy.org/Schemas/Samples/2015-01/bioformats-artificial/multi-channel-time-series.ome.tif.zip"
)

for (k, v) in remotedict
    fn = joinpath(imagedir, k)
    if !isfile(fn)
        info("Downloading $fn")
        # an ugly kluge to deal with urls that point at zipped files
        _, ext = splitext(v)
        if ext == ".zip"
            download(v, joinpath(imagedir, k * ".zip"))
            expandzip(fn * ".zip")
        else
            download(v, joinpath(imagedir, k))
        end
    end
end
