using Compat

#### For reading a string

"""
    readlengthandstring(io::IO)

read  `n::Int64` from `io`. Then read `n` bytes from `io`
and return as a string.
"""
function readlengthandstring(io::IO)
    stringlength = read(io,Int64)
    readstring(io,stringlength)
end

function readstring(io::IO,stringlength::Int32)
    buf = Array(UInt8,convert(Int64,stringlength))
    readbytes!(io,buf)
@compat  unsafe_string(pointer(buf))
end


"""
    readstring(io::IO,stringlength::Int64)

read  `stringlength` bytes from `io` and return as a string.
"""
function readstring(io::IO,stringlength::Int64)
    buf = Array(UInt8,stringlength)
    readbytes!(io,buf)
@compat  unsafe_string(pointer(buf))
end

function peektypeold(io::IO, T::DataType)
    p = position(io)
    res = read(io,T)
    seek(io,p)
    res
end

function peektype(io::IO, T::DataType)
    mark(io)
    res = read(io,T)
    reset(io)
    res
end
