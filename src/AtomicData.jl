module AtomicData

export AtomicStage
export get_atomic_stage, read_NIST
export partition_function, partition_function_interpolator

using DelimitedFiles
using Interpolations
using PeriodicTable
using Unitful
import PhysicalConstants.CODATA2018: h, k_B, c_0

const element_symbols = [el.symbol for el in elements]

include("types.jl")
include("read_utils.jl")
include("partition_function.jl")

end
