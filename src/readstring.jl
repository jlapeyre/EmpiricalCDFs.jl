#### For reading a string

function readlengthandstring(io::IO)
    stringlength = read(io,Int)
    readstring(io,stringlength)
end

function readstring(io::IO,stringlength::Int)
    buf = Array(UInt8,stringlength)
    readbytes!(io,buf)
    unsafe_string(pointer(buf))    
end
