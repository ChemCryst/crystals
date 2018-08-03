# NOTE that you must edit in the year and month.
# A folder year-month is created.  
# This script is crawling acta E and downloading pdf, cif and hkl files
from __future__ import division, print_function, absolute_import

import os.path
import sys
import urllib2
import re

from bs4 import BeautifulSoup

import argparse


def dlfile(url, dest):
    # Open the url
    try:
        f = urllib2.urlopen(url)

        # Open our local file for writing
        with open(dest, "wb") as local_file:
            local_file.write(f.read())

    #handle errors
    except urllib2.HTTPError, e:
        print("HTTP Error:", e.code, url)
    except urllib2.URLError, e:
        print("URL Error:", e.reason, url)
        
parser = argparse.ArgumentParser(description='Crawl cif/fcf files from Acta E/B')
parser.add_argument('--year', dest='year', type=int,
                    help='Year')
parser.add_argument('--month', dest='month', type=int,
                    help='Month')
parser.add_argument('--journal', dest='journal', type=str,
                    help='Journal (b or e)')

args = parser.parse_args()

if(args.year is None):
    year=2018
else:
    year=args.year
if(args.month is None):
    month=1
else:
    month=args.month

journal='e'
if(args.journal.lower()=='b'):
    journal='b'
if(args.journal.lower()=='c'):
    journal='c'

path="%s-%d-%02d"%(journal, year, month)


try:
    os.stat(path)
except:
    os.mkdir(path)          

journalre=re.compile(r"/%s/issues/[0-9]{4}/[0-9]{2}/[0-9]{2}/([a-zA-Z0-9]+)/index\.html"%journal)
filere=re.compile(r".*/issues/([0-9]{4})/([0-9]{2})/([0-9]{2})/([a-zA-Z0-9]+)/([a-zA-Z0-9.]+).*")

journalissue = "https://journals.iucr.org/%s/issues/%d/%02d/00/index.html"%(journal, year, month)
print(journalissue)
g = urllib2.urlopen(journalissue)
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
                g = urllib2.urlopen("https://journals.iucr.org/%s"%href)
                html = g.read()
                articlesoup = BeautifulSoup(html, 'lxml')

                #<meta name="citation_pdf_url" content="http://journals.iucr.org/e/issues/2011/10/00/lx2196/lx2196.pdf" />
                pdffile=articlesoup.find("meta", {"name":"citation_pdf_url"})['content']
                # Got a bug where http was missing in meta keyword
                result = filere.match(pdffile)
                pdffile = "https://journals.iucr.org/%s/issues/%s/%s/%s/%s/%s"%(journal, result.group(1), result.group(2), result.group(3), result.group(4), result.group(5))
                dlfile(pdffile, path+'/'+iucrcode+'/'+os.path.basename(pdffile))

                href_tags = articlesoup.find_all('a')
                for atag in href_tags:
                    link = atag.get('href')
                    if link is not None:
                        if(link[-4:]==".cif"):
                            print(link)
                            dlfile(link, path+'/'+iucrcode+'/'+os.path.basename(link))
                        if(link[-4:]==".hkl"):
                            print(link)
                            dlfile(link, path+'/'+iucrcode+'/'+os.path.basename(link))





