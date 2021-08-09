using Documenter, TestImages, Images, OMETIFF

include("generate_imagelist.jl")

generate_imagelist()

makedocs(;
    modules=[TestImages],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
        "List of images" => "imagelist.md",
        "Contributing" => "contributing.md",
    ],
    repo="https://github.com/JuliaImages/TestImages.jl/blob/{commit}{path}#L{line}",
    sitename="TestImages.jl",
)

deploydocs(;
    repo="github.com/JuliaImages/TestImages.jl"
)
