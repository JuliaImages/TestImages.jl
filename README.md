# TestImages

[![Build Status](https://travis-ci.org/timholy/TestImages.jl.png)](https://travis-ci.org/timholy/TestImages.jl)

This package provides a convenient Julia interface for loading
standard named test images. This is to be used in conjunction with the
[Images](https://github.com/timholy/Images.jl) package.

## Installation

On Linux and OSX, this should install automatically.

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

The supported images derive from a few publicly-available `zip` files
or databases. Here is a list of the currently-supported images:

`autumn_leaves` (color with transparency)

![autumn_leaves](http://www.imagemagick.org/Usage/images/autumn_leaves.png)

`cameraman`

![cameraman](http://codesmesh.com/wp-content/uploads/2013/04/cameraman.jpg)

`earth_apollo17` (a particularly large image)

![earth_apollo17](http://upload.wikimedia.org/wikipedia/commons/9/97/The_Earth_seen_from_Apollo_17.jpg)

`house`

`jetplane`

`lake`

![lake](images/lake.tif)

`lena_color_256`, `lena_color_512`, `lena_gray_256`, `lena_gray_512`

![lena_gray_512](http://www.ece.rice.edu/~wakin/images/lenaTest3.jpg)

`lighthouse`

![lighthouse](http://r0k.us/graphics/kodak/kodak/kodim21.png)

`livingroom`

`mandril_color`, `mandril_gray`, `mandrill`

![mandril_color](http://courses.cs.washington.edu/courses/cse455/10wi/projects/p1a/mandrill.png)

`moonsurface`

`mountainstream`

![mountainstream](http://r0k.us/graphics/kodak/kodak/kodim13.png)

`peppers_color`, `peppers_gray`

![peppers_color](http://www.topnews.in/files/Pepper_02.jpg)

`pirate`

`walkbridge`

`woman_blonde`

`woman_darkhair`

`fabio`

![fabio](images/fabio.png)

The Fabio image was extracted as a counterbalance to Lena from:

Needell, D., and Ward, R. "Stable image reconstruction using total variation minimization." SIAM Journal on Imaging Sciences 6.2 (2013): 1035-1058.
