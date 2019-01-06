var documenterSearchIndex = {"docs": [

{
    "location": "#",
    "page": "EmpiricalCDFs",
    "title": "EmpiricalCDFs",
    "category": "page",
    "text": ""
},

{
    "location": "#EmpiricalCDFs-1",
    "page": "EmpiricalCDFs",
    "title": "EmpiricalCDFs",
    "category": "section",
    "text": "Empirical cumulative distribution functionsThe source repository is https://github.com/jlapeyre/EmpiricalCDFs.jl.Provides empirical cumulative distribution functions (CDFs) (or \"empirical distribution functions\" as they are know to probabalists).EmpiricalCDFs implements empirical CDFs; building, evaluating, random sampling, evaluating the inverse, etc.  It is useful especially for examining the tail of the CDF obtained from streaming a large number of data, more than can be stored in memory.  For this purpose, you specify a lower cutoff; data points below this value will be silently rejected, but the resulting CDF will still be properly normalized. This ability to process and filter data online is absent in StatsBase.ecdf. cdf = EmpiricalCDF()\n append!(cdf, randn(10^5))\n push!(cdf, randn())\n sort!(cdf)\n\n using Statistics\n mean(cdf)\n std(cdf)\n\n ...\n print(io,cdf)\n\n# reject points `x < xmin` to use less memory\n cdf = EmpiricalCDF(xmin)"
},

{
    "location": "#Warning-about-sorting-1",
    "page": "EmpiricalCDFs",
    "title": "Warning about sorting",
    "category": "section",
    "text": "Before using the cdf, you must call sort!(cdf). For efficiency data is not sorted as it is inserted. The exception is print, which does sort the cdf before printing."
},

{
    "location": "#Contents-1",
    "page": "EmpiricalCDFs",
    "title": "Contents",
    "category": "section",
    "text": ""
},

{
    "location": "#Index-1",
    "page": "EmpiricalCDFs",
    "title": "Index",
    "category": "section",
    "text": ""
},

{
    "location": "#EmpiricalCDFs.AbstractEmpiricalCDF",
    "page": "EmpiricalCDFs",
    "title": "EmpiricalCDFs.AbstractEmpiricalCDF",
    "category": "type",
    "text": "AbstractEmpiricalCDF\n\nConcrete types are EmpiricalCDF and EmpiricalCDFHi.\n\n\n\n\n\n"
},

{
    "location": "#EmpiricalCDFs.EmpiricalCDF",
    "page": "EmpiricalCDFs",
    "title": "EmpiricalCDFs.EmpiricalCDF",
    "category": "type",
    "text": "EmpiricalCDF{T=Float64}()\n\nConstruct an empirical CDF. After inserting elements with push! or append!, and before using most of the functions below, the CDF must be sorted with sort!.\n\nEmpiricalCDF and EmpiricalCDFHi are callable objects.\n\njulia> cdf = EmpiricalCDF();\njulia> append!(cdf,randn(10^6));\njulia> sort!(cdf);\njulia> cdf(0.0)\n0.499876\njulia> cdf(1.0)\n0.840944\njulia> cdf(-1.0)\n0.158494\n\nIn this example, we collected 10^6 samples from the unit normal distribution. About half of the samples are greater than zero. Approximately the same mass is between zero and one as is between zero and minus one.\n\n\n\n\n\nEmpiricalCDF(lowreject::Real)\n\nIf lowereject is finite return EmpiricalCDFHi(lowreject). Otherwise return EmpiricalCDF().\n\n\n\n\n\n"
},

{
    "location": "#EmpiricalCDFs.EmpiricalCDFHi",
    "page": "EmpiricalCDFs",
    "title": "EmpiricalCDFs.EmpiricalCDFHi",
    "category": "type",
    "text": "EmpiricalCDFHi{T <: Real} <: AbstractEmpiricalCDF\n\nEmpirical CDF with lower cutoff. That is, keep only the tail.\n\n\n\n\n\n"
},

{
    "location": "#Empirical-CDF-types-1",
    "page": "EmpiricalCDFs",
    "title": "Empirical CDF types",
    "category": "section",
    "text": "AbstractEmpiricalCDF\nEmpiricalCDF\nEmpiricalCDFHi"
},

{
    "location": "#Base.push!",
    "page": "EmpiricalCDFs",
    "title": "Base.push!",
    "category": "function",
    "text": "push!(cdf::EmpiricalCDF,x::Real)\n\nadd the sample x to cdf.\n\n\n\n\n\n"
},

{
    "location": "#Base.append!",
    "page": "EmpiricalCDFs",
    "title": "Base.append!",
    "category": "function",
    "text": "append!(cdf::EmpiricalCDF, a::AbstractArray)\n\nadd samples in a to cdf.\n\n\n\n\n\n"
},

{
    "location": "#Base.sort!",
    "page": "EmpiricalCDFs",
    "title": "Base.sort!",
    "category": "function",
    "text": "sort!(cdf::AbstractEmpiricalCDF)\n\nSort the data collected in cdf. You must call sort! before using cdf.\n\n\n\n\n\n"
},

{
    "location": "#EmpiricalCDFs.data",
    "page": "EmpiricalCDFs",
    "title": "EmpiricalCDFs.data",
    "category": "function",
    "text": "data(cdf::AbstractEmpiricalCDF)\n\nreturn the array holding samples for cdf.\n\n\n\n\n\n"
},

{
    "location": "#EmpiricalCDFs.counts",
    "page": "EmpiricalCDFs",
    "title": "EmpiricalCDFs.counts",
    "category": "function",
    "text": "counts(cdf::AbstractEmpiricalCDF)\n\nReturn the number of counts added to cdf. This includes counts that may have been discarded because they are below of the cutoff.\n\n\n\n\n\n"
},

{
    "location": "#Base.rand",
    "page": "EmpiricalCDFs",
    "title": "Base.rand",
    "category": "function",
    "text": "rand(cdf::EmpiricalCDF)\n\nPick a random sample from the distribution represented by cdf.\n\n\n\n\n\n"
},

{
    "location": "#EmpiricalCDFs.finv",
    "page": "EmpiricalCDFs",
    "title": "EmpiricalCDFs.finv",
    "category": "function",
    "text": "finv(cdf::AbstractEmpiricalCDF) --> Function\n\nReturn the quantile function, that is, the functional inverse of cdf. cdf is a callable object. Note that finv differs slightly from quantile.\n\nExamples\n\nHere, cdf contains 10^6 samples from the unit normal distribution.\n\njulia> icdf = finv(cdf);\njulia> icdf(.5)\n-0.00037235611091389375\njulia> icdf(1.0-eps())\n4.601393290425543\njulia> maximum(cdf)\n4.601393290425543\n\n\n\n\n\n"
},

{
    "location": "#Functions-1",
    "page": "EmpiricalCDFs",
    "title": "Functions",
    "category": "section",
    "text": "push!\nappend!\nsort!\ndata\ncounts\nrand\nfinvMethods are defined on AbstractEmpiricalCDF for the following functions: length, minimum, maximum, extrema, mean, median, std, quantile."
},

{
    "location": "#Base.print",
    "page": "EmpiricalCDFs",
    "title": "Base.print",
    "category": "function",
    "text": "print(io::IO, cdf::AbstractEmpiricalCDF)\n\nCall logprint(io,cdf)\n\n\n\n\n\n"
},

{
    "location": "#EmpiricalCDFs.linprint",
    "page": "EmpiricalCDFs",
    "title": "EmpiricalCDFs.linprint",
    "category": "function",
    "text": "linprint(io::IO ,cdf::AbstractEmpiricalCDF, n=2000) print (not more than) n linearly spaced points after sorting the data.\n\n\n\n\n\nlinprint(fn::String, cdf::AbstractEmpiricalCDF, n=2000)\n\nprint cdf to file fn. Print no more than n linearly spaced points.\n\n\n\n\n\n"
},

{
    "location": "#EmpiricalCDFs.logprint",
    "page": "EmpiricalCDFs",
    "title": "EmpiricalCDFs.logprint",
    "category": "function",
    "text": "logprint(io::IO, cdf::EmpiricalCDF, n=2000) print (not more than) n log spaced points after sorting the data.\n\n\n\n\n\n"
},

{
    "location": "#Text-file-output-1",
    "page": "EmpiricalCDFs",
    "title": "Text file output",
    "category": "section",
    "text": "print\nlinprint\nlogprint"
},

{
    "location": "#Binary-IO-1",
    "page": "EmpiricalCDFs",
    "title": "Binary IO",
    "category": "section",
    "text": "I found available serialization choices to be too slow. So, very simple, very fast, binary storage and retrieval is provided. By now, or in the future, there will certainly be packages that provide a sufficient or better replacement.The type CDFfile supports reading and writing AbstractEmpiricalCDF objects in binary format. Most functions that operate on AbstractEmpiricalCDF also work with CDFfile, with the call being passed to the cdf field.CDFfile\nsave\nreadcdf\nreadcdfinfo\nheader\ngetcdf\nversion"
},

{
    "location": "#Comparison-with-ecdf-1",
    "page": "EmpiricalCDFs",
    "title": "Comparison with ecdf",
    "category": "section",
    "text": "This package differs from the  ecdf function from StatsBase.jl.ecdf takes a sorted vector as input and returns a function that looks up the value of the CDF. An instance of EmpiricalCDF, cdf, both stores data, eg via push!(cdf,x), and looks up the value of the CDF via cdf(x).\nWhen computing the CDF at an array of values, ecdf, sorts the input and uses an algorithm that scans the data. Instead, EmpiricalCDFs does a binary search for each element of an input vector. Tests showed that this is typically not slower. If the CDF stores a large number of points relative to the size of the input vector, the second method, the one used by EmpiricalCDFs is faster."
},

]}
