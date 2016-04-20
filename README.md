# TestImages

[![Build Status](https://travis-ci.org/timholy/TestImages.jl.png)](https://travis-ci.org/timholy/TestImages.jl)

This package provides a convenient Julia interface for loading
[standard named test images](https://en.wikipedia.org/wiki/Standard_test_image).
This is to be used in conjunction with the
[Images](https://github.com/timholy/Images.jl) package.

## Documentation

Full documentation and description of the images available in TestImages.jl can be found [here](http://timholy.github.io/TestImages.jl/).

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
extension (e.g., ".png", ".tif", etc), but it is not required.

In case the image is not present locally, the ```testimage``` function will check the online repository and download it for you.

## Contributing

A detailed guide on contributing to TestImages.jl can be found in the documentation mentioned above.

