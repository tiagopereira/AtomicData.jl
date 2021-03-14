"""
Functions to read atomic data.
"""

"""
    get_atomic_stage(element::String, stage; source="NIST")

Returns the level structure for a given atomic stage for `element`
and ionisation stage `stage`. Uses data from the given `source`,
returns an `AtomicStage` struct. Currently, the only supported source
is `"NIST"`, using locally-saved data obtained from the
[NIST Atomic Spectra Database Levels Form](https://physics.nist.gov/PhysRefData/ASD/levels_form.html).

# Examples
```julia-repl
julia> MgII = get_atomic_stage("Mg", "II")
AtomicStage("Mg", "Mg_II", 2, II, 137, (...))

julia> MgII = get_atomic_stage("Mg", 2)
AtomicStage("Mg", "Mg_II", 2, II, 137, (...))
```
"""
function get_atomic_stage(element::String, stage; source="NIST")
    if element ∉ element_symbols
        error("Invalid element $element")
    end
    if source == "NIST"
        return read_NIST(element, stage)
    else
        error("NotImplemented: atomic data source $source not available.")
    end
end


"""
Reads NIST atomic level data saved locally. The data were extracted from the
[NIST Atomic Spectra Database Levels Form](https://physics.nist.gov/PhysRefData/ASD/levels_form.html).
"""
function read_NIST(element::String, stage)
    stage = RomanNumeral(stage)
    file = string(element, "_", repr(stage), ".txt")
    filepath = joinpath(@__DIR__, "..", "data", "NIST", file)
    if isfile(filepath)
        data = readdlm(filepath)
        # Index entries that have statistical weights
        index = typeof.(data[:, 4]) .== Int
        index .*= data[:, 3] .!= "---"  # some cases with mismatched wnum as Int
        index .*= data[:, 3] .!= ""     # cases with no J or g
        g = convert.(Int, data[index, 4])
        χ = NIST_wavenumber_to_energy.(data[index, 5])
        # Find first ionisation edge
        if sum(data[:, 2] .== "Limit") == 0
            χ_ion = 0.0u"J"
        else
            wavenum_ion = data[data[:, 2] .== "Limit", 4][1]
            χ_ion = NIST_wavenumber_to_energy(wavenum_ion)
        end
        return AtomicStage(element, stage, g, χ, χ_ion)
    else
        error("NIST data for $element $(repr(stage)) not found.")
    end
end


"""
Parses level energy field from NIST tables. Brackets (round or square)
indicate interpolated or theoretical values. Converts from wavenumber
to energy.
"""
function NIST_wavenumber_to_energy(wavenum)
    to_remove = ["[", "]", "(", ")", "?", "a", "l", "x", "y", "z",
                 "u", "+", "&dagger;", "&dgger;"]
    if typeof(wavenum) in [String, SubString{String}]
        for suffix in to_remove
            wavenum = replace(wavenum, suffix => "")
        end
        wn = parse(Float64, wavenum)u"cm^-1"
    elseif typeof(wavenum) <: Real
        wn = convert(Float64, wavenum)u"cm^-1"
    else
        error("Invalid type $(typeof(wavenum)) for wave number")
    end
    return (h * c_0 * wn) |> u"J"
end
