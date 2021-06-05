# MIT License
#
# Copyright (c) 2021 Johnny Chen
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# written with Julia 1.6
using ImageCore, ColorVectorSpace
using OffsetArrays, PaddedViews
using BasicTextRender
using ImageShow
using Interpolations
using ImageTransformations
using FileIO
using Luxor

function make_block(block_size, fillcolor, textcolor, text)
    block = fill(RGBA(fillcolor), block_size)
    h = block_size[1] ÷ 3
    o = (h ÷ 2, h * length(text)÷4)
    bottomleft = OffsetArrays.center(block) .- o
    overlaytext!(block, text, h, bottomleft; color=RGBA{Float64}(textcolor))
    return block
end

function colorblocks(num_blocks, block_size, shape)
    @assert isodd(prod(num_blocks))

    nc = (prod(num_blocks)+1)÷2
    # the last white color is dropped
    palette = map(reverse(colormap("Reds", nc)), fill(RGB{Float64}(0.98, 0.98, 0.98), nc)) do x, y
        vcat(x, y)
    end |> cs->vcat(cs...)
    blocks = map(1:prod(num_blocks), CartesianIndices(reverse(num_blocks))) do i, pos
        o = block_size .* (reverse(pos.I) .- 1)
        c = palette[i]
        block = make_block(
            block_size,
            RGBA{Float64}(c),
            RGBA{Float64}(0.0, 0.0, 0.0, 1.0),
            string(i)
            )
        OffsetArray(block, o)
    end
    fillvalue = RGBA{Float64}(0.0, 0.0, 0.0, 0.0)
    img = reduce(+, paddedviews(fillvalue, blocks...))

    # add shapes
    b,r,g,p = Colors.JULIA_LOGO_COLORS
    mask = @. (shape == b) | (shape == r) | (shape == g) | (shape == p)
    img[mask] .= shape[mask]

    # draw bounding box
    img = begin
        topleft = OffsetArray(fill(fillvalue, 1, 1), (-25, -25))
        bottomright = OffsetArray(fill(fillvalue, 1, 1), (num_blocks.*block_size .+ (25, 25) .- 1))
        img = reduce(+, paddedviews(fillvalue, topleft, bottomright, img))

        img[-10:-8, :] .= RGBA(0, 0, 0, 0.3)
        img[:, -10:-8] .= RGBA(0, 0, 0, 0.3) 
        img[end-10:end-8, :] .= RGBA(0, 0, 0, 0.3)
        img[:, end-10:end-8] .= RGBA(0, 0, 0, 0.3)

        img[-10:-8, -10:end-10] .= RGBA(0, 0, 0, 1)
        img[-10:end-10, -10:-8] .= RGBA(0, 0, 0, 1) 
        img[end-10:end-8, -10:end-10] .= RGBA(0, 0, 0, 1)
        img[-10:end-10, end-10:end-8] .= RGBA(0, 0, 0, 1)
        img
    end
end

function generate_testpattern()
    shapefile = tempname() * ".png"
    @png begin
        b,r,g,p = Colors.JULIA_LOGO_COLORS

        @layer begin
            setcolor(p)
            arrow(Point(0, -20), 200, 11.7π/10, 18.5π/10, arrowheadlength=40, arrowheadangle=pi/6, linewidth=10)
        end
        @layer begin
            ▲ = Point[Point(-330.0, -170.0), Point(-330.0, 170.0), Point(-30.0, 0.0)]
            setcolor(r)
            setline(10)
            poly(▲,  :stroke, close=true)
        end
        @layer begin
            ▲ = Point[Point(330.0, -170.0), Point(330.0, 170.0), Point(30.0, 0.0)]
            setcolor(g)
            setline(10)
            poly(▲,  :stroke, close=true)
        end
    end 700 500 shapefile

    shape = load(shapefile)
    rm(shapefile; force=true)

    return colorblocks((5, 7), (100, 100), shape)
end

image_file = joinpath("images", "testpattern.png")
thumbnail_file = joinpath("thumbnails", "testpattern.png")
if isfile(image_file)
    @info "regenerate testpattern" file=image_file
    rm(thumbnail_file; force=true)
    rm(image_file; force=true)
end
generate_testpattern() |> save(image_file)
