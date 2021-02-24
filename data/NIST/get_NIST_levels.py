#!/usr/bin/env python3
import os
import requests
from time import sleep
from roman import toRoman


def get_NIST_levels(max_z=26):
    """
    Downloads atomic levels and statistical weights from the NIST Atomic 
    Spectra Database Levels Form (https://physics.nist.gov/PhysRefData/ASD/levels_form.html)
    for most astrophysical-relevant elements, and saves them to text files,
    one file per stage, up to a maximum stage level given by max_z.
    """
    elements = {'Ag': 47, 'Al': 13, 'Ar': 18, 'As': 33, 'Au': 79, 'B':   5,
                'Ba': 56, 'Be':  4, 'Bi': 83, 'Br': 35, 'C':   6, 'Ca': 20,
                'Cd': 48, 'Ce': 58, 'Cl': 17, 'Co': 27, 'Cr': 24, 'Cs': 55,
                'Cu': 29, 'Dy': 66, 'Er': 68, 'Eu': 63, 'F':   9, 'Fe': 26,
                'Ga': 31, 'Gd': 64, 'Ge': 32, 'H':   1, 'He':  2, 'Hf': 72,
                'Hg': 80, 'Ho': 67, 'I':  53, 'In': 49, 'Ir': 77, 'K':  19,
                'Kr': 36, 'La': 57, 'Li':  3, 'Lu': 71, 'Mg': 12, 'Mn': 25,
                'Mo': 42, 'N':   7, 'Na': 11, 'Nb': 41, 'Nd': 60, 'Ne': 10,
                'Ni': 28, 'O':   8, 'Os': 76, 'P':  15, 'Pb': 82, 'Pd': 46,
                'Pr': 59, 'Pt': 78, 'Rb': 37, 'Re': 75, 'Rh': 45, 'Ru': 44,
                'S':  16, 'Sb': 51, 'Sc': 21, 'Se': 34, 'Si': 14, 'Sm': 62,
                'Sn': 50, 'Sr': 38, 'Ta': 73, 'Tb': 65, 'Te': 52, 'Th': 90,
                'Ti': 22, 'Tl': 81, 'Tm': 69, 'U':  92, 'V':  23, 'W':  74,
                'Xe': 54, 'Y':  39, 'Yb': 70, 'Zn': 30, 'Zr': 40 }

    query_string = "https://physics.nist.gov/cgi-bin/ASD/energy1.pl?de=0&spectrum=%s+%s&units=0&format=3&output=0&page_size=15&multiplet_ordered=1&conf_out=on&term_out=on&level_out=on&j_out=on&g_out=on&temp=&submit=Retrieve+Data"
    for elem, Z in elements.items():
        for i in range(1, min(Z + 1, max_z + 1)):
            sleep(0.1)
            stage = toRoman(i)
            file_out = '%s_%s.txt' % (elem, stage)
            if not os.path.isfile(file_out):
                print('Fetching %s %s' % (elem, stage))
                r = requests.get(query_string % (elem, stage))
                if r.status_code == 200:
                    fout = open(file_out, 'w')
                    fout.write(r.text)
                    fout.close()
    return

if __name__ == "__main__":
    get_NIST_levels()
