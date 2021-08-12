# This script generates a tar.gz artifact for all contents in `images/` folder so that we can feed
# it into `Artifacts.toml`.
# https://github.com/JuliaImages/TestImages.jl/issues/67
#
# GitHub action "Upload Artifacts" runs this script and uploads the generated artifact file

using SHA
using TOML
import Tar
import TranscodingStreams: TranscodingStream
import CodecZlib: GzipCompressor, GzipDecompressor

compress(io::IO) = TranscodingStream(GzipCompressor(level=9), io)
decompress(io::IO) = TranscodingStream(GzipDecompressor(), io)

# Generate images.tar.gz
tarball, tree_path = abspath.(("images.tar.gz", "images"))
open(tarball, write=true) do io
    close(Tar.create(tree_path, compress(io)))
end

# Check the filenames in images/metadata.toml
metadata = TOML.parsefile(joinpath("images","metadata.toml"))
filenames_meta = [img["name"] for img in metadata["images"]]
filenames_dir = [splitext(name)[1] for name in readdir("images")]
@assert filenames_meta ⊆ filenames_dir

# Generate hashes
tree_hash = open(io -> Tar.tree_hash(decompress(io)), tarball)
tarball_hash = open(io -> bytes2hex(sha256(io)), tarball)

# Set the hashes as output parameters if on GitHub Actions
if !haskey(ENV, "GITHUB_ACTIONS")
    @info "Artifact generated" tarball_hash tree_hash
else
    # set the output value of the current stage in Github Action
    # https://docs.github.com/en/actions/reference/workflow-commands-for-github-actions#setting-an-output-parameter
    run(`echo`)
    run(`echo "::set-output name=tarball_hash::$tarball_hash"`)
    run(`echo`)
    run(`echo "::set-output name=tree_hash::$tree_hash"`)
    run(`echo`)
end
