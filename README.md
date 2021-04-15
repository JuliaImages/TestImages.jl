# TestImages

[![][action-img]][action-url]
[![][pkgeval-img]][pkgeval-url]
[![][codecov-img]][codecov-url]

This package provides a convenient Julia interface for loading
[standard named test images](https://en.wikipedia.org/wiki/Standard_test_image) and example images for the internal usage in JuliaImages.
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

phantom = TestImages.shepp_logan(256) # generate the Shepp-Logan phantom image
```

Images will be automatically downloaded into artifact folders when you load the image for the first time.

## Compatibility

For users with Julia < v1.3.0, TestImages v0.6.z will still be under maintenance. However, newly added test images will not be available in those versions.

## Contributing

A detailed guide on contributing to TestImages.jl can be found in the documentation mentioned above.

<!-- URLS -->

[pkgeval-img]: https://juliaci.github.io/NanosoldierReports/pkgeval_badges/T/TestImages.svg
[pkgeval-url]: https://juliaci.github.io/NanosoldierReports/pkgeval_badges/report.html
[action-img]: https://github.com/JuliaImages/TestImages.jl/workflows/Unit%20test/badge.svg
[action-url]: https://github.com/JuliaImages/TestImages.jl/actions
[codecov-img]: https://codecov.io/github/JuliaImages/TestImages.jl/coverage.svg?branch=master
[codecov-url]: https://codecov.io/github/JuliaImages/TestImages.jl?branch=master
