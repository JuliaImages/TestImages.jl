# Contributing
## Adding images
Anyone can contribute images to this repository by submitting a pull request at the github repo.

### Step 1: adding images to `images` branch
The following steps should be followed to add an image/imageset to the repository:

1. Check the images for copyright or license issues before adding images.
1. Do `git checkout images` in your local repository folder. `Pkg.dir("TestImages")` gives the location of the repo.
1. Add the image locally to the `images/` folder on your machine.
1. If you have metadata, a more common name, a url for the source or an author, you can add that to the `metadata.yml`.
1. Do `git add --all` to stage the changes for a commit.
1. `git commit -m "Adds <filename> to the repository from link <link>"`
1. `git push <fork> images`
1. Now submit a pull request to the `images` branch. Once accepted, the image or imageset will be stored at `https://github.com/JuliaImages/TestImages.jl/blob/images/images/<filename>`.

Now that the images are added to the repository, maintainers will then create a tag(not release) v*-artifacts for `images` branch and push it to the repo.
After that, github action CI defined in `images` branch will be triggered, build and release an tarball artifact for this commit.

### Step 2: update `master` branch
The next step is to modify the source files of the `TestImages.jl` package to make them available for download, i.e., add it to `remotefiles` list.

1. Do `git checkout master` to return to the `master` branch.
1. Modify `src/TestImages.jl` : Add an entry with the filename to the remotefiles dictionary.
1. Modify `Artifacts.toml`: updates `[images]` section with the newly released artifacts.
1. Do `git add --all` to add the changed source files.
1. `git commit -m "Adds <filename> to package"`
1. `git push <fork> master`
1. Now submit a pull request to the `master` branch. Once accepted, the image or imageset will be available for download to users of `TestImages.jl`.

## Others
Feel free to open [issues](https://github.com/JuliaImages/TestImages.jl/issues) or [pull-requests](https://github.com/JuliaImages/TestImages.jl/pulls).
If you have any questions, you can ask in [Discourse](https://discourse.julialang.org/) or `#image-processing` channel in [Slack](https://julialang.org/slack/).
