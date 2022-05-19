# TestImages.jl

This package provides a convenient Julia interface for loading
[standard named test images](https://en.wikipedia.org/wiki/Standard_test_image) and example images for the internal usage in JuliaImages.
This can be used in conjunction with the
[Images](https://github.com/JuliaImages/Images.jl) package.

## Installation
Just like all normal Julia packages, you can use Pkg to install it:

```julia
pkg> add TestImages # hit ] to enter Pkg mode
```

`TestImages` doesn't support image IO by itself, which means you need to install some backends on your choice, e.g., [ImageMagick.jl](https://github.com/JuliaIO/ImageMagick.jl), [QuartzImageIO](https://github.com/JuliaIO/QuartzImageIO.jl), [OMETIFF.jl](https://github.com/tlnagy/OMETIFF.jl).

## Usage

This package currently contains two main functions:

- `testimage` that loads existing image files. Check the [list of test images](@ref imagelist) for what's available.
- `testimage_dip3e` that loads an image from the DIP3E textbook. "Digital Image Processing, 3rd edition"
  by Rafael C. Gonzalez and Richard E. Woods.
- `shepp_logan` that generates a phantom image, which is used very widely in image reconstruction experiments.

```@example usage
using TestImages

img = testimage("cameraman.tif") # fullname
img = testimage("cameraman") # without extension works
img = testimage("cam") # with only partial name also works
```

```@example usage
img = testimage_dip3e("fig0905") # load figure 9.5: wirebond-mask from the DIP3E textbook
img = testimage_dip3e("wirebond-mask") # same as above
```

```@example usage
TestImages.shepp_logan(256) # generate the Shepp-Logan phantom image
```
