# NOTE that you must edit in the year and month.
# A folder year-month is created.  
# This script is crawling acta E and downloading pdf, cif and hkl files
from __future__ import division, print_function, absolute_import

import os.path
import sys
import urllib
import re

from bs4 import BeautifulSoup


#### Parameters to change: #####
year=2018
month=1
path=str(year)+'-'+str(month)
##### End ###########

try:
    os.stat(path)
except:
    os.mkdir(path)          

journalre=re.compile(r"/e/issues/[0-9]{4}/[0-9]{2}/[0-9]{2}/([a-zA-Z0-9]+)/index\.html")

journalissue = "https://journals.iucr.org/e/issues/%d/%02d/00/index.html"%(year, month)
g = urllib.urlopen(journalissue)
html = g.read()
soup = BeautifulSoup(html, 'lxml')

iucrcodelist=[]

for link in soup.find_all('a'):
    # https://journals.iucr.org/e/issues/2018/04/00/xu5920/index.html
    href=link.get('href')
    if(href):
        result = journalre.match(href)
        if(result):
            iucrcode=result.group(1)
            if(iucrcode not in iucrcodelist):
                iucrcodelist.append(iucrcode)
    
                try:
                    os.stat(path+'/'+iucrcode)
                except:
                    os.mkdir(path+'/'+iucrcode)          

                print("https://journals.iucr.org/%s"%href)
                g = urllib.urlopen("https://journals.iucr.org/%s"%href)
                html = g.read()
                articlesoup = BeautifulSoup(html, 'lxml')

                #<meta name="citation_pdf_url" content="http://journals.iucr.org/e/issues/2011/10/00/lx2196/lx2196.pdf" />
                pdffile=articlesoup.find("meta", {"name":"citation_pdf_url"})['content']
                urllib.urlretrieve (pdffile, path+'/'+iucrcode+'/'+os.path.basename(pdffile))

                href_tags = articlesoup.find_all('a')
                for atag in href_tags:
                    link = str(atag.get('href'))
                    if(link[-4:]==".cif"):
                        print(link)
                        urllib.urlretrieve (link, path+'/'+iucrcode+'/'+os.path.basename(link))
                    if(link[-4:]==".hkl"):
                        print(link)
                        urllib.urlretrieve (link, path+'/'+iucrcode+'/'+os.path.basename(link))





