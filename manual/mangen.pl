#!/usr/bin/perl
# This is the beginning.

   $premode = 0;      # 0 = normal mode, 1 = literal (#J) output mode
   $totlines = 0;     # number of lines held in $data array (all files)
   $indexsize = 0;    # number of entries in the index array.
   $labelsize = 0;    # number of entries in the label (cross-ref) array.
   $htmlfileno = 0;   # file counter.

   $inInstruction = 0;
   $inDirective = 0;
   $inParameter = 0;

   $date = gmtime; $date =~ s/..:..:..//; # Get date and remove the time from the string
   $texword = $date; &texfix; $texdate = $texword; # Get a latex safe date.
   $thecolour = "blue";
   $hexcolour = "000080";

# File names to be read in (.man files) are given on the
# command line. Check there are some given:

   if ( $#ARGV == -1 ) {
      print "Give .man file names for processing\n" and die;
   }

# Make the output directories:

   mkdir "website" || die ( "Cannot make website directory: $!\n");
   mkdir "html"    || die ( "Cannot make html directory: $!\n") ;
   mkdir "latex"   || die ( "Cannot make latex directory: $!\n") ;

# Print out a required non-standard tex file:
   &printfancyheaderfile;

# Read all the files into the variable @data. One line per array item.:

   @inputfiles;

   $manloc = ".";
   if ( length($ENV{'CRYSSRC'}) ) {
     $manloc = "$ENV{'CRYSSRC'}/manual" 
   }

   for ($i=0; $i<=$#ARGV; $i++) {

      $manfile = "$manloc/$ARGV[$i]";
      push @inputfiles, $ARGV[$i];

      print "File: $manfile \n";
      open(DATA, "< $manfile" ) || die("Can not open $manfile: $!");

# Discard the first two lines of every file. (Paper size stuff).
      <DATA> || die("File $ARGV[$i] seems empty: $!");
      <DATA> || die("File $ARGV[$i] seems empty: $!");

# Read the rest of the lines into the @data array:
      while ( $line = <DATA> )  {
         $line =~ s/\cM//g;
         $line =~ s/\cJ//g;
         $data[$totlines++]="$line";
      }
   }

#Debug: print @data;

# Find all the VOLUME titles. These are the top level markers.
# (#T). Nothing preceding the first #T will be included.

   $nvolumes = 0;                    #total number of volumes
   $volumefilename[0] = "manual0";       #default name for 1st volume.

   for ( $i = 0; $i < $totlines; $i++ ) {
      if ( (substr($data[$i],0,2) cmp "\#T") == 0 ) {
         $volumestartline[$nvolumes++] = $i;
         $volumefilename[$nvolumes] = "manual$nvolumes"; #default name for this volume.
      }
      if ( (substr($data[$i],0,2) cmp "\#C") == 0 ) {
         $volumefilename[$nvolumes-1] = substr($data[$i],2); #Ignore first two chars.
         $volumefilename[$nvolumes-1] =~ s/\#.*//;     #Remove anything after the last #
      }
   }

   $volumestartline[$nvolumes] = $totlines;  #The very last line.

   print "Files read... \n";
#
#
# For each volume, find all the chapter titles. (#Z).
#
#

   open (  HTMLAY, ">website/manuallayout.dat") || die ("Can\'t open website/manuallayout.dat\n");


   for ( $thisvol = 0; $thisvol < $nvolumes; $thisvol++) {

      print "Processing $volumefilename[$thisvol] \n";
      $nchaps = 0;

      $voltitle = substr("$data[$volumestartline[$thisvol]]",2);
      $voltitle =~ s/\#//;

      open( TEXOUT,  ">latex/$volumefilename[$thisvol].tex" )|| die("Can not open latex/$volumefilename[$thisvol].tex: $!");
      &texheader;
      $htmlfile = "$volumefilename[$thisvol].html";

      $texword = $voltitle; &texfix;

      print TEXOUT "\\sloppy\n";
      print TEXOUT "\\title{$texword}\n";
      print TEXOUT "\\author{Chemical Crystallography Laboratory, Oxford}\n";
      print TEXOUT "\\date{$texdate}\n";
      print TEXOUT "\\maketitle\n";
      print TEXOUT "\\tableofcontents\n";

      $xvol = $thisvol + 40;
      $webvol = "$volumefilename[$thisvol]";
      open (  HTMLVOL, ">website/$webvol.tmp") || die ("Can\'t open website/$webvol.tmp\n");
      print   HTMLVOL  "<!-- XTLVAR title=\"$voltitle\" -->\n";
      print   HTMLVOL  "<!-- XTLVAR comment=\"$voltitle\" -->\n";
      print   HTMLVOL  "<!-- XTLVAR cvssource=\"manual/$inputfiles[$thisvol]\" -->\n";
      print   HTMLVOL  "<H1>$voltitle</H1>\n<H2>Contents</H2>\n";
      print   HTMLAY   "$webvol\n";

      for ( $li = $volumestartline[$thisvol]; $li < $volumestartline[$thisvol+1]; $li++ ) {
         if ( (substr($data[$li],0,2) cmp "\#Z") == 0 ) {
            $chapstartline[$nchaps++] = $li;
            $chaptername[$nchaps-1] = "$nchaps";       #default name
         }
         if ( (substr($data[$li],0,3) cmp "\#HC") == 0 ) {
            $chaptername[$nchaps-1] = substr($data[$li],3); #Ignore first three chars.
            $chaptername[$nchaps-1] =~ s/\#.*//;     #Remove anything after the last #
         }
      }
      $chapstartline[$nchaps] = $volumestartline[$thisvol+1]; # The last line of the current volume.

      for ($nc = 1; $nc <= $nchaps; $nc++ ) {
        $temptitle = substr("$data[$chapstartline[$nc-1]]",2);
        $temptitle =~ s/\#//;
        $temptitle =~ s/(\w+)/\u\L$1\E/g;
        print HTMLVOL "<A HREF=\"$volumefilename[$thisvol]-$chaptername[$nc-1].html\">$nc. $temptitle</A><br>\n";
      }

#
#
#Write content document for each volume. (HTML only).
#It will contain a list of chapters with a link to each.
#
#

      $htmlfile = "$volumefilename[$thisvol].html";
      open( HTMLOUT, ">$htmlfile" )|| die("Can not open $htmlfile: $!");
# Read in the template. 
      open( HTMLTEMPLATE,"$manloc/template.html") || die ("Couldn't open $manloc/template.html"); 
      @temp = <HTMLTEMPLATE>; 

# Setup title.
      $htmltitle = "$voltitle: Contents";

# Setup content.
      $content = "<H1>$voltitle</H1>\n<H2>Contents</H2>\n<DL><DT>\n";
# Output all chapter titles.
      for ($nc = 1; $nc <= $nchaps; $nc++ )  {
         $temptitle = substr("$data[$chapstartline[$nc-1]]",2); #Remove first two characters from string.
         $temptitle =~ s/\#//g;                                #Substitute any #'s with nothing
         $temptitle =~ s/(\w+)/\u\L$1\E/g;                     #Match each (g) word (\w+), lowercase the whole match (\L...\E), then uppercase the first character (\u).
         $content .= "<DD><A HREF=\"$volumefilename[$thisvol]-$chaptername[$nc-1].html\">$nc. $temptitle</A><br>\n";
      }
      $content .= "</DL>\n";


# Setup menu.
      $themenu = "\n";
      $footindex = "\n";

# Output volume titles up to this one.
      for ($nv = 0; $nv < $thisvol; $nv++ ) {
        $temptitle = substr("$data[$volumestartline[$nv]]",2);
        $temptitle =~ s/\#//;
        $themenu .= "<A class=\"menuitem\" HREF=\"$volumefilename[$nv].html\">+ $temptitle</A>\n";
      }

# Output this volume title.
      $temptitle = substr("$data[$volumestartline[$thisvol]]",2);
      $temptitle =~ s/\#//;
      $themenu .= "<div class=\"menuitem\">$temptitle</div>\n";

      $themenu .= "<div class=\"menublock\">\n";

# Output all chapter titles.
      for ($nc = 1; $nc <= $nchaps; $nc++ )  {
         $temptitle = substr("$data[$chapstartline[$nc-1]]",2); #Remove first two characters from string.
         $temptitle =~ s/\#//g;                                #Substitute any #'s with nothing
         $temptitle =~ s/(\w+)/\u\L$1\E/g;                     #Match each (g) word (\w+), lowercase the whole match (\L...\E), then uppercase the first character (\u).
         $themenu .= "<A class=\"menuitem\" HREF=\"$volumefilename[$thisvol]-$chaptername[$nc-1].html\">$nc. $temptitle</A>\n";
      }

      $themenu .= "</div>\n";

# Output volume titles after this one.
      for ($nv = $thisvol+1; $nv < $nvolumes; $nv++ )  {
         $temptitle = substr("$data[$volumestartline[$nv]]",2);
         $temptitle =~ s/\#//;
         $themenu .= "<A class=\"menuitem\" HREF=\"$volumefilename[$nv].html\">+ $temptitle</A>\n";
      }

# Link to index file
      $themenu .= "<A class=\"menuitem\" HREF=\"manindex.html\">+ Index</A>\n";

# Do substitutions in the template and output.
      &tempsub; 

      close (HTMLOUT);
      close (HTMLTEMPLATE);
#
#
# Got all chapter titles for this volume. Now get all
# the section titles for each chapter in turn:
#
#

      for ( $thischap = 0; $thischap < $nchaps; $thischap++ )      {
         $nsects = 0;
         $tchap = $chaptername[$thischap];
         $rchap = $thischap + 1;
         $chaptitle = substr("$data[$chapstartline[$thischap]]",2);
         $chaptitle =~ s/\#//;
         $chaptitle =~ s/(\w+)/\u\L$1\E/g;

         $texword = $chaptitle; &texfix;
         print TEXOUT "\\chapter{$texword}\n";
#         print TEXOUT "\\special{pdf: out 1 << /Title ($texword) /Dest [ \@thispage /FitH \@ypos] >> }\n";

         $filestem = "$volumefilename[$thisvol]-$tchap";
         $htmlfiles[$htmlfileno] = $filestem; $htmlfileno++;
         $htmlfile = "$filestem.tmp";

         for ( $li = $chapstartline[$thischap]; $li < $chapstartline[$thischap+1]; $li++) {
            if ( (substr($data[$li],0,2) cmp "\#Y") == 0 )  {
               $sectstart[$nsects++] = $li;
               $sectname[$nsects-1] = "$nsects";
            }
            if ( (substr($data[$li],0,3) cmp "\#HS") == 0 ) {
               $sectname[$nsects-1] = substr($data[$li],3); #Ignore first three chars.
               $sectname[$nsects-1] =~ s/\#.*//;     #Remove anything after the last #
            }

         }
         $sectstart[$nsects] = $chapstartline[$thischap+1]; # The last line of the chapter:

#
#
# We now have all the section titles for this chapter. We must now
# output this chapter.
#
#

         open( HTMLOUT, ">$htmlfile" )|| die("Can not open $htmlfile: $!");
# Read in the template. 
         open( HTMLTEMPLATE,"$manloc/template.html") || die ("Couldn't open $manloc/template.html"); 
         @temp = <HTMLTEMPLATE>; 

         $xchap = $thischap + 10;
         $webchap = "$volumefilename[$thisvol]-$tchap";
         open  ( HTMLWEB, ">website/$webchap.tmp")    || die ("Can\'t open website/$webchap.tmp\n");
         print   HTMLWEB  "<!-- XTLVAR title=\"$chaptitle\" -->\n";
         print   HTMLWEB  "<!-- XTLVAR comment=\"$chaptitle\" -->\n";
         print   HTMLWEB  "<!-- XTLVAR cvssource=\"manual/$inputfiles[$thisvol]\" -->\n";
         print   HTMLAY   ":$webchap\n";


# Setup title.
         $htmltitle = "$voltitle - $rchap: $chaptitle";

# Setup section title contents.
        $content = "<H1>$voltitle</H1>\n<H2>Chapter $rchap: $chaptitle</H2>\n<DL><DT>\n";
        print HTMLWEB "<H1>$voltitle</H1>\n<H2>Chapter $rchap: $chaptitle</H2>\n<DL><DT>\n";

        for ($ns = 1; $ns <= $nsects; $ns++ )        {
           $temptitle = substr("$data[$sectstart[$ns-1]]",2);
           $temptitle =~ s/\#//;
           $thisfile = "$volumefilename[$thisvol]-$tchap.html";
           $content .= "<DD><A HREF=\"$thisfile\#$tchap.$sectname[$ns-1]\">$rchap.$ns: $temptitle</A><br>\n";
           print HTMLWEB "<DD><A HREF=\"$thisfile\#$tchap.$sectname[$ns-1]\">$rchap.$ns: $temptitle</A><br>\n";
        }

        $content .= "</DL>\n";
        print HTMLWEB "</DL>\n";


# Setup main body of chapter.
#   output any text that preceeds the first section.

         $j = 0;
         for ($kj = $chapstartline[$thischap]+1; $kj < $sectstart[0]; $kj++)   {
            $line = $data[$kj];
            &substitute;
            $content .= "$htmlline\n";
            print HTMLWEB "$htmlline\n";
            print TEXOUT "$texline";
         }

#     output each section in turn.

         for ($j = 1; $j <= $nsects; $j++)  {

            $inInstruction = 0;
            $inDirective = 0;
            $inParameter = 0;

            $content .= "<HR><small><A HREF=\"$thisfile\">[Top]</A> <A HREF=\"manindex.html\">[Index]</A> Manuals generated on $date</small>\n";
            print HTMLWEB "<HR><small><A HREF=\"$thisfile\">[Top]</A> <A HREF=\"manindex.html\">[Index]</A> Manuals generated on $date</small>\n";
            $sectitle = substr("$data[$sectstart[$j-1]]",2);
            $sectitle =~ s/\#//;
            $content .= "<CENTER><H3><A NAME=\"$tchap.$sectname[$j-1]\">$rchap.$j: $sectitle</A></H3></CENTER>\n";
            print HTMLWEB "<CENTER><H3><A NAME=\"$tchap.$sectname[$j-1]\">$rchap.$j: $sectitle</A></H3></CENTER>\n";

            $texword = $sectitle; &texfix;
            print TEXOUT "\\section{$texword}\n";
#            print TEXOUT "\\special{pdf: out 2 << /Title ($texword) /Dest [ \@thispage /FitH \@ypos] >> }\n";

            for ($k = $sectstart[$j-1]+1; $k < $sectstart[$j]; $k++) {
               $line = $data[$k];
               &substitute;
               $content .= "$htmlline\n";
               print HTMLWEB "$htmlline\n";
               print TEXOUT "$texline\n";
            }
# Close any open indented divisions:
            if ( $inParameter ) {
               print HTMLWEB "\<\/div\>\n";
               $content .= "\<\/div\>\n";
            }
            if ( $inDirective ) {
               print HTMLWEB "\<\/div\>\n";
               $content .= "\<\/div\>\n";
            }
            if ( $inInstruction ) {
               print HTMLWEB "\<\/div\>\n";
               $content .= "\<\/div\>\n";
            }

         }

# Setup menu

         $themenu = "\n";
         $footindex = "\n";

# Setup volume titles up to this one.
        for ($nv = 0; $nv < $thisvol; $nv++ ) {
           $temptitle = substr("$data[$volumestartline[$nv]]",2);
           $temptitle =~ s/\#//;
           $themenu .= "<A class=\"menuitem\" HREF=\"$volumefilename[$nv].html\">+ $temptitle</A>\n";
        }

# Setup this volume title.
        $temptitle = substr("$data[$volumestartline[$thisvol]]",2);
        $temptitle =~ s/\#//;
        $themenu .= "<div class=\"menuitem\">$temptitle</div>\n";

# Output chapter titles up to this one.
        $themenu .= "<div class=\"menublock\">\n";
        for ($nc = 1; $nc <= $thischap; $nc++ )  {
           $temptitle = substr("$data[$chapstartline[$nc-1]]",2); #Remove first two characters from string.
           $temptitle =~ s/\#//g;                                #Substitute any #'s with nothing
           $temptitle =~ s/(\w+)/\u\L$1\E/g;                     #Match each (g) word (\w+), lowercase the whole match (\L...\E), then uppercase the first character (\u).
           $themenu .= "<A class=\"menuitem\" HREF=\"$volumefilename[$thisvol]-$chaptername[$nc-1].html\">$nc. $temptitle</A>\n";
        }

        $temptitle = substr("$data[$chapstartline[$thischap]]",2);
        $temptitle =~ s/\#//;
        $temptitle =~ s/(\w+)/\u\L$1\E/g;
        $rchap = $thischap + 1;
        $themenu .= "<div class=\"menuitem\">$rchap. $temptitle</div>\n";

# Output chapter titles after this one.
        for ($nc = $thischap+2; $nc <= $nchaps; $nc++ ) {
           $temptitle = substr("$data[$chapstartline[$nc-1]]",2);
           $temptitle =~ s/\#//;
           $temptitle =~ s/(\w+)/\u\L$1\E/g;
           $themenu .= "<A class=\"menuitem\" HREF=\"$volumefilename[$thisvol]-$chaptername[$nc-1].html\">$nc. $temptitle</A>\n";
        }

# Output volume titles after this one.
        $themenu .= "</div>\n";
        for ($nv = $thisvol+1; $nv < $nvolumes; $nv++ )  {
           $temptitle = substr("$data[$volumestartline[$nv]]",2);
           $temptitle =~ s/\#//;
           $themenu .= "<A class=\"menuitem\" HREF=\"$volumefilename[$nv].html\">+ $temptitle</A>\n";
        }

# Link to index file
        $themenu .= "<A class=\"menuitem\" HREF=\"manindex.html\">+ Index</A>\n";

# Output footers.
        &tempsub;
        close (HTMLOUT);
        close (HTMLTEMPLATE);

      }
      &texfooter;     #Remember: LaTeX has one file per volume.
    }

# Print closing messages:

   print "Creating Index... \n";
   @sortedindex = sort @indexstore;
   $firstchar = "";      #Keep track of letters so that we can put a
   $oldfirstchar = "";   #small gap between first letter changes.

   $xvol = $nvolumes + 40;
   $webvol = "website/manindex.dat";

   open (  HTMLVOL, ">$webvol") || die ("Can\'t open $webvol\n");

   print   HTMLVOL  "<!-- XTLVAR title=\"Index\" -->\n";
   print   HTMLVOL  "<!-- XTLVAR comment=\"Index of keywords from all sections of the manual\" -->\n";
   print   HTMLVOL  "<!-- XTLVAR cvssource=\"manual/crystals.man\" -->\n";
   print   HTMLVOL  "<H1>Index</H1>\n";

   open ( HTMLOUT, ">html/manindex.html" ) || die ("Can not open html/manindex.html: $!");

   print   HTMLAY   "manindex\n";


   $htmltitle = "Manuals - Index";
   &htmlheader;

   
# Output index.
   for ($i = 0; $i < $indexsize; $i++)  {
      $firstchar = lc substr ($sortedindex[$i],0,1);
      if (($oldfirstchar cmp $firstchar) <=> 0 ) {
         print HTMLOUT "<P>\n";
         print HTMLVOL "<P>\n";
      }
      $oldfirstchar = $firstchar;
      $_ = $sortedindex[$i];
      /(.*)\#(.*)/;
      print HTMLOUT "<A HREF=\"$2#$1\">$1</A><BR>\n";
      print HTMLVOL "<A HREF=\"$2#$1\">$1</A><BR>\n";
   }

   &htmlmidpoint;                    #Close left col and start right column.

   print HTMLOUT "<H2 class=\"menutitle\">Menu</H2>\n";  #Put in the date
   print HTMLOUT "<p class=\"menu\">\n";

# Output volume titles.
   for ($nv = 0; $nv < $nvolumes; $nv++ )  {
      $temptitle = substr("$data[$volumestartline[$nv]]",2);
      $temptitle =~ s/\#//;
      print HTMLOUT "<A class=\"menu\" HREF=\"$volumefilename[$nv].html\" class=\"menu\">+ $temptitle</A>\n";
   }

   print HTMLOUT "<P class=\"menu\">- Index</p>\n";
   print HTMLOUT "<H2 class=\"menutitle\">$date</H2>\n";  #Put in the date



   &htmlfooter; #Remember: HTML has one file per chapter.


# Loop through all the chapters putting in label jumps.
   print "Cross referencing... \n";

   for ( $i = 0; $i < $htmlfileno; $i++ )   {
      open ( HTMLIN, "$htmlfiles[$i].tmp" ) || die ( "Can not open $htmlfiles[$i].tmp for reading: $!\n");
      open ( HTMLOUT,">html/$htmlfiles[$i].html") || die ( "Can not open html/$htmlfiles[$i].html for writing: $!\n");

      while ( $line = <HTMLIN> )  {
         $line =~ s/\cM//g;
         $line =~ s/\cJ//g;
         if ( index($line, "!elabel!") >=0 ) {
            $_ = $line;
            /!elabel!(.*?)!/ || die ("elabel error\n");
            $label = $1;
            $labfound = 0;
            for ( $j=0; $j<$labelsize; $j++ )  {
               if (( substr($labelstore[$j],0,length($label)) cmp $label ) == 0) {
                  $_ = $labelstore[$j];
                  /\#(.*?)#(.*)/;
                  $address = $1;
                  $section = $2;
                  $labfound = 1;
               }
            }
            if ( $labfound == 1) {
               $line =~ s/!elabel!.*?!/\<A HREF=\"$address#$label\"\>$section\<\/A\>/ ;
            }
            else                 {
                die ("Label not found - \"$label\" in $htmlfiles[$i].tmp:\n $line \n NB: Usual cause is writing e.g. \#regroup instead of \\regroup\n");
            }
         }
         print HTMLOUT "$line\n";
      }
      close ( HTMLIN );
      close ( HTMLOUT );
      unlink "$htmlfiles[$i].tmp"; # deletes tmp file.
   }

   my @listing = glob "website/*.tmp"; 
   foreach $tempfile (@listing) { 
      open ( HTMLIN, "$tempfile" ) || die ( "Can not open $tempfile for reading: $!\n");
      $outfile = $tempfile;
      $outfile =~ s/\.tmp/\.dat/;
      open ( HTMLOUT,">$outfile") || die ( "Can not open $tempfile for writing: $!\n");
      while ( $line = <HTMLIN> )  {
         $line =~ s/\cM//g;
         $line =~ s/\cJ//g;
         if ( index($line, "!elabel!") >=0 ) {
            $_ = $line;
            /!elabel!(.*?)!/ || die ("elabel error\n");
            $label = $1;
            $labfound = 0;
            for ( $j=0; $j<$labelsize; $j++ )  {
               if (( substr($labelstore[$j],0,length($label)) cmp $label ) == 0) {
                  $_ = $labelstore[$j];
                  /\#(.*?)#(.*)/;
                  $address = $1;
                  $section = $2;
                  $labfound = 1;
               }
            }
            if ( $labfound == 1) {
               $line =~ s/!elabel!.*?!/\<A HREF=\"$address#$label\"\>$section\<\/A\>/ ;
            }
            else                 {
                die ("Label not found - \"$label\" in $htmlfiles[$i].tmp:\n $line \n NB: Usual cause is writing e.g. \#regroup instead of \\regroup\n");
            }
         }
         print HTMLOUT "$line\n";
      }
      close ( HTMLIN );
      close ( HTMLOUT );
      unlink "$tempfile"; # deletes tmp file.
   }

   print "Mangen - Finished\n";

# The End.




###################################################################
##################################################################
###################################################################
####################################################################
###################################################################




sub substitute{

# The variable $line is passed in. We return the variable $htmlline with the required
# text for output, and $texline with the tex output.

# NB all variables are global unless specifically scoped. "Passed in" and "returned"
# are just used for explanation.

# A word about regular expressions:
# The s/// function swaps whatever is between the first slashes with whatever is between the second pair.
# The =~ operator makes the lhs variable the thing which is operated upon.
# A s///g means that all occurences are to be substituted, not just the first.
# s///i means that the match is case insensitive.
# Anything in brackets in the first half of the match, is stored in $1, $2 etc, for use
# in the second half.
# . matches any character
# .* matches any number of any characters
# b.*n  would match "banan" from banana
# b.*?n would match "ban" from banana - the ? makes the match less greedy.
# Lots of things must be escaped with a \ in regular expressions including:
# \ = \\, $ = \$, < = \<, > = \>, / = \/, # = \#, & = \&.
# A newline is \n

#Because some of the tex markups clash with themselves, some are temporarily
#marked up as !command while the others are processed. (see sub texfix).

   $htmlline = $texline = $line;


   if ( $premode == 1 )
   {
       if ( index($line,"\#") >= 0)
       {
# End preformatted text
          $htmlline =~ s/\#/!endpre\#/;
          $texline =~ s/\#/!endverbatim\#/;
          $premode = 0;
       }
   }

# Markup special characters

   $htmlline =~ s/\</\&lt;/g;
   $htmlline =~ s/\>/\&gt;/g;

   if ( $premode == 0 )
   {
      $texword = $texline;
      &texfix;
      $texline = $texword;
   }

# Format bolds - don't include #'s
   $htmlline =~ s/_b{(\S+)\#/\<strong\>$1\<\/strong\>/gi;
   $texline  =~ s/\\_b\\{(\S+)\#/{\\bf $1}/gi;

   $htmlline =~ s/_b{(\S+)/\<strong\>$1\<\/strong\>/gi;
   $texline  =~ s/\\_b\\{(\S+)/{\\bf $1}/gi;

# Format italics
   $htmlline =~ s/_i{(\S+)\#/\<i\>$1\<\/i\>/gi;
   $texline  =~ s/\\_i\\{(\S+)\#/\\emph{$1}/gi;
   $htmlline =~ s/_i{(\S+)/\<i\>$1\<\/i\>/gi;
   $texline  =~ s/\\_i\\{(\S+)/\\emph{$1}/gi;

# Swap #P for <P>
   $htmlline =~ s/\#P/\<P\>/;
   $texline  =~ s/\#P/\n\n/;
# Swap #HPtext for <P class="text">
   $htmlline =~ s/\#HP(.*?) /\<P class=\"$1\"\>/;
   $texline  =~ s/\#HP(.*?) /\n\n/;
# Remove #N xx#
   $htmlline =~ s/\#N.*\#//;
   $texline  =~ s/\#N.*\#//;
# Remove lone #N
   $htmlline =~ s/\#N//;
   $texline  =~ s/\#N//;
# Remove filename info #H...#
   $htmlline =~ s/\#HC.*\#//;
   $texline  =~ s/\#HC.*\#//;
   $htmlline =~ s/\#HS.*\#//;
   $texline  =~ s/\#HS.*\#//;
# Start preformatted text
   if ( index($line,"\#J") >= 0)
   {
      $premode = 1;
      $htmlline =~ s/\#J/\<pre\>/;
      $texline =~ s/\#J/\\small\\begin{verbatim}/;
   }
   if ( index($line,"\#HJ") >= 0)
   {
      $premode = 1;
      $htmlline =~ s/\#HJ/\<pre class=\"typing\"\>/;
      $texline =~ s/\#HJ/\\small\\begin{verbatim}/;
   }
# Do indenting. Each #I, #D, #K is nested in its own DIV.
# #D is closed by a new #I or #D, #K is closed by new #I,#D or #K
# All are closed by a new #Y or #Z but that must be handled higher up.
   if ( index($line,"\#I") >= 0)
   {
      $htmlline = "\<div class=\"instruction\"\>" . $htmlline;
      if ( $inInstruction > 0 ) {
         $htmlline = "\<\/div\>\n" . $htmlline;
      }
      if ( $inDirective > 0 ) {
         $htmlline = "\<\/div\>\n" . $htmlline;
         $inDirective = 0;
      }
      if ( $inParameter > 0 ) {
         $htmlline = "\<\/div\>\n" . $htmlline;
         $inParameter = 0;
      }
      $inInstruction = 1;
   }

   if ( index($line,"\#D") >= 0)
   {
      $htmlline = "\<div class=\"directive\"\>" . $htmlline;
      if ( $inDirective > 0 ) {
         $htmlline = "\<\/div\>\n" . $htmlline;
      }
      if ( $inParameter > 0 ) {
         $htmlline = "\<\/div\>\n" . $htmlline;
         $inParameter = 0;
      }
      $inDirective = 1;
   }
   if ( index($line,"\#K") >= 0)
   {
      $htmlline = "\<div class=\"parameter\"\>" . $htmlline;
      if ( $inParameter > 0 ) {
         $htmlline = "\<\/div\>\n" . $htmlline;
      }
      $inParameter = 1;
   }
# Format #I's
   $htmlline =~ s/\#I(.*)\#/\<strong\>\<u\>$1\<\/u\>\<\/strong\>\<br\>/;
   $htmlline =~ s/\#I(.*)\n/\<strong\>$1\<\/strong\>/;

#   if ( index ($line, "\#I") >= 0) { print ERROUT "Inp: $line\nNow: $texline\n";}

   $texline =~ s/\#I(.*)\#/\n\n\\bigskip\\Instruction{$1}\n\n/;
   $texline =~ s/\#I(.*)\n/\n\n\\bigskip\\Instruction{$1}\n\n/;

#   if ( index ($line, "\#I") >= 0) { print ERROUT "New: $texline\n";}


# Format #D's
   $htmlline =~ s/\#D(.*)\#/\<strong\>\<i\>$1\<\/i\>\<\/strong\>/;
   $htmlline =~ s/\#D(.*)\n/\<strong\>\<i\>$1\<\/i\>\<\/strong\>/;

   $texline =~ s/\#D(.*)\#/\n\n\\bigskip\\Directive{$1}/;
   $texline =~ s/\#D(.*)\n/\n\n\\bigskip\\Directive{$1}/;

# Format #K's
   $htmlline =~ s/\#K(.*)\#/\<i\>$1\<\/i\>/g;
   $htmlline =~ s/\#K(.*)\n/\<i\>$1\<\/i\>/g;

   $texline =~ s/\#K(.*)\#/\n\n\\bigskip\\Keyword{$1}/g;
   $texline =~ s/\#K(.*)\n/\n\n\\bigskip\\Keyword{$1}/g;

# Format #U's
   $htmlline =~ s/\#U([^ ]*)\ (.*)\#/\<A HREF=\"$1\"\>$2\<\/A\>/g;
   $texline =~  s/\#U([^ ]*)\ (.*)\#/\\url{$1}{$2}/g;
   $htmlline =~ s/\#U(.*)\#/\<A HREF=\"$1\"\>$1\<\/A\>/g;
   $texline =~ s/\#U(.*)\#/\\url{$1}/g;

# Insert pictures #HI into html - ignore for LaTeX:
   $htmlline =~ s/\#HI(.*)\#/\<P\>\<IMG ALIGN="center" SRC=\"$1\"\>\<\/P\>/g;
   $htmlline =~ s/\#HI(.*)\n/\<P\>\<IMG ALIGN="top" SRC=\"$1\"\>\<\/P\>/g;
   $texline  =~ s/\#HI(.*)\#/\\hbox{\\centering\\pdfximage{..\/$1}\\pdfrefximage\\pdflastximage}/g;
   $texline  =~ s/\#HI(.*)\n/\\hbox{\\centering\\pdfximage{..\/$1}\\pdfrefximage\\pdflastximage}/g;

# Store index items
   if ( index($line,"\#X") >= 0)
   {
      $_ = $htmlline;
#      /\#X(.*?)\#/;
      $htmlline =~ s/\#X(.*?)\#/\<A NAME=\"$1\"\> \<\/A\>/;
      $indexstore[$indexsize] = $1;
      $indexstore[$indexsize] .= "#$thisfile";
      $indexsize++;
   }

   $texline =~ s/\#X(.*?)\#/\\index{$1}/;

# Store label items
   if ( index($line,"\#A") >= 0)
   {
      $_ = $htmlline;
#      /\#A(.*?)\#/;
      $htmlline =~ s/\#A(.*?)\#/\<A NAME=\"$1\"\> \<\/A\>/;
      $texline =~ s/\#A(.*?)\#/\\label{$1} /;
      $labelstore[$labelsize] = $1;
      $labelstore[$labelsize] .= "#$thisfile#$rchap.$j";
      $labelsize++;
   }

# Markup label references

   $htmlline =~ s/\#R(.*?)\#(.*?)\#/!flabel!$1!$2!/;
   $htmlline =~ s/\#R(.*?)\#/!elabel!$1!/;
   $htmlline =~ s/\#R(.*?)/!elabel!$1!/;

   $texline =~ s/\#R(.*?)\#(.*?)\#/$2 \\ref{$1}/;
   $texline =~ s/\#R(.*?)\#/\\ref{$1}/;
   $texline =~ s/\#R(.*?)/\\ref{$1}/;

# Remove any remaining #
   $htmlline =~ s/\#Q/\<BR\>\&nbsp\;\<BR\>/;
   $htmlline =~ s/\#/\<BR\>/;

   $texline =~ s/\#Q/\n\n/;
   $texline =~ s/\#/\n\n/;

   $htmlline =~ s/!endpre/\<\/pre\>\<p\>/;
   $texline =~ s/!endverbatim/\\end{verbatim}\\normalsize/;

}




###################################################################
##################################################################
###################################################################
####################################################################
###################################################################



sub htmlheader {
   print HTMLOUT qq|<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
                        <HTML><HEAD><TITLE>$htmltitle</TITLE>
<META NAME="Keywords" CONTENT="Crystals, Manual, FAQ, Cameron, crystallography
software, small molecule, refinement, chemical, X-ray, Xray, least
squares, analysis, thermal ellipsoid plot, adp, graphical, absorption
correction, data reduction, parameters, atom placement, constraints,
restraints, disorder, twinning, weighting scheme, Fourier map, cif, RC93,
DIPIN, CSD2CRY, SXtoCRY, CIF2CRY, Oxford">
<META NAME="Description" CONTENT="The manuals describe how to use CRYSTALS and
associated programs for single crystal X-ray structure analysis.">
<style type="text/css">
<!--

p {font:10pt/12pt Tahoma, Verdana, Arial, Geneva, sans-serif; margin:1em
.5em; text-align: justify;}
td {font:10pt/12pt Tahoma, Verdana, Arial, Geneva, sans-serif; margin:1em
.5em; text-align: justify;}
li {font:10pt/12pt Tahoma, Verdana, Arial, Geneva, sans-serif;}
h1 { color:#FFFFFF; background-color:#000088;
 padding: 3px; }
img { margin: 3px; }
.tight { margin: 0; padding: 0 }
a:hover {   color: #FF2020; }
.blue  { background-color: #000088; }
.typing { font-family: lucida console, courier new, courier; font-weight: bold;
          background-color:#000; color: #FF0; }
h2.menutitle {
 font-family: tahoma,helvetica,sans-serif; font-size:12px; font-weight: bold;
 background-color: #000088; color:#FFFFFF;
 margin: 0px 0px 0px 0px;   text-align:center; padding: 2px; }
a.menu { display: block; color:#000088; }
a.menulist { display: block; color:#008800; text-align:right; }
p.menu { font-family: tahoma, helvetica,sans-serif; font-size:12px; color:#000000;
text-decoration: none; font-weight: normal;
text-align:left; margin: 0px 0px 0px 0px; }
a.footer  { font-family: tahoma, helvetica,sans-serif; font-size:12px; color:#FFFFFF;
text-decoration: none; font-weight: normal; }
BODY { background: white url(parksback.jpg); background-attachment: fixed; margin:0; }

#headfoot  {  font-family: tahoma,helvetica,sans-serif;  font-size:12px;color:#FFFFFF;
  text-align:right;  background-color: #000088;  padding: 5px;
  border-top: thin solid black; border-bottom: thin solid black;
}

#main { padding: 10px; margin-right: 176px; }

#menu { position:absolute; top: 140px; right: 10px; margin: 10px; width:176px;
  padding:1px; background-color:#fff; border:thin solid #000;
  line-height:17px; color: #000;
/* The ugly IE5 hack. */
  voice-family: "\\"}\\"";
  voice-family:inherit;
  width:156px;
}
/* The additional, "be nice to Opera 5" hack. */
  body>#Menu {width:156px;}
-->
</style> </HEAD>
<BODY BACKGROUND="parksback.jpg">\n|;


   print HTMLOUT qq|

<DIV id="headfoot">
 <TABLE WIDTH="100%" class="blue">
  <TR>
   <TD><A HREF="http://www.xtl.ox.ac.uk/">
    <IMG SRC="s_9parks.gif" BORDER="0" ALT="Chemical Crystallography"></A>
   </TD>
   <TD class="blue">&nbsp;</TD>
   <TD WIDTH="100%"><H1>CRYSTALS off-line manuals</H1>
   </TD>
   <TD class="blue">&nbsp;</TD>
   <TD><p>
    <A HREF="http://www.xtl.ox.ac.uk/crystals.html">
    <IMG SRC="crystals_now.gif" BORDER="0" ALT="Crystals website"></A><BR><BR>
    <A HREF="http://www.xtl.ox.ac.uk/crystalsmanual.html">
    <IMG SRC="manuals_now.gif" BORDER="0" ALT="On-line manuals"></A></p>
   </TD>
  </TR>
 </TABLE>
</DIV>

<DIV id="main">|;


}

sub htmlmidpoint {

  print HTMLOUT qq!<DIV id="menu">
<font point-size="8">!;

}

sub htmlfooter {
  print HTMLOUT qq!
</font>
</DIV>

</DIV>

<DIV id="headfoot"><P>
&copy; Copyright Chemical Crystallography Laboratory, Oxford, 2002<BR>
Comments or queries to David Watkin -
<A class="footer" HREF="mailto:david.watkin\@chem.ox.ac.uk">
david.watkin\@chem.ox.ac.uk</A> Telephone +44 1865 285019<br>

<small>The manuals were re-generated on $date.</small>
</p>
</div>
</BODY></HTML>!;

}

sub texheader {

    print TEXOUT "\\documentclass[10pt,a4paper]\{report\}
\\usepackage[centertags]\{amsmath\}
\\usepackage\{amsfonts\}
\\usepackage\{amssymb\}
\\usepackage\{amsthm\}
\\usepackage\{makeidx\}
\\usepackage\{newlfont\}
\\usepackage{fancyhdr}
\\usepackage[bookmarks,colorlinks,plainpages,backref]{hyperref}
\\pagestyle{fancy}
\\hfuzz2pt % Don't bother to report over-full boxes if over-edge is < 2pt
\\makeindex
\\addtolength{\\headwidth}{80pt}
\\addtolength{\\textwidth}{80pt}
\\addtolength{\\oddsidemargin}{-30pt}
\\begin\{document\}
\\lhead{\\slshape \\rightmark}
\\chead{}
\\rhead{\\thepage}
\\lfoot{$texdate}
\\cfoot{}
\\rfoot{}
\\renewcommand{\\headrulewidth}{0pt}
\\renewcommand{\\footrulewidth}{0pt}
\\fancypagestyle{plain}{%
\\fancyhf{}
\\fancyfoot[L]{$texdate}
\\fancyfoot[C]{\\thepage}
\\renewcommand{\\headrulewidth}{0pt}
\\renewcommand{\\footrulewidth}{0pt}}
\\newcommand{\\Instruction}[1]{{\\bf #1}}
\\newcommand{\\Directive}[1]{{\\bf \\emph{#1}}}
\\newcommand{\\Keyword}[1]{\\emph{#1}}\n";

}

sub texfooter {
    print TEXOUT "\\printindex\n";
    print TEXOUT "\\end\{document\}\n";
}

sub texfix {
            $texword =~ s/\$/!dollar/g;
            $texword =~ s/\\/!backsl/g;
            $texword =~  s/{/!opencl/g;
            $texword =~  s/}/!closcl/g;

            $texword =~ s/\%/\\%/g;
            $texword =~ s/\</\$<\$/g;
            $texword =~ s/\>/\$>\$/g;
            $texword =~ s/_/\\_/g;                  # _ into \_
            $texword =~ s/\&/\\\&/g;                # & into \&


            $texword =~ s/!dollar/\\\$/g;                 # dollar into escaped dollar
            $texword =~ s/!backsl/\$\\backslash\$/g;    # \ into mathmode \backslash
            $texword =~ s/!opencl/\\{/g;                  # { into escaped {
            $texword =~ s/!closcl/\\}/g;                  # } into escaped }
}





# This file allows us to easily customize the headers in the
# latex document. I've included it in the manual generating
# program to minimize the number of external files required
# to produce the manuals.
sub printfancyheaderfile{
   open (FANCY, ">latex/fancyhdr.sty") || die( "Cannot open latex/fancyhdr.sty for output: $!") ;
print FANCY "
\% fancyhdr.sty version 1.99d
\% Fancy headers and footers for LaTeX.
\% Piet van Oostrum, Dept of Computer Science, University of Utrecht
\% Padualaan 14, P.O. Box 80.089, 3508 TB Utrecht, The Netherlands
\% Telephone: +31 30 2532180. Email: piet\@cs.ruu.nl
\% ========================================================================
\% LICENCE: This is free software. You are allowed to use and distribute
\% this software in any way you like. You are also allowed to make modified
\% versions of it, but you can distribute a modified version only if you
\% clearly indicate that it is a modified version and the person(s) who
\% modified it. This indication should be in a prominent place, e.g. in the
\% top of the file. If possible a contact address, preferably by email,
\% should be given for these persons. If that is feasible the modifications
\% should be indicated in the source code.
\% ========================================================================
\% MODIFICATION HISTORY:
\% Sep 16, 1994
\% version 1.4: Correction for use with \\reversemargin
\% Sep 29, 1994:
\% version 1.5: Added the \\iftopfloat, \\ifbotfloat and \\iffloatpage commands
\% Oct 4, 1994:
\% version 1.6: Reset single spacing in headers/footers for use with
\% setspace.sty or doublespace.sty
\% Oct 4, 1994:
\% version 1.7: changed \\let\\\@mkboth\\markboth to
\% \\def\\\@mkboth{\\protect\\markboth} to make it more robust
\% Dec 5, 1994:
\% version 1.8: corrections for amsbook/amsart: define \\\@chapapp and (more
\% importantly) use the \\chapter/sectionmark definitions from ps\@headings if
\% they exist (which should be true for all standard classes).
\% May 31, 1995:
\% version 1.9: The proposed \\renewcommand{\\headrulewidth}{\\iffloatpage...
\% construction in the doc did not work properly with the fancyplain style.
\% June 1, 1995:
\% version 1.91: The definition of \\\@mkboth wasn't restored on subsequent
\% \\pagestyle{fancy}'s.
\% June 1, 1995:
\% version 1.92: The sequence \\pagestyle{fancyplain} \\pagestyle{plain}
\% \\pagestyle{fancy} would erroneously select the plain version.
\% June 1, 1995:
\% version 1.93: \\fancypagestyle command added.
\% Dec 11, 1995:
\% version 1.94: suggested by Conrad Hughes <chughes\@maths.tcd.ie>
\% CJCH, Dec 11, 1995: added \\footruleskip to allow control over footrule
\% position (old hardcoded value of .3\\normalbaselineskip is far too high
\% when used with very small footer fonts).
\% Jan 31, 1996:
\% version 1.95: call \\\@normalsize in the reset code if that is defined,
\% otherwise \\normalsize.
\% this is to solve a problem with ucthesis.cls, as this doesn't
\% define \\\@currsize. Unfortunately for latex209 calling \\normalsize doesn't
\% work as this is optimized to do very little, so there \\\@normalsize should
\% be called. Hopefully this code works for all versions of LaTeX known to
\% mankind.
\% April 25, 1996:
\% version 1.96: initialize \\headwidth to a magic (negative) value to catch
\% most common cases that people change it before calling \\pagestyle{fancy}.
\% Note it can't be initialized when reading in this file, because
\% \\textwidth could be changed afterwards. This is quite probable.
\% We also switch to \\MakeUppercase rather than \\uppercase and introduce a
\% \\nouppercase command for use in headers. and footers.
\% May 3, 1996:
\% version 1.97: Two changes:
\% 1. Undo the change in version 1.8 (using the pagestyle{headings} defaults
\% for the chapter and section marks. The current version of amsbook and
\% amsart classes don't seem to need them anymore. Moreover the standard
\% latex classes don't use \\markboth if twoside isn't selected, and this is
\% confusing as \\leftmark doesn't work as expected.
\% 2. include a call to \\ps\@empty in ps\@\@fancy. This is to solve a problem
\% in the amsbook and amsart classes, that make global changes to \\topskip,
\% which are reset in \\ps\@empty. Hopefully this doesn't break other things.
\% May 7, 1996:
\% version 1.98:
\% Added \% after the line  \\def\\nouppercase
\% May 7, 1996:
\% version 1.99: This is the alpha version of fancyhdr 2.0
\% Introduced the new commands \\fancyhead, \\fancyfoot, and \\fancyhf.
\% Changed \\headrulewidth, \\footrulewidth, \\footruleskip to
\% macros rather than length parameters, In this way they can be
\% conditionalized and they don't consume length registers. There is no need
\% to have them as length registers unless you want to do calculations with
\% them, which is unlikely. Note that this may make some uses of them
\% incompatible (i.e. if you have a file that uses \\setlength or \\xxxx=)
\% May 10, 1996:
\% version 1.99a:
\% Added a few more \% signs
\% May 10, 1996:
\% version 1.99b:
\% Changed the syntax of \\f\@nfor to be resistent to catcode changes of :=
\% Removed the [1] from the defs of \\lhead etc. because the parameter is
\% consumed by the \\\@[xy]lhead etc. macros.
\% June 24, 1997:
\% version 1.99c:
\% corrected \\nouppercase to also include the protected form of \\MakeUppercase
\% \\global added to manipulation of \\headwidth.
\% \\iffootnote command added.
\% Some comments added about \\\@fancyhead and \\\@fancyfoot.
\% Aug 24, 1998
\% version 1.99d
\% Changed the default \\ps\@empty to \\ps\@\@empty in order to allow
\% \\fancypagestyle{empty} redefinition.

\\let\\fancy\@def\\gdef

\\def\\if\@mpty#1#2#3{\\def\\temp\@ty{#1}\\ifx\\\@empty\\temp\@ty #2\\else#3\\fi}

\% Usage: \\\@forc \\var{charstring}{command to be executed for each char}
\% This is similar to LaTeX's \\\@tfor, but expands the charstring.

\\def\\\@forc#1#2#3{\\expandafter\\f\@rc\\expandafter#1\\expandafter{#2}{#3}}
\\def\\f\@rc#1#2#3{\\def\\temp\@ty{#2}\\ifx\\\@empty\\temp\@ty\\else
                                    \\f\@\@rc#1#2\\f\@\@rc{#3}\\fi}
\\def\\f\@\@rc#1#2#3\\f\@\@rc#4{\\def#1{#2}#4\\f\@rc#1{#3}{#4}}

\% Usage: \\f\@nfor\\name:=list\\do{body}
\% Like LaTeX's \\\@for but an empty list is treated as a list with an empty
\% element

\\newcommand{\\f\@nfor}[3]{\\edef\\\@fortmp{#2}\%
    \\expandafter\\\@forloop#2,\\\@nil,\\\@nil\\\@\@#1{#3}}

\% Usage: \\def\@ult \\cs{defaults}{argument}
\% sets \\cs to the characters from defaults appearing in argument
\% or defaults if it would be empty. All characters are lowercased.

\\newcommand\\def\@ult[3]{\%
    \\edef\\temp\@a{\\lowercase{\\edef\\noexpand\\temp\@a{#3}}}\\temp\@a
    \\def#1{}\%
    \\\@forc\\tmpf\@ra{#2}\%
        {\\expandafter\\if\@in\\tmpf\@ra\\temp\@a{\\edef#1{#1\\tmpf\@ra}}{}}\%
    \\ifx\\\@empty#1\\def#1{#2}\\fi}
\%
\% \\if\@in <char><set><truecase><falsecase>
\%
\\newcommand{\\if\@in}[4]{\%
    \\edef\\temp\@a{#2}\\def\\temp\@b##1#1##2\\temp\@b{\\def\\temp\@b{##1}}\%
    \\expandafter\\temp\@b#2#1\\temp\@b\\ifx\\temp\@a\\temp\@b #4\\else #3\\fi}

\\newcommand{\\fancyhead}{\\\@ifnextchar[{\\f\@ncyhf h}{\\f\@ncyhf h[]}}
\\newcommand{\\fancyfoot}{\\\@ifnextchar[{\\f\@ncyhf f}{\\f\@ncyhf f[]}}
\\newcommand{\\fancyhf}{\\\@ifnextchar[{\\f\@ncyhf {}}{\\f\@ncyhf {}[]}}

\% The header and footer fields are stored in command sequences with
\% names of the form: \\f\@ncy<x><y><z> with <x> for [eo], <y> form [lcr]
\% and <z> from [hf].

\\def\\f\@ncyhf#1[#2]#3{\%
    \\def\\temp\@c{}\%
    \\\@forc\\tmpf\@ra{#2}\%
        {\\expandafter\\if\@in\\tmpf\@ra{eolcrhf,EOLCRHF}\%
            {}{\\edef\\temp\@c{\\temp\@c\\tmpf\@ra}}}\%
    \\ifx\\\@empty\\temp\@c\\else
        \\ifx\\PackageError\\undefined
        \\errmessage{Illegal char `\\temp\@c' in fancyhdr argument:
          [#2]}\\else
        \\PackageError{Fancyhdr}{Illegal char `\\temp\@c' in fancyhdr argument:
          [#2]}{}\\fi
    \\fi
    \\f\@nfor\\temp\@c{#2}\%
        {\\def\@ult\\f\@\@\@eo{eo}\\temp\@c
         \\def\@ult\\f\@\@\@lcr{lcr}\\temp\@c
         \\def\@ult\\f\@\@\@hf{hf}{#1\\temp\@c}\%
         \\\@forc\\f\@\@eo\\f\@\@\@eo
             {\\\@forc\\f\@\@lcr\\f\@\@\@lcr
                 {\\\@forc\\f\@\@hf\\f\@\@\@hf
                     {\\expandafter\\fancy\@def\\csname
                      f\@ncy\\f\@\@eo\\f\@\@lcr\\f\@\@hf\\endcsname
                      {#3}}}}}}

\% Fancyheadings version 1 commands. These are more or less deprecated,
\% but they continue to work.

\\newcommand{\\lhead}{\\\@ifnextchar[{\\\@xlhead}{\\\@ylhead}}
\\def\\\@xlhead[#1]#2{\\fancy\@def\\f\@ncyelh{#1}\\fancy\@def\\f\@ncyolh{#2}}
\\def\\\@ylhead#1{\\fancy\@def\\f\@ncyelh{#1}\\fancy\@def\\f\@ncyolh{#1}}

\\newcommand{\\chead}{\\\@ifnextchar[{\\\@xchead}{\\\@ychead}}
\\def\\\@xchead[#1]#2{\\fancy\@def\\f\@ncyech{#1}\\fancy\@def\\f\@ncyoch{#2}}
\\def\\\@ychead#1{\\fancy\@def\\f\@ncyech{#1}\\fancy\@def\\f\@ncyoch{#1}}

\\newcommand{\\rhead}{\\\@ifnextchar[{\\\@xrhead}{\\\@yrhead}}
\\def\\\@xrhead[#1]#2{\\fancy\@def\\f\@ncyerh{#1}\\fancy\@def\\f\@ncyorh{#2}}
\\def\\\@yrhead#1{\\fancy\@def\\f\@ncyerh{#1}\\fancy\@def\\f\@ncyorh{#1}}

\\newcommand{\\lfoot}{\\\@ifnextchar[{\\\@xlfoot}{\\\@ylfoot}}
\\def\\\@xlfoot[#1]#2{\\fancy\@def\\f\@ncyelf{#1}\\fancy\@def\\f\@ncyolf{#2}}
\\def\\\@ylfoot#1{\\fancy\@def\\f\@ncyelf{#1}\\fancy\@def\\f\@ncyolf{#1}}

\\newcommand{\\cfoot}{\\\@ifnextchar[{\\\@xcfoot}{\\\@ycfoot}}
\\def\\\@xcfoot[#1]#2{\\fancy\@def\\f\@ncyecf{#1}\\fancy\@def\\f\@ncyocf{#2}}
\\def\\\@ycfoot#1{\\fancy\@def\\f\@ncyecf{#1}\\fancy\@def\\f\@ncyocf{#1}}

\\newcommand{\\rfoot}{\\\@ifnextchar[{\\\@xrfoot}{\\\@yrfoot}}
\\def\\\@xrfoot[#1]#2{\\fancy\@def\\f\@ncyerf{#1}\\fancy\@def\\f\@ncyorf{#2}}
\\def\\\@yrfoot#1{\\fancy\@def\\f\@ncyerf{#1}\\fancy\@def\\f\@ncyorf{#1}}

\\newdimen\\headwidth
\\newcommand{\\headrulewidth}{0.4pt}
\\newcommand{\\footrulewidth}{\\z\@skip}
\\newcommand{\\footruleskip}{.3\\normalbaselineskip}

\% Fancyplain stuff shouldn't be used anymore (rather
\% \\fancypagestyle{plain} should be used), but it must be present for
\% compatibility reasons.

\\newcommand{\\plainheadrulewidth}{\\z\@skip}
\\newcommand{\\plainfootrulewidth}{\\z\@skip}
\\newif\\if\@fancyplain \\\@fancyplainfalse
\\def\\fancyplain#1#2{\\if\@fancyplain#1\\else#2\\fi}

\\headwidth=-123456789sp \%magic constant

\% Command to reset various things in the headers:
\% a.o.  single spacing (taken from setspace.sty)
\% and the catcode of ^^M (so that epsf files in the header work if a
\% verbatim crosses a page boundary)
\% It also defines a \\nouppercase command that disables \\uppercase and
\% \\Makeuppercase. It can only be used in the headers and footers.
\\def\\fancy\@reset{\\restorecr
 \\def\\baselinestretch{1}\%
 \\def\\nouppercase##1{{\\let\\uppercase\\relax\\let\\MakeUppercase\\relax
     \\expandafter\\let\\csname MakeUppercase \\endcsname\\relax##1}}\%
 \\ifx\\undefined\\\@newbaseline\% NFSS not present; 2.09 or 2e
   \\ifx\\\@normalsize\\undefined \\normalsize \% for ucthesis.cls
   \\else \\\@normalsize \\fi
 \\else\% NFSS (2.09) present
  \\\@newbaseline\%
 \\fi}

\% Initialization of the head and foot text.

\% The default values still contain \\fancyplain for compatibility.
\\fancyhf{} \% clear all
\% lefthead empty on ``plain'' pages, \\rightmark on even, \\leftmark on odd pages
\% evenhead empty on ``plain'' pages, \\leftmark on even, \\rightmark on odd pages
\\fancyhead[el,or]{\\fancyplain{}{\\sl\\rightmark}}
\\fancyhead[er,ol]{\\fancyplain{}{\\sl\\leftmark}}
\\fancyfoot[c]{\\rm\\thepage} \% page number

\% Put together a header or footer given the left, center and
\% right text, fillers at left and right and a rule.
\% The \\lap commands put the text into an hbox of zero size,
\% so overlapping text does not generate an errormessage.
\% These macros have 5 parameters:
\% 1. \\\@lodd or \\\@rodd \% This determines at which side the header will stick
\%    out.
\% 2. \\f\@ncyolh, \\f\@ncyelh, \\f\@ncyolf or \\f\@ncyelf. This is the left component.
\% 3. \\f\@ncyoch, \\f\@ncyech, \\f\@ncyocf or \\f\@ncyecf. This is the middle comp.
\% 4. \\f\@ncyorh, \\f\@ncyerh, \\f\@ncyorf or \\f\@ncyerf. This is the right component.
\% 5. \\\@lodd or \\\@rodd \% This determines at which side the header will stick
\%    out. This is the reverse of parameter nr. 1. One of them is always
\%    \\relax and the other one is \\hss (after expansion).

\\def\\\@fancyhead#1#2#3#4#5{#1\\hbox to\\headwidth{\\fancy\@reset\\vbox{\\hbox
{\\rlap{\\parbox[b]{\\headwidth}{\\raggedright#2\\strut}}\\hfill
\\parbox[b]{\\headwidth}{\\centering#3\\strut}\\hfill
\\llap{\\parbox[b]{\\headwidth}{\\raggedleft#4\\strut}}}\\headrule}}#5}

\\def\\\@fancyfoot#1#2#3#4#5{#1\\hbox to\\headwidth{\\fancy\@reset\\vbox{\\footrule
\\hbox{\\rlap{\\parbox[t]{\\headwidth}{\\raggedright#2\\strut}}\\hfill
\\parbox[t]{\\headwidth}{\\centering#3\\strut}\\hfill
\\llap{\\parbox[t]{\\headwidth}{\\raggedleft#4\\strut}}}}}#5}

\\def\\headrule{{\\if\@fancyplain\\let\\headrulewidth\\plainheadrulewidth\\fi
\\hrule\\\@height\\headrulewidth\\\@width\\headwidth \\vskip-\\headrulewidth}}

\\def\\footrule{{\\if\@fancyplain\\let\\footrulewidth\\plainfootrulewidth\\fi
\\vskip-\\footruleskip\\vskip-\\footrulewidth
\\hrule\\\@width\\headwidth\\\@height\\footrulewidth\\vskip\\footruleskip}}

\\def\\ps\@fancy{\%
\\\@ifundefined{\@chapapp}{\\let\\\@chapapp\\chaptername}{}\%for amsbook
\%
\% Define \\MakeUppercase for old LaTeXen.
\% Note: we used \\def rather than \\let, so that \\let\\uppercase\\relax (from
\% the version 1 documentation) will still work.
\%
\\\@ifundefined{MakeUppercase}{\\def\\MakeUppercase{\\uppercase}}{}\%
\\\@ifundefined{chapter}{\\def\\sectionmark##1{\\markboth
{\\MakeUppercase{\\ifnum \\c\@secnumdepth>\\z\@
 \\thesection\\hskip 1em\\relax \\fi ##1}}{}}\%
\\def\\subsectionmark##1{\\markright {\\ifnum \\c\@secnumdepth >\\\@ne
 \\thesubsection\\hskip 1em\\relax \\fi ##1}}}\%
{\\def\\chaptermark##1{\\markboth {\\MakeUppercase{\\ifnum \\c\@secnumdepth>\\m\@ne
 \\\@chapapp\\ \\thechapter. \\ \\fi ##1}}{}}\%
\\def\\sectionmark##1{\\markright{\\MakeUppercase{\\ifnum \\c\@secnumdepth >\\z\@
 \\thesection. \\ \\fi ##1}}}}\%
\%\\csname ps\@headings\\endcsname \% use \\ps\@headings defaults if they exist
\\ps\@\@fancy
\\gdef\\ps\@fancy{\\\@fancyplainfalse\\ps\@\@fancy}\%
\% Initialize \\headwidth if the user didn't
\%
\\ifdim\\headwidth<0sp
\%
\% This catches the case that \\headwidth hasn't been initialized and the
\% case that the user added something to \\headwidth in the expectation that
\% it was initialized to \\textwidth. We compensate this now. This loses if
\% the user intended to multiply it by a factor. But that case is more
\% likely done by saying something like \\headwidth=1.2\\textwidth.
\% The doc says you have to change \\headwidth after the first call to
\% \\pagestyle{fancy}. This code is just to catch the most common cases were
\% that requirement is violated.
\%
    \\global\\advance\\headwidth123456789sp\\global\\advance\\headwidth\\textwidth
\\fi}
\\def\\ps\@fancyplain{\\ps\@fancy \\let\\ps\@plain\\ps\@plain\@fancy}
\\def\\ps\@plain\@fancy{\\\@fancyplaintrue\\ps\@\@fancy}
\\let\\ps\@\@empty\\ps\@empty
\\def\\ps\@\@fancy{\%
\\ps\@\@empty \% This is for amsbook/amsart, which do strange things with \\topskip
\\def\\\@mkboth{\\protect\\markboth}\%
\\def\\\@oddhead{\\\@fancyhead\\\@lodd\\f\@ncyolh\\f\@ncyoch\\f\@ncyorh\\\@rodd}\%
\\def\\\@oddfoot{\\\@fancyfoot\\\@lodd\\f\@ncyolf\\f\@ncyocf\\f\@ncyorf\\\@rodd}\%
\\def\\\@evenhead{\\\@fancyhead\\\@rodd\\f\@ncyelh\\f\@ncyech\\f\@ncyerh\\\@lodd}\%
\\def\\\@evenfoot{\\\@fancyfoot\\\@rodd\\f\@ncyelf\\f\@ncyecf\\f\@ncyerf\\\@lodd}\%
}
\\def\\\@lodd{\\if\@reversemargin\\hss\\else\\relax\\fi}
\\def\\\@rodd{\\if\@reversemargin\\relax\\else\\hss\\fi}

\\newif\\iffootnote
\\let\\latex\@makecol\\\@makecol
\\def\\\@makecol{\\ifvoid\\footins\\footnotetrue\\else\\footnotefalse\\fi
\\let\\topfloat\\\@toplist\\let\\botfloat\\\@botlist\\latex\@makecol}
\\def\\iftopfloat#1#2{\\ifx\\topfloat\\empty #2\\else #1\\fi}
\\def\\ifbotfloat#1#2{\\ifx\\botfloat\\empty #2\\else #1\\fi}
\\def\\iffloatpage#1#2{\\if\@fcolmade #1\\else #2\\fi}

\\newcommand{\\fancypagestyle}[2]{\%
  \\\@namedef{ps\@#1}{\\let\\fancy\@def\\def#2\\relax\\ps\@fancy}}
";
}


 
sub tempsub{ 
 
    @days=('Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'); 
    @months=('January','February','March','April','May','June','July','August', 
             'September','October','November','December'); 
 
# %D = current Date 
# %T = Title 
# %F = File last modified date 
# %Y = current Year
# %N = fileName
# %CONTENT = content.dat
# %MENU = site menu for this page.
# %FOOTMENU = submenus from this page.
 
    ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time); 
    $year = $year + 1900; 
    $mdate = $date = "$days[$wday] $mday $months[$mon] $year"; 
 

    $count = 0;
    foreach $line (@temp) { 
        $line =~ s/%D/$date/; 
        $line =~ s/%T/$htmltitle/; 
        $line =~ s/%Y/$year/; 
        $line =~ s/%CONTENT/$content/; 
        $line =~ s/%MENU/$themenu\n/; 
        $line =~ s/%FOOTMENU/$footindex/; 
        $line =~ s/%F/$mdate/; 
        $line =~ s/%HEXCOLOUR/$hexcolour/; 
        $line =~ s/%COLOUR/$thecolour/; 
        $line =~ s/%NEWS//; 
        $line =~ s/%N/$htmlfile/; 
        $temp[$count++] = $line;
    } 
    print HTMLOUT @temp;
} 
