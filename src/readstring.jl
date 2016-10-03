using Compat

#### For reading a string

function readlengthandstring(io::IO)
    stringlength = read(io,Int64)
    readstring(io,stringlength)
end

function readstring(io::IO,stringlength::Int32)
    buf = Array(UInt8,convert(Int64,stringlength))
    readbytes!(io,buf)
@compat  unsafe_string(pointer(buf))    
end

function readstring(io::IO,stringlength::Int64)
    buf = Array(UInt8,stringlength)
    readbytes!(io,buf)
@compat  unsafe_string(pointer(buf))    
end
