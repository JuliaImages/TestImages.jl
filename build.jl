using ImageTransformations, YAML, ImageCore, FileIO
# Settings
# (a) white list file endings
imageFileExtensions = [".gif",".jpg",".jpeg",".png",".tif",".tiff", ".bmp"]

# Open the HTML prequel and put it into our content we build.
content = read("open.txt",String)

# Read all images
f = readdir("images/")
# Read yaml metadata
imageMetadata = YAML.load(open("metadata.yml"))

# Initialize Thumbnails directory if it does not yet exist
if !isdir("thumbnails")
  println("Creating thumbnails/ folder.")
  mkdir("thumbnails")
end
# copy default if not yet copied
if !isfile("thumbnails/cannot_be_displayed.png")
    println("Copying cannot_be_displayed.png")
    cp("cannot_be_displayed.png","thumbnails/cannot_be_displayed.png")
end
HEIGHT = 200

# Go through all files
for i in f
    global content
    print("Processing file "*i*": ")
    fname, ext =splitext(i)
    if ext ∉ imageFileExtensions
      print("ignoring "*i*" since the file extension `"*
        ext*"`` is not in the white list (see build.jl)")
    else
        img = load(joinpath("images/",i))
        file=""
        # fetch metadata (is empty if no yaml entry exists)
        fileMeta = get(imageMetadata,fname,Dict())
        if length(size(img))==2
            file=fname*".png"
            if !isfile(joinpath("thumbnails/",file))
                img_size = size(img)
                resized_image = imresize(img, (Int(ceil(img_size[1]*HEIGHT/img_size[2])), HEIGHT))
                save(joinpath("thumbnails/",file), resized_image)
                print("--- tumbnails/"*fname*".png created. ---")
            else
                print(" tumbnails/"*fname*".png already exists. Skipping")
            end
        else
            print("can not be displayed, set default thumbnail")
            file="cannot_be_displayed.png"
        end
        content *= "\""*fname*"\" : "*"{"
        # check for metatdata fields and add them
        for key in ["name","url","author"]
        if haskey(fileMeta,key)
            content *= key * ":\"" * fileMeta[key] * "\", "
        end
        end
        # and the classical ones
        content *= "thumbnail:\""*file*"\", "
        content *= "file:\""*i*"\", "
        content *= "colorspace:\""*string(base_color_type(eltype(img)))*"\", "
        content *= "size : \""*string(size(img))*"\", "
        content *= "filetype : \""*uppercase(ext[2:end])*"\"},\n"
    end # if in whiltelist
  print(".\n")
end
# add end of html file and write out js.
content *= read("close.txt",String);
write("displayimages.js", content);
