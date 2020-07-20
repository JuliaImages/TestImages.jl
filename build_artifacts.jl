# This script generates a tar.gz artifact for all contents in `images/` folder so that we can feed
# it into `Artifacts.toml`.
# https://github.com/JuliaImages/TestImages.jl/issues/67
#
# Github action "Upload Artifacts" runs this script and uploads the generated artifact file

import Tar
import TranscodingStreams: TranscodingStream
import CodecZlib: GzipCompressor, GzipDecompressor

compress(io::IO) = TranscodingStream(GzipCompressor(level=9), io)
decompress(io::IO) = TranscodingStream(GzipDecompressor(), io)


tarball, tree_path = abspath.(("images.tar.gz", "images"))
open(tarball, write=true) do io
    close(Tar.create(tree_path, compress(io)))
end

tarball_hash = open(io -> Tar.tree_hash(decompress(io)), tarball)

if !haskey(ENV, "GITHUB_ACTIONS")
    @info "Artifact generated" hash=tarball_hash
else
    # set the output value of the current stage in Github Action
    # https://docs.github.com/en/actions/reference/workflow-commands-for-github-actions#setting-an-output-parameter
    println("::set-output name=tarball_hash::$tarball_hash")
end
