using TestImages

@info "Downloading standard test images"
foreach(x->testimage(x; download_only=true), TestImages.remotefiles)
