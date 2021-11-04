function generate_imagelist(root)
    filenames = sort(TestImages.remotefiles, by=x->lowercase(splitext(x)[1]))

    N = length(filenames)
    names = [splitext(filename)[1] for filename in filenames]
    imgs = [testimage(filename) for filename in filenames]
    colors = [eltype(img) for img in imgs]
    sizes = size.(imgs)
    paths = ones(String,N)

    # Generate and save thumbnails
    mkpath(joinpath(root, "thumbnails"))
    HEIGHT = 200
    for i in 1:N

        if length(sizes[i]) == 2
            # Normal image
            width = round(Int, HEIGHT / sizes[i][1] * sizes[i][2])
            thumbnail = imresize(imgs[i], HEIGHT, width)
            path = joinpath(root, "thumbnails", names[i]*".png")
            paths[i] = path
            save(path, thumbnail)

        elseif length(sizes[i]) == 3
            # 3-dimensional image, will be converted animated gif
            width = round(Int, HEIGHT / sizes[i][1] * sizes[i][2])
            img = collect(imgs[i])
            thumbnail = Array{eltype(img),3}(undef,HEIGHT,width,sizes[i][3])
            for j in 1:sizes[i][3]
                thumbnail[:,:,j] = imresize(img[:,:,j], HEIGHT, width)
            end
            path = joinpath(root, "thumbnails", names[i]*".gif")
            paths[i] = path
            fps = ceil(Int, size(thumbnail, 3)/3) # we want the image loop within 3 seconds
            save(path, clamp01!(thumbnail); fps=fps)

        elseif length(sizes[i]) == 4
            # multi-channel image, will be converted animated gif
            width = round(Int, HEIGHT / sizes[i][1] * sizes[i][2])
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

    # Load the metadata
    path_toml = TestImages.image_path("metadata.toml")
    metadata = if isfile(path_toml)
        Dict{String,String}.(TOML.parsefile(path_toml)["images"])
    else
        # backward compat: old artifacts doesn't have "metadata.toml"
        Dict{String,String}[]
    end

    # Generate markdown, including a table of images
    script = """
    # [List of test images](@id imagelist)

    | Image | Name | Color | Size | Note |
    | :---- | :--- | :---- | :--- | :--- |
    """

    for i in 1:N
        filename = filenames[i]
        path_thumbnail = joinpath("thumbnails", basename(paths[i]))
        color = colors[i]
        size = sizes[i]
        name = extract_name(metadata, filename)
        note = extract_note(metadata, filename)
        script *= "| ![]($(path_thumbnail)) | $(name) | `$(color)` | `$(size)` | $(note) |\n"
    end

    write(joinpath(root, "imagelist.md"), script)
end

function extract_name(metadata, filename)
    path_original = "https://raw.githubusercontent.com/JuliaImages/TestImages.jl/images/images/" * filename
    link = "[`$(filename)`]($(path_original))"

    isempty(metadata) && return link

    # Extract name section in the table
    name = splitext(filename)[1]
    j = findfirst(data -> data["name"]==name, metadata)
    if !isnothing(j)
        # If full name is available, full name in bold and its link will be returned
        data = metadata[j]
        if "fullname" in keys(data)
            fullname = data["fullname"]
            return "**$(fullname)**, " * link
        end
    end
    # If full name isn't available, a filename with link to its original image will be returned
    return link
end

function extract_note(metadata, filename)
    isempty(metadata) && return ""
    # Extract note section in the table

    name = splitext(filename)[1]
    j = findfirst(data -> data["name"]==name, metadata)
    note = String[]
    if !isnothing(j)
        data = metadata[j]
        if "url" in keys(data)
            url = data["url"]
            push!(note, "[origin]($(url))")
        end
        if "author" in keys(data)
            author = data["author"]
            push!(note, "by $(author)")
        end
        if "lisence" in keys(data)
            lisence = data["lisence"]
            push!(note, "$(lisence)")
        end
    end
    return join(note, ", ")
end
