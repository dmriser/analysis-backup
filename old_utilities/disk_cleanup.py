#!/usr/bin/python

import sys, os

def file_sizes(directory):
    for path, _, filenames in os.walk(directory):
        for name in filenames:
            full_path = os.path.join(path, name)
            yield full_path, os.path.getsize(full_path)

if __name__ == '__main__':

    d = { key : value for key, value in file_sizes('/u/home/dmriser/mydoc/analysis/utils/') }
    large_files = {key : value for key, value in d.iteritems() if int(value) > 1000}
    
    for path, size in large_files.iteritems():
        print('{%d}\t\t{:>%s}') % (size, path)
