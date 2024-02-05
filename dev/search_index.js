var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = AtomicData","category":"page"},{"location":"#AtomicData","page":"Home","title":"AtomicData","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [AtomicData]","category":"page"},{"location":"#AtomicData.ABO_factors_sp-NTuple{4, Any}","page":"Home","title":"AtomicData.ABO_factors_sp","text":"Compute Barklem σ and α for an sp transition.\n\nArguments\n\nE_cont: continuum energy (upper continuum of the stage)\nElevs: s level energy\nElevp: p level energy\nZ: atomic charge + 1\n\n\n\n\n\n","category":"method"},{"location":"#AtomicData.NIST_wavenumber_to_energy-Tuple{Any}","page":"Home","title":"AtomicData.NIST_wavenumber_to_energy","text":"Parses level energy field from NIST tables. Brackets (round or square) indicate interpolated or theoretical values. Converts from wavenumber to energy.\n\n\n\n\n\n","category":"method"},{"location":"#AtomicData.get_atom_dir-Tuple{}","page":"Home","title":"AtomicData.get_atom_dir","text":"Returns directory with model atom files.\n\n\n\n\n\n","category":"method"},{"location":"#AtomicData.get_atomic_stage-Tuple{String, Any}","page":"Home","title":"AtomicData.get_atomic_stage","text":"get_atomic_stage(element::String, stage; source=\"NIST\")\n\nReturns the level structure for a given atomic stage for element and ionisation stage stage. Uses data from the given source, returns an AtomicStage struct. Currently, the only supported source is \"NIST\", using locally-saved data obtained from the NIST Atomic Spectra Database Levels Form.\n\nExamples\n\njulia> MgII = get_atomic_stage(\"Mg\", \"II\")\nAtomicStage(\"Mg\", \"Mg_II\", 2, II, 137, (...))\n\njulia> MgII = get_atomic_stage(\"Mg\", 2)\nAtomicStage(\"Mg\", \"Mg_II\", 2, II, 137, (...))\n\n\n\n\n\n","category":"method"},{"location":"#AtomicData.get_solar_abundances-Tuple{}","page":"Home","title":"AtomicData.get_solar_abundances","text":"function get_solar_abundances(;source=\"AAG2021\")\n\nGets a dictionary with element names and their solar photospheric abundances. Can read from multiple sources. Currently supported are:\n\n\"AAG2021\"`, from Asplund, Amarsi, & Grevesse 2021, A&A, 653, A141\n\"AAGS2009\", from Asplund, Grevesse, Sauval, & Scott 2009, ARA&A, 47, 481\n\"GS1998\", from Grevesse & Sauval 1998, Space Science Reviews, 85, 161-174\n\n\n\n\n\n","category":"method"},{"location":"#AtomicData.n_eff-Tuple{Union{Unitful.Quantity{T, 𝐋^2 𝐌 𝐓^-2, U}, Unitful.Level{L, S, Unitful.Quantity{T, 𝐋^2 𝐌 𝐓^-2, U}} where {L, S}} where {T, U}, Union{Unitful.Quantity{T, 𝐋^2 𝐌 𝐓^-2, U}, Unitful.Level{L, S, Unitful.Quantity{T, 𝐋^2 𝐌 𝐓^-2, U}} where {L, S}} where {T, U}, Integer}","page":"Home","title":"AtomicData.n_eff","text":"n_eff(energy_upper::Unitful.Energy, energy_lower::Unitful.Energy, Z::Integer)\n\nCompute the effective principal quantum number for a given energy difference and atomic charge, Z= atomic charge + 1 (ie, 1 for neutral, 2 for singly ionised). energy_upper is the ionisation energy for the given stage.\n\n\n\n\n\n","category":"method"},{"location":"#AtomicData.partition_function-Tuple{Array{<:Real}, Vector{<:Union{Unitful.Quantity{T, 𝐋^2 𝐌 𝐓^-2, U}, Unitful.Level{L, S, Unitful.Quantity{T, 𝐋^2 𝐌 𝐓^-2, U}} where {L, S}} where {T, U}}, Union{Unitful.Quantity{T, 𝚯, U}, Unitful.Level{L, S, Unitful.Quantity{T, 𝚯, U}} where {L, S}} where {T, U}}","page":"Home","title":"AtomicData.partition_function","text":"partition_function(\n    g::Array{<: Real}, χ::Array{<: Unitful.Energy, 1}, temp::Unitful.Temperature\n)\npartition_function(data::AtomicStage, temp::Unitful.Temperature)\n\nCalculate partition function from a set of levels defined by arrays of statistical weights and energies (or an AtomicStage struct), for a given temperature.\n\n\n\n\n\n","category":"method"},{"location":"#AtomicData.partition_function_interpolator-Tuple{AtomicStage, Array{<:Union{Unitful.Quantity{T, 𝚯, U}, Unitful.Level{L, S, Unitful.Quantity{T, 𝚯, U}} where {L, S}} where {T, U}}}","page":"Home","title":"AtomicData.partition_function_interpolator","text":"partition_function_interpolator(\n    atom::AtomicStage, temperatures::Array{<: Unitful.Temperature},\n)\npartition_function_interpolator(\n    element::String, stage, temperatures::Array{<: Unitful.Temperature};\n    source=\"NIST\"\n)\n\nReturns an interpolator for the partition function of a given atomic stage.\n\nArguments\n\natom: an AtomicStage structure with the data for the given stage\ntemperatures: array with temperatures used to build the interpolation table\n\nReturns\n\ninterpolator: linear interpolator object that takes temperature to give partition function\n\n\n\n\n\n","category":"method"},{"location":"#AtomicData.read_NIST-Tuple{String, Any}","page":"Home","title":"AtomicData.read_NIST","text":"Reads NIST atomic level data saved locally. The data were extracted from the NIST Atomic Spectra Database Levels Form.\n\n\n\n\n\n","category":"method"},{"location":"#AtomicData.read_abundances-Tuple{Any}","page":"Home","title":"AtomicData.read_abundances","text":"Reads abundance file and converts to a dictionary with symbols for element names. Also converts abundances to linear scale, from usual log scale (relative to hydrogen). Source file must be YAML formatted, following the format of files under data/solar_abundances/*yaml\n\n\n\n\n\n","category":"method"},{"location":"#AtomicData.wavenumber_to_energy-Union{Tuple{Unitful.Quantity{T}}, Tuple{T}} where T<:AbstractFloat","page":"Home","title":"AtomicData.wavenumber_to_energy","text":"If input is in wavenumber, convert to energy. Otherwise keep as energy.\n\n\n\n\n\n","category":"method"}]
}
