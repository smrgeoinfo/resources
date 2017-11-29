#!/usr/bin/python2.6

"""
Author: Neville Shane
Institution: LDEO, Columbia University
Email: nshane@ldeo.columbia.edu
Creation date: March 29 2017
Usage: grl_dump2meta.py -d <dump_file> -o <output_dir>
This program reads a csv file with two columns:
submission_id -- contains a unique record identifier integer (e.g.
    a submission number from EarthChem Library)
dataCiteXML-a text blob that is valid xml (without the xml version header)
    for DataCitev.4 encoded metadata describing a resource.
Each xml file is saved with the identifiers for the resource in the file name.

To run, type:
> ./grl_dump2meta.py -d <dump_file> -o <output_dir>
This will create the output directory specified by the -o argument and
write the dataCite metadata files to that location. 

updates:
2017-03-30 SMR added more header information; put the main loop process in
    a try/except block
"""

import sys
import os
import csv
import getopt
import xml.etree.ElementTree as ET

XML_HEADER = '<?xml version="1.0" encoding="UTF-8"?>'
ns = "{http://datacite.org/schema/kernel-4}"
# set the dump_file and output_dir, to run code inside ide
dump_file = 'USAPDataCiteDump20171115.txt'
output_dir = 'output'

# use this to set the dump_file and output_dir from the input arguments
##try:
##    opts, args = getopt.getopt(sys.argv[1:], "hd:o:", ["dump_file=", "output_dir="])
##    if len(opts) == 0:
##        print("grl_dump2meta.py -d <dump_file> -o <output_dir>")
##        sys.exit(0)
##except getopt.GetoptError:
##    print("grl_dump2meta.py -d <dump_file> -o <output_dir>")
##    sys.exit(0)
##
##    
##for opt, arg in opts:
##    if opt == '-h':
##        print("grl_dump2meta.py -d <dump_file> -o <output_dir>")
##        sys.exit(0)
##    elif opt in ('-d', '--dump_file'):
##        dump_file = arg
##    elif opt in ('-o', '--output_dir'):
##        output_dir = arg
        
if dump_file is None or output_dir is None:
        print("grl_dump2meta.py -d <dump_file> -o <output_dir>")
        sys.exit(0)

# create output_dir if it doesn't already exist
if not os.path.exists(output_dir):
    os.makedirs(output_dir)

# read in dump_file
if not os.path.exists:
    print("ERROR: dump file %s not found" % dump_file)
    sys.exit(0)

# store submission in a dictionary, where the submission_id is the key
submissions = {}
try:
    with open(dump_file, 'rt') as f:
        reader = csv.reader(f, delimiter='|')
        header = True
        for row in reader:
            # skip header line (first line)
            if header:
                header = False
                continue
            # next submission object of the row contains 2 objects
            if len(row) == 3:
                # split submission_id and dataCiteXML
                sub_id = row[0]
                xml = row[2]
            # if just one object - it's more xml
            elif len(row) == 1:
                # build up the xml by appending lines to it
                xml += "\n" + row[0]
                submissions[sub_id] = xml
except:
    print("ERROR: Can't read dump_file: " + dump_file + "; row " + sub_id)
    print(sys.exc_info()[1])
    sys.exit(0)

# for each submission

for sub_id, xml in submissions.items():
    try:
        # generate metadata file name
        # first parse in the xml
        if len(sub_id)== 0:
            print("No sub_id provided, skip")
            continue
        else:
            print('{:04d}'.format(int(sub_id)))
            
##        root = ET.fromstring(xml)
##        identifier = root.find(ns+'identifier')
##        if identifier is not None:
##            # use the DOI in the filename is available
##            if identifier.get('identifierType') == "DOI":
##                doi = identifier.text.split('/')
##                meta_name = doi[2] + "-submission-id" + '{:04d}'.format(int(sub_id)) + ".xml"
##            else:
##                meta_name = "submission-id" + '{:04d}'.format(int(sub_id)) + ".xml"
##        else:
##            print("identifier missing: " + '{:04d}'.format(int(sub_id)))
##            continue
        meta_name = "submission-id" + '{:04d}'.format(int(sub_id)) + ".xml"
        meta_file = os.path.join(output_dir, meta_name)

        # save dataCiteXML into metadata file
        outfile = open(meta_file, 'w')
        # add XML header
        outfile.write(XML_HEADER)
        outfile.write("\n")
        outfile.write(xml)
        outfile.close()
##        print("INFO: metadata file written: %s" % meta_file)
    except:
        print("EXCEPTION: error on submission: sub_ID=" + '{:04d}'.format(int(sub_id)))
        if outfile:
            outfile.close()

print("DONE")
