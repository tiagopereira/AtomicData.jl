include("roman_numerals.jl")

struct AtomicStage
    element::String
    name::String
    stage::Int
    stage_rn::RomanNumeral
    n_levels::Int
    g::Vector{Int}
    χ::typeof([1.0, 2.0]u"J")
    χ_ion::Unitful.Energy
    function AtomicStage(element, stage, g, χ, χ_ion)
        n_levels = length(χ)
        stage_rn = RomanNumeral(stage)
        stage = convert(Int, stage_rn)  # Ensures it can be called with string or Int
        name = string(element, "_", repr(stage_rn))
        new(element, name, stage, stage_rn, n_levels, g, χ, χ_ion)
    end
end
