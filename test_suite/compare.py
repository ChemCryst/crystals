#!/usr/bin/env python

# compare output between different builds
# first argument is pattern to look for
# second argument is an optional offset from the pattern (i.e. n line before after the pattern is found
#
# the script will look all the output files and print out where files differs at the specified line


import sys
import glob
import os
import re
import numpy

build_list=['LIN.org','GID.org','INW.org','INW_OMP.org','MIN64.org','OSXCLI.org']

def all_same(items):
    ref=None
    for item in items:
        if(item is not None and len(item.strip())>0):
            ref=item
            break

    for item in items:
        if(item is None):
            continue
        if(len(item.strip())==0):
            continue
        if(item.strip()!=ref.strip()):
            return False
            
    return True
    
if(len(sys.argv)<2):
    print "error in arguments, expected pattern to find"
    sys.exit() 
    
pattern=sys.argv[1]
if(len(sys.argv)>2):
    offset=int(sys.argv[2])
else:
    offset=0

print 'Search pattern: '+pattern
pattern_check = re.compile(pattern, re.I)

test_list=[]
for f in glob.glob('./LIN.org/*.out'):
    if(f[-6:]!='.d.out'):
        test_list.append(os.path.basename(f))

cpt=0
for test in test_list:
    cpt+=1
    print ""
    print "------------------------------------------------------------"
    print test
    open_files=[None] * len(build_list)
    i=0
    for build in build_list:
        if os.path.isfile('./'+build+'/'+test):
            f=open('./'+build+'/'+test)
            open_files[i]=f.readlines()
            f.close()
        else:
            open_files[i]=None
        i+=1

    found=[0] * len(build_list)
    foundtext=[None] * len(build_list)
    
    while True:
        for build in range(len(build_list)):
            if(open_files[build] is not None):
                if(found[build]<len(open_files[build])):
                    #print test_list[build], " ln ", len(open_files[build])
                    for ln in xrange(found[build], len(open_files[build])):
                        if(pattern_check.search(open_files[build][ln])):
                            found[build]=ln
                            foundtext[build]=open_files[build][ln+offset].strip()
                            break;
                            
                    if(ln==len(open_files[build])-1):
                        found[build]=ln
                        foundtext[build]=''
                else:
                    found[build]=0
                    foundtext[build]=None
            else:
                found[build]=0
                foundtext[build]=None
                        
            if(found[build]!=0):    
                found[build]+=1
                

        if(not all_same(foundtext)):
            print ""
            for build in range(len(build_list)):
                if(found[build]!=0 and found[build]!=len(open_files[build])-1):
                    print "%12s %05d%s%05d %s"%(build_list[build], found[build],"/",len(open_files[build]) , foundtext[build])

                
        if(numpy.sum(found)==0):
            break
            
    print "------------------------------------------------------------"
                            

