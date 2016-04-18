# TestImages

[![Build Status](https://travis-ci.org/timholy/TestImages.jl.png)](https://travis-ci.org/timholy/TestImages.jl)

This package provides a convenient Julia interface for loading
[standard named test images](https://en.wikipedia.org/wiki/Standard_test_image).
This is to be used in conjunction with the
[Images](https://github.com/timholy/Images.jl) package.

## Documentation

Full documentation and description of the images available in TestImages.jl can be found [here](http://timholy.github.io/TestImages.jl/).

## Installation

On Linux and OSX, this should install automatically. If you find yourself missing most of the images described below, please try `Pkg.build("TestImages")`, which should trigger another attempt to download the images.

On Windows, the `download` command, used to download images from the archives, is not fully supported. You can manually download and unzip the files listed in `deps\build.jl` and place them in `TestImages\images`.

## Usage

```
using TestImages

img = testimage("cameraman")
```

The standard test images are downloaded to an `images/` directory
inside this package.  Any image file stored in this directory is
accessible through the `testimage` function.  You can supply the file
extension (e.g., ".png", ".tif", etc), but it is not required.

## Contributing

A detailed guide on contributing to TestImages.jl can be found in the documentation mentioned above.

