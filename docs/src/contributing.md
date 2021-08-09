# Contributing
Anyone can contribute images to this repository by submitting a pull request at the github repo.
Do check the images for copyright or license issues before submitting.

The following steps should be followed to add an image/imageset to the repository:

* Do `git checkout gh-pages` in your local repository folder. `Pkg.dir("TestImages")` gives the location of the repo.
* Add the image locally to the `images/` folder on your machine.
* If you have metadata, a more common name, a url for the source or an author, you can add that to the metadata.yml.
* Run `build.jl` : Do `julia build.jl` to generate the javascript file for the documentation. This will also generate an according thumbnail in the thumbnails folder.
    * To recreate a thumbail, delete the previously created thumbnail.
    * To add a file extension, edit the imageFileExtensions array in the `build.jl`
* Do `git add --all` to stage the changes for a commit.
* `git commit -m "Adds <filename> to the repository from link <link>"`
* `git push <fork> gh-pages`
* Now submit a pull request to the gh-pages branch. Once accepted, the image or imageset will be stored at https://github.com/JuliaImages/TestImages.jl/blob/gh-pages/images/<filename>.

Now that the images are added to the repository, maintainers will then create a tag(not release) v*-artifacts for gh-pages branch and push it to the repo. After that, github action CI defined in `gh-pages` branch will be triggered, build and release an tarball artifact for this commit. The next step is to modify the source files of the TestImages.jl package to make them available for download, i.e., add it to `remotefiles` list.

* Do `git checkout master` to return to the `master` branch.
* Modify `src/TestImages.jl` : Add an entry with the filename to the remotefiles dictionary.
* Modify `Artifacts.toml`: updates [images] section with the newly released artifacts.
* Do `git add --all` to add the changed source files.
* `git commit -m "Adds <filename> to package"`
* `git push <fork> master`
* Now submit a pull request to the master branch. Once accepted, the image or imageset will be available for download to users of TestImages.jl.
