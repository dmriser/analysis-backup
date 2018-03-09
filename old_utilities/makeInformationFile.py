#!/usr/bin/python 

import glob

path = '/volatile/clas12/dmriser/analysis/e1f_analysis/fca/'

run_files = glob.glob(path + '3*')

for file in run_files:
    with open(file) as infile:
        print file.split('.fca')[0].split('fca/')[1], infile.read(), 9624000, 5.498

