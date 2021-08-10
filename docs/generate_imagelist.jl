function generate_imagelist(root)
    filenames = sort(TestImages.remotefiles, by=x->lowercase(splitext(x)[1]))

    N = length(filenames)
    names = [splitext(filename)[1] for filename in filenames]
    imgs = [testimage(filename) for filename in filenames]
    colors = [eltype(img) for img in imgs]
    sizes = size.(imgs)
    paths = ones(String,N)

    # Save original images
    mkpath(joinpath(root, "images"))
    for i in 1:N
        filename = filenames[i]
        cp(TestImages.image_path(filename), joinpath(root, "images", filename), force=true)
    end

    # Generate and save thumbnails
    mkpath(joinpath(root, "thumbnails"))
    HEIGHT = 200
    for i in 1:N

        if length(sizes[i]) == 2
            # Normal image
            width = round(Int, HEIGHT / /(sizes[i]...))
            thumbnail = imresize(imgs[i], HEIGHT, width)
            path = joinpath(root, "thumbnails", names[i]*".png")
            paths[i] = path
            save(path, thumbnail)

        elseif length(sizes[i]) == 3
            # 3-dimensional image, will be converted animated gif
            width = round(Int, HEIGHT / /(sizes[i][1],sizes[i][2]))

            img = collect(imgs[i])
            thumbnail = Array{eltype(img),3}(undef,HEIGHT,width,sizes[i][3])
            for j in 1:sizes[i][3]
                thumbnail[:,:,j] = imresize(img[:,:,j], HEIGHT, width)
            end
            path = joinpath(root, "thumbnails", names[i]*".gif")
            paths[i] = path
            fps = ceil(Int, size(thumbnail, 3)/3) # we want the image loop within 3 seconds
            save(path, thumbnail; fps=fps)

        elseif length(sizes[i]) == 4
            # multi-channel image, will be converted animated gif
            width = round(Int, HEIGHT / /(sizes[i][1],sizes[i][2]))
            n_frames = sizes[i][3] * sizes[i][4]
            img = reshape(permutedims(collect(imgs[i]),(1,2,4,3)),sizes[i][1],sizes[i][2],n_frames)
            
            thumbnail = Array{eltype(img),3}(undef,HEIGHT,width,n_frames)
            for j in 1:n_frames
                thumbnail[:,:,j] = imresize(img[:,:,j], HEIGHT, width)
            end
            path = joinpath(root, "thumbnails", names[i]*".gif")
            paths[i] = path
            save(path, thumbnail)

        end
    end

    # Generate markdown, including a table of images
    script = """
    # List of test images

    !!! info "Metadata of the images"
        Currently, the table below does not contain `Note` section.
        For more infomation about their metadata, see [metadata.yml](https://github.com/JuliaImages/TestImages.jl/blob/images/metadata.yml)
 
    | Image | Name | Color | Size | Note |
    | :---- | :--- | :---- | :--- | :---------- |
    """

    for i in 1:N
        filename = filenames[i]
        path_orginal = joinpath("images", filename)
        path_thumbnail = joinpath("thumbnails", basename(paths[i]))
        color = colors[i]
        size = sizes[i]
        # TODO: fill the `note` section referring to metadata.yml
        script *= "| ![]($(path_thumbnail)) | [`$(filename)`]($(path_orginal)) | `$(color)` | `$(size)` |  |\n"
    end

    write(joinpath(root, "imagelist.md"), script)
end
 