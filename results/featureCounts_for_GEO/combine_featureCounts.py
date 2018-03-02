#!/usr/bin/env python3

# This is for parsing a set of featureCount produced files (faster
# to produce them 1 per experiment in parallel) and combines the columns
import csv,sys,re,os

#  turn an array with nested arrays into a single flattened list
def flatten(l, ltypes=(list, tuple)):
    ltype = type(l)
    l = list(l)
    i = 0
    while i < len(l):
        while isinstance(l[i], ltypes):
            if not l[i]:
                l.pop(i)
                i -= 1
                break
            else:
                l[i:i + 1] = l[i]
        i += 1
    return ltype(l)

# updates dictionary where the key are gene name and points to 
# a second dictionary which has 2 keys 'header' and 'counts'
# counts is a dictionary where the key the experiment name and value
# is the read count computed
def add_featcount (filename,fname,df):
    
    with open(filename,"r") as fh:
        header1 = fh.readline()
        header2 = fh.readline().split("\t")
        header2[-1] = fname
        tabreader = csv.reader(fh, delimiter="\t")
        for row in tabreader:
            if not (row[0] in df):
                df[row[0]] = { 'counts': {},
                               'header': [] }
                for col in range(1,6):
                    df[row[0]]['header'].append(row[col])
            # store the read/frag count for this experiment (fname)
            df[row[0]]['counts'][fname] = row[6]

indir="."
outfile_gsnapRead="DHED1.read_counts.tab"
fragtable = {}
readtable = {}
fragnames = []
readnames = []
header = ""

for fileF in os.listdir(indir):
    fname = fileF
    pm = re.compile(r'(\S+\.rep\d+)\.')    
    m = pm.match(fileF)
    if m :
        fname = m.group(1)
    fullpath = os.path.join(indir,fileF)
    if fileF.endswith(".gsnap_reads.tab"):
        print(fileF)
        if not header:
            with open(fullpath,"r") as hdrparse:
                hdrparse.readline()
                header = hdrparse.readline().split("\t")
                header = header[0:6]
        add_featcount(fullpath,fname,readtable)
        readnames.append(fname)
    elif fileF.endswith(".gsnap_frags.tab"):
        add_featcount(fullpath,fname,fragtable)
        fragnames.append(fname)

fragnames.sort()
readnames.sort()

print(fragnames)
print(readnames)
print(len(fragnames), " fragnames files")
print(len(readnames), " readnames files")

# # write out the combined fragment count table 
# with open(outfile_gsnapFrag, 'w', newline="\n") as fragfile:
#     fragwriter = csv.writer(fragfile, delimiter="\t",
#                             quotechar='|', quoting=csv.QUOTE_MINIMAL)
#     fragheader  = header.copy()
#     fragheader.append(fragnames)
#     fragwriter.writerow(flatten(fragheader))
#     for gene in fragtable:
#         row = flatten([gene,fragtable[gene]['header']])
#         for k in fragnames:
#             if k in fragtable[gene]['counts']:
#                 #print(k,gene,fragtable[gene]['counts'])
#                 row.append(fragtable[gene]['counts'][k])
#             else:
#                 print("No ",gene, "in",k," frags")
#                 row.append(0)

#         fragwriter.writerow(row)

# write out the combined read count table
with open(outfile_gsnapRead, 'w', newline="\n") as readfile:
    readwriter = csv.writer(readfile, delimiter="\t",
                            quotechar='|', quoting=csv.QUOTE_MINIMAL)
    readheader  = header.copy()
    readheader.append(readnames)
    readwriter.writerow(flatten(readheader))
    for gene in readtable:
        row = flatten([gene,readtable[gene]['header']])
        for k in readnames:
            if k in readtable[gene]['counts']:
                row.append(readtable[gene]['counts'][k])
            else:
                print("No ",gene, "in",k," reads")
                row.append(0)

        readwriter.writerow(row)
