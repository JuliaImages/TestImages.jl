# TestImages

[![][action-img]][action-url]
[![][pkgeval-img]][pkgeval-url]
[![][codecov-img]][codecov-url]
[![Stable][docstable-img]][docstable-url]
[![Dev][docdev-img]][docdev-url]

This package provides a convenient Julia interface for loading
[standard named test images](https://en.wikipedia.org/wiki/Standard_test_image) and example images for the internal usage in JuliaImages.
This can be used in conjunction with the
[Images](https://github.com/JuliaImages/Images.jl) package.

## Documentation

Full documentation and description of the images available in TestImages.jl can be found [here][doc-url].

## Installation

Just like all normal Julia packages, you can use Pkg to install it:

```julia
pkg> add TestImages # hit ] to enter Pkg mode
```

## Usage

```julia
using TestImages

img = testimage("cameraman.tif") # fullname
img = testimage("cameraman") # without extension works
img = testimage("cam") # with only partial name also works

img = testimage_dip3e("fig0905") # load figure 9.5: wirebond-mask from the DIP3E textbook
img = testimage_dip3e("wirebond-mask") # same as above

phantom = TestImages.shepp_logan(256) # generate the Shepp-Logan phantom image
```

`testimage_dip3e` loads an image from the DIP3E textbook, "Digital Image Processing, 3rd edition" by
Rafael C. Gonzalez and Richard E. Woods. Permission is required from the owner of a © image if the
image is used for other than personal educational or research purposes. See [copyright
file](https://www.imageprocessingplace.com/DIP-3E/dip3e_copyrights.htm).

Images will be automatically downloaded into artifact folders when you load the image for the first time.

## Compatibility

For users with Julia < v1.3.0, TestImages v0.6.z will still be under maintenance. However, newly added test images will not be available in those versions.

## Contributing

A detailed guide on contributing to TestImages.jl can be found in the documentation mentioned above.

## Related packages

* The
[MLDatasets.jl](https://github.com/JuliaML/MLDatasets.jl)
package includes several image collections.
* The
[ImagePhantoms](https://github.com/JuliaImageRecon/ImagePhantoms.jl)
package has additional versions of the Shepp-Logan phantom,
as well as other phantoms like focus charts,
and can compute sinograms and spectra of such phantoms.

<!-- URLS -->

[pkgeval-img]: https://juliaci.github.io/NanosoldierReports/pkgeval_badges/T/TestImages.svg
[pkgeval-url]: https://juliaci.github.io/NanosoldierReports/pkgeval_badges/report.html
[action-img]: https://github.com/JuliaImages/TestImages.jl/workflows/Unit%20test/badge.svg
[action-url]: https://github.com/JuliaImages/TestImages.jl/actions
[codecov-img]: https://codecov.io/github/JuliaImages/TestImages.jl/coverage.svg?branch=master
[codecov-url]: https://codecov.io/github/JuliaImages/TestImages.jl?branch=master
[docstable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docstable-url]: https://testimages.juliaimages.org/stable/
[docdev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docdev-url]: https://testimages.juliaimages.org/dev/
[doc-url]: https://testimages.juliaimages.org
