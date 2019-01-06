using Documenter, EmpiricalCDFs

makedocs(
    debug = true,
    strict = false,
    doctest = false,
    format = :html,
    sitename = "EmpiricalCDFs.jl",
    modules = [EmpiricalCDFs],
    pages = [
        "index.md"
    ]
)

deploydocs(
    repo = "github.com/jlapeyre/EmpiricalCDFs.jl.git",
    target = "build",
    julia  = "1.0",
    deps = nothing,
    make = nothing
)
