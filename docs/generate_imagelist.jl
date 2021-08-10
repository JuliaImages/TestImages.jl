function generate_imagelist()
    filenames = TestImages.remotefiles

    N = length(filenames)
    names = [splitext(filename)[1] for filename in filenames]
    imgs = [testimage(filename) for filename in filenames]
    colors = [eltype(img) for img in imgs]
    sizes = size.(imgs)
    paths = ones(String,N)

    # Save original images
    mkpath("docs/src/images")
    for i in 1:N
        filename = filenames[i]
        cp(TestImages.image_path(filename), "docs/src/images/$(filename)", force=true)
    end

    # Generate and save thumbnails
    mkpath("docs/src/thumbnails")
    HEIGHT = 200
    for i in 1:N

        if length(sizes[i]) == 2
            # Normal image
            width = round(Int, HEIGHT / /(sizes[i]...))
            thumbnail = imresize(imgs[i], HEIGHT, width)
            path = "docs/src/thumbnails/$(names[i]).png"
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
            path = "docs/src/thumbnails/$(names[i]).gif"
            paths[i] = path
            save(path, thumbnail)

        elseif length(sizes[i]) == 4
            # multi-channel image, will be converted animated gif
            width = round(Int, HEIGHT / /(sizes[i][1],sizes[i][2]))
            n_frames = sizes[i][3] * sizes[i][4]
            img = reshape(permutedims(collect(imgs[i]),(1,2,4,3)),sizes[i][1],sizes[i][2],n_frames)
            
            thumbnail = Array{eltype(img),3}(undef,HEIGHT,width,n_frames)
            for j in 1:n_frames
                thumbnail[:,:,j] = imresize(img[:,:,j], HEIGHT, width)
            end
            path = "docs/src/thumbnails/$(names[i]).gif"
            paths[i] = path
            save(path, thumbnail)

        end
    end

    # Generate markdown, a list of image
    script = """
    # List of test images

    | Image | Name | Color | Size | Note |
    | :---- | :--- | :---- | :--- | :---------- |
    """

    for i in 1:N
        path_thumbnail = paths[i][10:end] # removing "docs/src/"
        filename = filenames[i]
        path_orginal = joinpath("images",filename)
        color = colors[i]
        size = sizes[i]
        # TODO: fill the `note` section referring to metadata.yml
        script *= "| ![]($(path_thumbnail)) | [`$(filename)`]($(path_orginal)) | `$(color)` | `$(size)` |  |\n"
    end

    write("docs/src/imagelist.md", script)
end
 