using AtomicData
using Documenter

DocMeta.setdocmeta!(AtomicData, :DocTestSetup, :(using AtomicData); recursive=true)

makedocs(;
    modules=[AtomicData],
    authors="Tiago M. D. Pereira",
    repo="https://github.com/tiagomdp/AtomicData.jl/blob/{commit}{path}#{line}",
    sitename="AtomicData.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://tiagomdp.github.io/AtomicData.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/tiagomdp/AtomicData.jl",
)
