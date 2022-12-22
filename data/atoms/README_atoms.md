## Model atoms

This directory contains model atoms in YAML format to be used in radiative transfer calculations. The atom format is still subject to change, and is based on quantities necessary from existing codes such as MULTI or RH.

Each model atom is divided into 6 main parts:

* element: data about element, optionally also including abundance.
* atomic_levels: properties of each atomic level. 
* radiative_bound_bound: properties of spectral lines.
* radiative_bound_free: properties of bound-free radiative transitions.
* collisional: properties of collisional transitions, both excitation and ionisation.

