using ZipFile

imagedir = joinpath(Pkg.dir(), "TestImages", "images")
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
    fname = joinpath(tempdir(), "standard_test_images.zip")
    download("http://www.ece.utk.edu/~gonzalez/ipweb2e/downloads/standard_test_images/standard_test_images.zip", fname)
    r = ZipFile.Reader(fname)
    for f in r.files
        _, fn = splitdir(f.name)
        if !isempty(fn)
            open(joinpath(imagedir, fn), "w") do s
                write(s, readall(f))
            end
        end
    end
    close(r)
end

# Additional standard files
remotedict = [
    "lighthouse.png" => "http://r0k.us/graphics/kodak/kodak/kodim21.png",
    "mountainstream.png" => "http://r0k.us/graphics/kodak/kodak/kodim13.png",
    "moonsurface.tiff" => "http://sipi.usc.edu/database/download.php?vol=misc&img=5.1.09",
    "mandrill.tiff" => "http://sipi.usc.edu/database/download.php?vol=misc&img=4.2.03",
    "autumn_leaves.png" => "http://www.imagemagick.org/Usage/images/autumn_leaves.png",
    "earth_apollo17.jpg" => "http://upload.wikimedia.org/wikipedia/commons/9/97/The_Earth_seen_from_Apollo_17.jpg"
]

for (k, v) in remotedict
    fn = joinpath(imagedir, k)
    if !isfile(fn)
        download(v, joinpath(imagedir, k))
    end
end
