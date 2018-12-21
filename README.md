# TestImages

[![Build Status](https://travis-ci.org/JuliaImages/TestImages.jl.png)](https://travis-ci.org/JuliaImages/TestImages.jl)

This package provides a convenient Julia interface for loading
[standard named test images](https://en.wikipedia.org/wiki/Standard_test_image).
This can be used in conjunction with the
[Images](https://github.com/JuliaImages/Images.jl) package.

## Documentation

Full documentation and description of the images available in TestImages.jl can be found [here](https://testimages.juliaimages.org/).

## Installation

On Linux and OSX, this should install automatically. If you find yourself missing most of the images described in the documentation, please try `Pkg.build("TestImages")`, which should trigger another attempt to download the images.

In case you would like to download other images from the repository not in the standard set, you can call the ```testimage``` with the image name and it will be downloaded from the repository.

On Windows, the ```download``` command, used to download images from the archives, is not fully supported. You can manually download the files listed in ```deps\build.jl``` from the ```images``` folder of the ```gh-pages``` branch of this repository and place them in ```TestImages\images```.

## Usage

```
using TestImages

img = testimage("cameraman")
```

The standard test images are downloaded to an `images/` directory
inside this package.  Any image file stored in this directory is
accessible through the `testimage` function.  You can supply the file
extension (e.g., ".png", ".tif", etc), but it is not required. Indeed,
the matching is performed using just the portion of the filename you
supply, so `testimage("cam")` yields the same result.

In case the image is not present locally, the ```testimage``` function will check the online repository and download it for you.

## Contributing

A detailed guide on contributing to TestImages.jl can be found in the documentation mentioned above.
