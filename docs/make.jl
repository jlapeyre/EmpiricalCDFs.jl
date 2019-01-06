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
    deps = nothing,
    make = nothing
)
