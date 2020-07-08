macro except_str(expr, err_type)
    return quote
        let err = nothing
            try
                $(esc(expr))
            catch err
            end
            err === nothing && error("expected failure, but no exception thrown")
            @test typeof(err) === $(esc(err_type))
            buf = IOBuffer()
            showerror(buf, err)
            String(take!(buf))
        end
    end
end
