# TestImages

[![][travis-img]][travis-url]
[![][pkgeval-img]][pkgeval-url]
[![][codecov-img]][codecov-url]

This package provides a convenient Julia interface for loading
[standard named test images](https://en.wikipedia.org/wiki/Standard_test_image).
This can be used in conjunction with the
[Images](https://github.com/JuliaImages/Images.jl) package.

## Documentation

Full documentation and description of the images available in TestImages.jl can be found [here](https://testimages.juliaimages.org/).

## Installation

`TestImages` doesn't support image IO by itself, which means you need to install some backends on your choice, e.g., [ImageMagick.jl](https://github.com/JuliaIO/ImageMagick.jl), [QuartzImageIO](https://github.com/JuliaIO/QuartzImageIO.jl), [OMETIFF.jl](https://github.com/tlnagy/OMETIFF.jl).

## Usage

```
using TestImages

img = testimage("cameraman.tif") # fullname
img = testimage("cameraman) # without extension works
img = testimage("cam") # with only partial name also works
```

Images will be automatically downloaded into artifact folders (e.g., `images/` for julia `< v1.3`) when you load the image for the first time.

## Contributing

A detailed guide on contributing to TestImages.jl can be found in the documentation mentioned above.

<!-- URLS -->

[pkgeval-img]: https://juliaci.github.io/NanosoldierReports/pkgeval_badges/T/TestImages.svg
[pkgeval-url]: https://juliaci.github.io/NanosoldierReports/pkgeval_badges/report.html
[travis-img]: https://travis-ci.org/JuliaImages/TestImages.jl.svg?branch=master
[travis-url]: https://travis-ci.org/JuliaImages/TestImages.jl
[codecov-img]: https://codecov.io/github/JuliaImages/TestImages.jl/coverage.svg?branch=master
[codecov-url]: https://codecov.io/github/JuliaImages/TestImages.jl?branch=master
