
# Demonstrate computing capabilities of crys-py.
# (eventually)

import urllib.request
import sys

print ("Download CRYSTALS website front page\n")

response = urllib.request.urlopen('http://www.xtl.ox.ac.uk/')
data = response.read()
i = 0
while ( len(data) > 72 ):
    print (data[0:71])
    data = data[71:]

print(data)
print ("Done.")

print(sys.version)
