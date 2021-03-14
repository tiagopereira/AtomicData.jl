using AtomicData
using Test
using Unitful
import PhysicalConstants.CODATA2018: h, k_B, c_0


@testset "Read utils" begin
    MgII = get_atomic_stage("Mg", "II")
    Mg2 = get_atomic_stage("Mg", 2)
    Mg2rm = get_atomic_stage("Mg", AtomicData.RomanNumeral(2))
    @test MgII.g == Mg2.g == Mg2rm.g
    @test MgII.χ == Mg2.χ == Mg2rm.χ
    # Reading all neutral stages to check for parsing errors
    function read_all_neutral()
        elements = ["Ag", "Al", "Ar", "As", "Au", "B", "Ba", "Be", "Bi", "Br", "C", "Ca",
                    "Cd", "Ce", "Cl", "Co", "Cr", "Cs", "Cu", "Dy", "Er", "Eu", "F", "Fe",
                    "Ga", "Gd", "Ge", "H", "He", "Hf", "Hg", "Ho", "I", "In", "Ir", "K",
                    "Kr", "La", "Li", "Lu", "Mg", "Mn", "Mo", "N", "Na", "Nb", "Nd", "Ne",
                    "Ni", "O", "Os", "P", "Pb", "Pd", "Pr", "Pt", "Rb", "Re", "Rh", "Ru",
                    "S", "Sb", "Sc", "Se", "Si", "Sm", "Sn", "Sr", "Ta", "Tb", "Te", "Th",
                    "Ti", "Tl", "Tm", "U", "V", "W", "Xe", "Y", "Yb", "Zn", "Zr"]
        for e in elements
            get_atomic_stage(e, 1)
        end
        return true
    end
    @test read_all_neutral()
    @test_throws ArgumentError AtomicData.NIST_wavenumber_to_energy("NOT_NUMBER_1")
    @test_throws ErrorException AtomicData.NIST_wavenumber_to_energy([1, 2])
    @test_throws ErrorException read_NIST("H", 3)
    @test_throws ErrorException get_atomic_stage("Mm", 2)
    @test_throws ErrorException get_atomic_stage("Mg", "II"; source="MY_SOURCE")
end

@testset "Partition function" begin
    temp = 1u"K" / ustrip(k_B)
    @test partition_function([1, 1, 1], [1, 1, 1]u"J", temp) ≈ exp(-1) * 3
    @test partition_function([1, 1, 1], [1, 1, 1]u"J", 0u"K") ≈ 0
    @test partition_function([0, 0, 0], [1, 1, 1]u"J", temp) ≈ 0
    @test partition_function([1, 1, 1], [0, 0, 0]u"J", temp) ≈ 3
    SchI = AtomicStage("Sch", 1, [1, 1, 1], [0, 0, 0]u"J", 0u"J")
    @test partition_function(SchI, temp) ≈ 3
    AlI = get_atomic_stage("Al", "I")
    temp = [5000, 10000]u"K"
    itp = partition_function_interpolator(AlI, temp)
    @test itp == partition_function_interpolator("Al", "I", temp)
    @test itp(5000u"K") == partition_function(AlI, 5000u"K")
    @test itp(10000u"K") == partition_function(AlI, 10000u"K")
    @test_throws ErrorException partition_function_interpolator("Al", "I", temp;
                                                                source="MY_SOURCE")
end

@testset "Roman Numerals" begin
    @test convert(Bool, AtomicData.RomanNumeral(10)) == true
    @test convert(Float64, AtomicData.RomanNumeral("II")) == 2.0
    @test promote(AtomicData.RomanNumeral("V"), 1) == (5, 1)
    @test length(AtomicData.RomanNumeral("X")) == 1
    @test hash(AtomicData.RomanNumeral("L")) == xor(hash("L"), hash(50))
end
