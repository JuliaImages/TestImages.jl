function generate_imagelist(root, (testimage, database), out_file, preface)
    filenames = sort(database, by=x->lowercase(splitext(x)[1]))

    N = length(filenames)
    names = [splitext(filename)[1] for filename in filenames]
    imgs = map(filenames) do f
        float.(testimage(f))
    end
    colors = [eltype(img) for img in imgs]
    sizes = size.(imgs)
    paths = ones(String,N)

    # Generate and save thumbnails
    mkpath(joinpath(root, "thumbnails"))
    HEIGHT = 200
    WIDTH = 200
    cal_ratio(img) = minimum((HEIGHT, WIDTH)./size(img))
    for i in 1:N
        if length(sizes[i]) == 2
            # Normal image
            img = imgs[i]
            thumbnail = clamp01nan!(imresize(img, ratio=cal_ratio(img)))
            path = joinpath(root, "thumbnails", names[i]*".png")
            paths[i] = path
            save(path, thumbnail)

        elseif length(sizes[i]) == 3
            # 3-dimensional image, will be converted animated gif
            img = collect(imgs[i])
            slice = @view img[:, :, 1]
            sz = size(imresize(slice, ratio=cal_ratio(slice)))
            thumbnail = Array{floattype(eltype(img)),3}(undef,sz...,sizes[i][3])
            for j in 1:sizes[i][3]
                slice = @view img[:,:,j]
                thumbnail[:,:,j] = clamp01nan!(imresize(slice, ratio=cal_ratio(slice)))
            end
            path = joinpath(root, "thumbnails", names[i]*".gif")
            paths[i] = path
            fps = ceil(Int, size(thumbnail, 3)/3) # we want the image loop within 3 seconds
            save(path, thumbnail; fps=fps)

        elseif length(sizes[i]) == 4
            # multi-channel image, will be converted animated gif
            n_frames = sizes[i][3] * sizes[i][4]
            img = reshape(permutedims(collect(imgs[i]),(1,2,4,3)),sizes[i][1],sizes[i][2],n_frames)
            slice = @view img[:, :, 1]
            sz = size(imresize(slice, ratio=cal_ratio(slice)))
            thumbnail = Array{floattype(eltype(img)),3}(undef,sz...,n_frames)
            for j in 1:n_frames
                slice = @view img[:, :, j]
                thumbnail[:,:,j] = clamp01nan!(imresize(slice, ratio=cal_ratio(slice)))
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
    $(preface)

    | Image | Name | Color | Size | Note |
    | :---- | :--- | :---- | :--- | :--- |
    """

    for i in 1:N
        filename = filenames[i]
        path_thumbnail = joinpath("thumbnails", basename(paths[i]))
        color = base_colorant_type(colors[i])
        size = sizes[i]
        name = if testimage == TestImages.testimage
            extract_name(metadata, filename)
        else
            "\"$filename\""
        end
        note = extract_note(metadata, filename)
        # FIXME(johnnychen94): some files are now shown properly because of double underscore, e.g., testimage_dip3e("Fig0622")
        script *= "| ![]($(path_thumbnail)) | $(name) | `$(color)` | `$(size)` | $(note) |\n"
    end

    write(joinpath(root, out_file), script)
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
