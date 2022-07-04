"""
Tools to read and handle astrophysical element abundances.
"""


"""
    function get_solar_abundances(;source="AAG2021")

Gets a dictionary with element names and their solar photospheric abundances.
Can read from multiple sources. Currently supported are:

* `"AAG2021"``, from Asplund, Amarsi, & Grevesse 2021, A&A, 653, A141
* `"AAGS2009"`, from Asplund, Grevesse, Sauval, & Scott 2009, ARA&A, 47, 481
* `"GS1998"`, from Grevesse & Sauval 1998, Space Science Reviews, 85, 161-174
"""
function get_solar_abundances(;source="AAG2021")
    if source in ["AAG2021", "Asplund_et_al2021", "Asplund2021"]
        file = "Asplund_et_al2021.yaml"
    elseif source in ["AGSS2009", "Asplund_et_al2009", "Asplund2009"]
        file = "Asplund_et_al2009.yaml"
    elseif source in ["GS1998", "Grevesse_Sauval1998"]
        file = "Grevesse_Sauval1998.yaml"
    else
        error("Unknown source $source")
    end
    filepath = joinpath(@__DIR__, "..", "data", "solar_abundances", file)
    read_abundances(filepath)
end
