using Documenter, TestImages, Images, OMETIFF

include("generate_imagelist.jl")

generate_imagelist(joinpath(@__DIR__, "src"))

format = Documenter.HTML(edit_link = "master",
                         prettyurls = get(ENV, "CI", nothing) == "true")

makedocs(;
    modules=[TestImages],
    format=format,
    pages=[
        "Home" => "index.md",
        "List of images" => "imagelist.md",
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
