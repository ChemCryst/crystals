#!/usr/bin/perl
# This is the beginning.

$nscp = 0;
$scpfiles[0] = "";
@listing = glob "*.scp";


# Add names of all scripts mentioned in *.scp to scpfiles array.

foreach $scpfile (@listing) {
  open (FILE, $scpfile) || die("Can not open $scpfile: $!\n");
  while (<FILE>) {
    if ( m/(^.*\#SCRIPT \w\w*?[ '_].*$)/ ) {   # match #SCRIPT ...
      $_ = $1;
      s/\#SCRIPT (\w\w*?)[ '_].*$/$1/;
      $scpfiles[$nscp++] = $1;
    }
  }
  close FILE;
}

# Add names of all scripts mentioned in guimenu.srt to scpfiles array.

  open (FILE, "../guimenu.srt") || die("Can not open guimenu.srt: $!\n");
  while (<FILE>) {
    if ( m/(\#SCRIPT \w\w*?[ '_].*$)/ ) {
      $_ = $1;
      s/\#SCRIPT (\w\w*?)[ '_].*$/$1/;
      $scpfiles[$nscp++] = $1;
    }
  }
  close FILE;


# Loop through all script (listing array) and
# check if each script is called from somewhere (scpfiles array)

foreach $scpfile (@listing) {
   $j = 0;
   for ($i = 0; $i < $nscp ; $i++ )
   {
     if ( index("\U$scpfile\E","\U$scpfiles[$i]\E") >=0 ) {
       $j = 1;
     }
   }
   if ( $j == 0 ) { print "This file never called: $scpfile\n"; }
}

# Loop through script calls (scpfiles array) and
# check if those scripts exist (listing array).

for ($i = 0; $i < $nscp ; $i++ )
{
   $j = 0;
   foreach $scpfile (@listing) {
     if ( index("\U$scpfile\E","\U$scpfiles[$i]\E") >=0 ) { $j = 1; }
   }
   if ( $j == 0 ) { print "Reference to missing file $scpfiles[$i]\n"; }
  
}


# and this, the end.
