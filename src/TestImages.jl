module TestImages
using Images

export testimage

const imagedir = joinpath(Pkg.dir(), "TestImages", "images")

function testimage(filename, ops...)
    imagefile = joinpath(imagedir, filename)
    if !isfile(imagefile)
        fls = readdir(imagedir)
        havefile = false
        for f in fls
            if beginswith(f, filename)
                imagefile = joinpath(imagedir, f)
                havefile = true
                break
            end
        end
        havefile || error("$filename not found")
    end
    imread(imagefile, ops...)
end

end
