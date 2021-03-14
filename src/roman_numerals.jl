# Adapted from https://github.com/anthonyclays/RomanNumerals.jl
# Copyright (c) 2014: Anthony Clays.
# Licensed under a MIT "Expat" License, see licenses/RomanNumerals.md

struct RomanNumeral <: Integer
    val::Int
    str::String
    RomanNumeral(int::Integer) = new(int, toroman(int))
    function RomanNumeral(str::AbstractString)
        num = parse(RomanNumeral, str)
        new(num, toroman(num))
    end
end


const RN = RomanNumeral

# Standard functions
# Conversion + promotion
Base.convert(::Type{Bool}, ::RN) = true
Base.convert(::Type{T}, x::RN) where {T<:Real} = T(x.val)

Base.promote_rule(::Type{RN}, ::Type{T}) where {T <: Integer} = T

# IO
Base.show(io::IO, num::RN) = write(io, num.str)
Base.length(num::RN) = length(num.str)
Base.hash(num::RN) = xor(hash(num.str), hash(num.val))


const VALID_ROMAN_PATTERN =
    r"""
    ^\s*                   # Skip leading whitespace
    (
    M*                     # Thousands
    (C{0,9}|CD|DC{0,4}|CM) # Hundreds
    (X{0,9}|XL|LX{0,4}|XC) # Tens
    (I{0,9}|IV|VI{0,4}|IX) # Ones
    )
    \s*$                   # Skip trailing whitespace
    """ix # Be case-insensitive and verbose

const NUMERAL_MAP = [
    (1000, "M")
    (900,  "CM")
    (500,  "D")
    (400,  "CD")
    (100,  "C")
    (90,   "XC")
    (50,   "L")
    (40,   "XL")
    (10,   "X")
    (9,    "IX")
    (5,    "V")
    (4,    "IV")
    (1,    "I")
]

import Base: parse
function parse(::Type{RomanNumeral}, str::AbstractString)
    m = match(VALID_ROMAN_PATTERN, str)
    m ≡ nothing && throw(Meta.ParseError(str * " is not a valid roman numeral"))
    # Strip whitespace and make uppercase
    str = uppercase(m.captures[1])
    i = 1
    val = 0
    strlen = length(str)
    for (num_val, numeral) in NUMERAL_MAP
        numlen = length(numeral)
        while i+numlen-1 <= strlen && str[i:i+numlen-1] == numeral
            val += num_val
            i += numlen
        end
    end
    val
end

using Logging: @warn
function toroman(val::Integer)
    val <= 0 && throw(DomainError(val, "in ancient Rome there were only strictly positive numbers"))
    val > 5000 && @warn "Roman numerals do not handle large numbers well"

    str = IOBuffer()
    for (num_val, numeral) in NUMERAL_MAP
        i = div(val, num_val)
        # Never concatenate an empty string to `str`
        i == 0 && continue
        print(str, repeat(numeral,i))
        val -= i*num_val
        # Stop when ready
        val == 0 && break
    end
    String(take!(str))
end
