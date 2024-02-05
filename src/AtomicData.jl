module AtomicData

export AtomicStage
export get_solar_abundances
export get_atomic_stage, read_NIST
export partition_function, partition_function_interpolator

using DelimitedFiles
using Interpolations
using PeriodicTable
using Unitful
using YAML
import PhysicalConstants.CODATA2018: h, k_B, c_0, R_∞, m_e, m_u

@derived_dimension PerLength Unitful.𝐋^-1

const element_symbols = [el.symbol for el in elements]

include("types.jl")
include("read_utils.jl")
include("partition_function.jl")
include("abundances.jl")
include("barklem.jl")

end
