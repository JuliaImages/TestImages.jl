module TestImages
using Images
using Compat

export testimage

const imagedir = joinpath(Pkg.dir(), "TestImages", "images")

function testimage(filename, ops...)
    imagefile = joinpath(imagedir, filename)
    if !isfile(imagefile)
        fls = readdir(imagedir)
        havefile = false
        for f in fls
            if startswith(f, filename)
                imagefile = joinpath(imagedir, f)
                havefile = true
                break
            end
        end
        havefile || error("$filename not found. Here are the contents of the images/ directory:\n$(join(fls, '\n'))")
    end
    imread(imagefile, ops...)
end

end
