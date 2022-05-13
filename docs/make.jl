using Documenter, TestImages, Images, OMETIFF, TOML

include("generate_imagelist.jl")

root = joinpath(@__DIR__, "src")

imagelist_preface = """
# [`testimage`](@id imagelist)

The images below can be loaded via `testimage(filename)`.

"""
generate_imagelist(root, (testimage, TestImages.remotefiles), "imagelist.md", imagelist_preface)

imagelist_dip3e_preface = """
# [`testimage_dip3e`](@id imagelist_dip3e)

The images below can be loaded via `testimage_dip3e(filename)`.

"""
generate_imagelist(root, (testimage_dip3e, TestImages.remotefiles_dip3e), "imagelist_dip3e.md", imagelist_dip3e_preface)

format = Documenter.HTML(edit_link = "master",
                         prettyurls = get(ENV, "CI", nothing) == "true")

makedocs(;
    modules=[TestImages],
    format=format,
    pages=[
        "Home" => "index.md",
        "List of images" =>
            [
                "imagelist.md",
                "imagelist_dip3e.md"
            ],
        "Function reference" => "functionreference.md",
        "Contributing" => "contributing.md",
    ],
    repo="https://github.com/JuliaImages/TestImages.jl/blob/{commit}{path}#L{line}",
    sitename="TestImages.jl",
)

deploydocs(;
    repo="github.com/JuliaImages/TestImages.jl",
    # A lot of thumbnails are generated, so compressing history in `gh-pages` avoids infinite
    # storage increasement.
    forcepush=true,
)
