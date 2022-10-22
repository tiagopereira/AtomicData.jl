"""
Tools to compute partition functions.
"""


"""
    partition_function(
        g::Array{<: Real}, χ::Array{<: Unitful.Energy, 1}, temp::Unitful.Temperature
    )
    partition_function(data::AtomicStage, temp::Unitful.Temperature)

Calculate partition function from a set of levels defined by arrays
of statistical weights and energies (or an AtomicStage struct),
for a given temperature.
"""
function partition_function(
    g::Array{<: Real}, χ::Array{<: Unitful.Energy, 1}, temp::Unitful.Temperature,
)
    return sum(g .* exp.(-χ ./ (k_B * temp)))
end

function partition_function(atom::AtomicStage, temp::Unitful.Temperature)
    return partition_function(atom.g, atom.χ, temp)
end


"""
    partition_function_interpolator(
        atom::AtomicStage, temperatures::Array{<: Unitful.Temperature},
    )
    partition_function_interpolator(
        element::String, stage, temperatures::Array{<: Unitful.Temperature};
        source="NIST"
    )

Returns an interpolator for the partition function of a given atomic stage.

# Arguments
- `atom`: an `AtomicStage` structure with the data for the given stage
- `temperatures`: array with temperatures used to build the interpolation table

# Returns
- `interpolator`: linear interpolator object that takes temperature to give
  partition function
"""
function partition_function_interpolator(
    atom::AtomicStage, temperatures::Array{<: Unitful.Temperature},
)
    pfunc = partition_function.(Ref(atom), temperatures)
    return linear_interpolation(temperatures, pfunc, extrapolation_bc=Line())
end

function partition_function_interpolator(
    element::String, stage, temperatures::Array{<: Unitful.Temperature};
    source="NIST"
)
    if source == "NIST"
        atom = read_NIST(element, stage)
    else
        error("NotImplemented: Atomic data source $source not supported")
    end
    return partition_function_interpolator(atom, temperatures)
end
