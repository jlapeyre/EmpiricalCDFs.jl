var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "EmpiricalCDFs",
    "title": "EmpiricalCDFs",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#EmpiricalCDFs-1",
    "page": "EmpiricalCDFs",
    "title": "EmpiricalCDFs",
    "category": "section",
    "text": "Empirical cumulative distribution functionsThe source repository is https://github.com/jlapeyre/EmpiricalCDFs.jl.Provides empirical cumulative distribution functions (CDFs) (or \"empirical distribution functions\" as they are know to probabalists).EmpiricalCDFs implements empirical CDFs; building, evaluating, random sampling, evaluating the inverse, etc. It is useful especially for examining the tail of the CDF obtained from streaming a large number of data, more than can be stored in memory. For this purpose, you specify a lower cutoff; data points below this value will be silently rejected, but the resulting CDF will still be properly normalized. This ability to process and filter data online is absent in StatsBase.ecdf. cdf = EmpiricalCDF()\n push!(cdf,x)\n ...\n print(io,cdf)\n\n# reject points `x < xmin` to use less memory\n cdf = EmpiricalCDF(xmin)"
},

{
    "location": "index.html#Warning-about-sorting-1",
    "page": "EmpiricalCDFs",
    "title": "Warning about sorting",
    "category": "section",
    "text": "Before using the cdf, you must call sort!(cdf). For efficiency data is not sorted as it is inserted. The exception is print, which does sort the cdf before printing."
},

{
    "location": "index.html#Contents-1",
    "page": "EmpiricalCDFs",
    "title": "Contents",
    "category": "section",
    "text": ""
},

{
    "location": "index.html#Index-1",
    "page": "EmpiricalCDFs",
    "title": "Index",
    "category": "section",
    "text": ""
},

{
    "location": "index.html#EmpiricalCDFs.AbstractEmpiricalCDF",
    "page": "EmpiricalCDFs",
    "title": "EmpiricalCDFs.AbstractEmpiricalCDF",
    "category": "type",
    "text": "AbstractEmpiricalCDF\n\nConcrete types are EmpiricalCDF and EmpiricalCDFHi.\n\n\n\n"
},

{
    "location": "index.html#EmpiricalCDFs.EmpiricalCDF",
    "page": "EmpiricalCDFs",
    "title": "EmpiricalCDFs.EmpiricalCDF",
    "category": "type",
    "text": "EmpiricalCDF()\n\nReturn an empirical CDF. After inserting elements with push! or append!, and before being accessed using any of the functions below, the CDF must be sorted with sort!.\n\nEmpiricalCDF is a callable object:\n\n(cdf::EmpiricalCDF)(x::Real)\n\nreturns the value of the approximate cummulative distribution function cdf at the point x.\n\n\n\nEmpiricalCDF(lowreject::Real)\n\nIf lowereject is finite return EmpiricalCDFHi(lowreject). Otherwise return EmpiricalCDF().\n\n\n\n"
},

{
    "location": "index.html#EmpiricalCDFs.EmpiricalCDFHi",
    "page": "EmpiricalCDFs",
    "title": "EmpiricalCDFs.EmpiricalCDFHi",
    "category": "type",
    "text": "EmpiricalCDFHi{T <: Real} <: AbstractEmpiricalCDF\n\nEmpirical CDF with lower cutoff. That is, keep only the tail.\n\n\n\n"
},

{
    "location": "index.html#Empirical-CDF-types-1",
    "page": "EmpiricalCDFs",
    "title": "Empirical CDF types",
    "category": "section",
    "text": "AbstractEmpiricalCDF\nEmpiricalCDF\nEmpiricalCDFHi"
},

{
    "location": "index.html#Base.push!",
    "page": "EmpiricalCDFs",
    "title": "Base.push!",
    "category": "function",
    "text": "push!(cdf::EmpiricalCDF,x::Real)\n\nadd the sample x to cdf.\n\n\n\n"
},

{
    "location": "index.html#Base.append!",
    "page": "EmpiricalCDFs",
    "title": "Base.append!",
    "category": "function",
    "text": "append!(cdf::EmpiricalCDF, a::AbstractArray)\n\nadd samples in a to cdf.\n\n\n\n"
},

{
    "location": "index.html#Base.sort!",
    "page": "EmpiricalCDFs",
    "title": "Base.sort!",
    "category": "function",
    "text": "sort!(cdf::AbstractEmpiricalCDF)\n\nSort the data collected in cdf. You must call sort! before using cdf.\n\n\n\n"
},

{
    "location": "index.html#EmpiricalCDFs.data",
    "page": "EmpiricalCDFs",
    "title": "EmpiricalCDFs.data",
    "category": "function",
    "text": "data(cdf::AbstractEmpiricalCDF)\n\nreturn the array holding samples for cdf.\n\n\n\n"
},

{
    "location": "index.html#EmpiricalCDFs.counts",
    "page": "EmpiricalCDFs",
    "title": "EmpiricalCDFs.counts",
    "category": "function",
    "text": "counts(cdf::AbstractEmpiricalCDF)\n\nreturn the number of counts added to cdf. This includes counts that may have been discarded because they are below of the cutoff.\n\n\n\n"
},

{
    "location": "index.html#Base.Random.rand",
    "page": "EmpiricalCDFs",
    "title": "Base.Random.rand",
    "category": "function",
    "text": "rand(cdf::EmpiricalCDF)\n\nPick a random sample from the distribution represented by cdf.\n\n\n\n"
},

{
    "location": "index.html#EmpiricalCDFs.finv",
    "page": "EmpiricalCDFs",
    "title": "EmpiricalCDFs.finv",
    "category": "function",
    "text": "finv(cdf::AbstractEmpiricalCDF) --> Function\n\nReturn the functional inverse of cdf. cdf is a callable object. finv(cdf) returns a function that captures cdf in a closure.\n\n\n\n"
},

{
    "location": "index.html#Functions-1",
    "page": "EmpiricalCDFs",
    "title": "Functions",
    "category": "section",
    "text": "push!\nappend!\nsort!\ndata\ncounts\nrand\nfinvMethods are defined on AbstractEmpiricalCDF for the following functions: length, minimum, maximum, extrema, mean, median, std, quantile."
},

{
    "location": "index.html#Base.print",
    "page": "EmpiricalCDFs",
    "title": "Base.print",
    "category": "function",
    "text": "print(io::IO, cdf::AbstractEmpiricalCDF)\n\nCall logprint(io,cdf)\n\n\n\n"
},

{
    "location": "index.html#EmpiricalCDFs.linprint",
    "page": "EmpiricalCDFs",
    "title": "EmpiricalCDFs.linprint",
    "category": "function",
    "text": "linprint(io::IO ,cdf::AbstractEmpiricalCDF, n=2000) print (not more than) n linearly spaced points after sorting the data.\n\n\n\nlinprint(fn::String, cdf::AbstractEmpiricalCDF, n=2000)\n\nprint cdf to file fn. Print no more than n linearly spaced points.\n\n\n\n"
},

{
    "location": "index.html#EmpiricalCDFs.logprint",
    "page": "EmpiricalCDFs",
    "title": "EmpiricalCDFs.logprint",
    "category": "function",
    "text": "logprint(io::IO, cdf::EmpiricalCDF, n=2000) print (not more than) n log spaced points after sorting the data.\n\n\n\n"
},

{
    "location": "index.html#Text-file-output-1",
    "page": "EmpiricalCDFs",
    "title": "Text file output",
    "category": "section",
    "text": "print\nlinprint\nlogprint"
},

{
    "location": "index.html#EmpiricalCDFs.CDFfile",
    "page": "EmpiricalCDFs",
    "title": "EmpiricalCDFs.CDFfile",
    "category": "type",
    "text": "CDFfile(cdf::AbstractEmpiricalCDF, header=\"\")\n\nstruct CDFfile{T <: AbstractEmpiricalCDF}\n    cdf::T\n    header::String\nend\n\nBinary data file for AbstractEmpiricalCDF\n\nThe file format is\n\nIdentifying string\nn::Int64 number of bytes in the header string\ns::String The header string\nt::Int64 Type of AbstractEmpiricalCDF, 1 or 2. 1 for EmpiricalCDF, 2 for EmpiricalCDFHi.\nlowreject::Float64 the lower cutoff, only for EmpiricalCDFHi.\nnpts::Int64 number of data points in the CDF\nnpts data points of type Float64\n\n\n\n"
},

{
    "location": "index.html#EmpiricalCDFs.save",
    "page": "EmpiricalCDFs",
    "title": "EmpiricalCDFs.save",
    "category": "function",
    "text": "save(fn::String, cdf::AbstractEmpiricalCDF, header::String=\"\")\n\nwrite cdf to file fn in a fast binary format.\n\n\n\n"
},

{
    "location": "index.html#EmpiricalCDFs.readcdf",
    "page": "EmpiricalCDFs",
    "title": "EmpiricalCDFs.readcdf",
    "category": "function",
    "text": "readcdf(fn::String)\n\nRead an empirical CDF from file fn. Return an object cdff of type CDFfile. The header is in field header. The cdf is in in field cdf.\n\n\n\n"
},

{
    "location": "index.html#EmpiricalCDFs.readcdfinfo",
    "page": "EmpiricalCDFs",
    "title": "EmpiricalCDFs.readcdfinfo",
    "category": "function",
    "text": "readcdfinfo(fn::String)\n\nreturn an object containing information about the cdf saved in the binary file fn. The data itself is not read.\n\n\n\n"
},

{
    "location": "index.html#EmpiricalCDFs.header",
    "page": "EmpiricalCDFs",
    "title": "EmpiricalCDFs.header",
    "category": "function",
    "text": "header::String = header(cdff::CDFfile)\n\nReturn the header from cdff.\n\n\n\n"
},

{
    "location": "index.html#EmpiricalCDFs.getcdf",
    "page": "EmpiricalCDFs",
    "title": "EmpiricalCDFs.getcdf",
    "category": "function",
    "text": "cdf::AbstractEmpiricalCDF = getcdf(cdff::CDFfile)\n\nReturn the CDF from cdff.\n\n\n\n"
},

{
    "location": "index.html#EmpiricalCDFs.version",
    "page": "EmpiricalCDFs",
    "title": "EmpiricalCDFs.version",
    "category": "function",
    "text": "version(cdff::CDFfile)\n\nReturn the version number of the file format.\n\n\n\n"
},

{
    "location": "index.html#Binary-IO-1",
    "page": "EmpiricalCDFs",
    "title": "Binary IO",
    "category": "section",
    "text": "I found available serialization choices to be too slow. So, very simple, very fast, binary storage and retrieval is provided. By now, or in the future, there will certainly be packages that provide a sufficient or better replacement.The type CDFfile supports reading and writing AbstractEmpiricalCDF objects in binary format. Most functions that operate on AbstractEmpiricalCDF also work with CDFfile, with the call being passed to the cdf field.CDFfile\nsave\nreadcdf\nreadcdfinfo\nheader\ngetcdf\nversion"
},

{
    "location": "index.html#Comparison-with-ecdf-1",
    "page": "EmpiricalCDFs",
    "title": "Comparison with ecdf",
    "category": "section",
    "text": "This package differs from the  ecdf function from StatsBase.jl.ecdf takes a sorted vector as input and returns a function that looks up the value of the  CDF. An instance of EmpiricalCDF, cdf, both stores data, eg via push!(cdf,x), and looksup the value of the CDF via cdf(x).When computing the CDF at an array of values, ecdf, sorts the input and uses an algorithm that scans the data. Instead, EmpiricalCDFs does a binary search for each element of an input vector. Tests showed that this is typically not slower. If the CDF stores a large number of points relative to the size of the input vector, the second method, the one used by EmpiricalCDFs is faster."
},

]}
