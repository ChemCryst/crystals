#!/usr/bin/perl
  use Mail::Sendmail;
  use Env qw(CRYSSRC CRYSBUILD COMPCODE CRYSEMAIL);

  $numargs = $#ARGV + 1;
  $descr = "";
  $lastfile = "";
  $errfile = "";
  $errtext = "";

  if ( $numargs >= 1 ) {$descr    = $ARGV[0];}
  if ( $numargs >= 2 ) {$lastfile = $ARGV[1];}
  if ( $numargs >= 3 )
  {
     $errfile  = $ARGV[2];
 
     if (  open(DATA, "< $errfile" ) )
     {
        while ($line = <DATA>) { $errtext .= $line }
     }
     else
     {
       $errtext = "\n\n$errfile could not be opened";
     }
   }
   else
   {
      $errfile = "No errorfile specified";
      $errtext = "";
   }

   %mail=(To=>'richard.cooper@chem.ox.ac.uk',
          From=>'richard.cooper@chem.ox.ac.uk',
          Subject=>"Crystals overnight build for $COMPCODE",
          Message=>"Error description $descr\n".
                   "CRYSSRC: $CRYSSRC\n".
                   "CRYSBUILD: $CRYSBUILD\n".
                   "Last file $lastfile\n".
                   "Errors from $errfile :\n".
                   "\n\n$errtext\n");

   if ( $CRYSEMAIL =~ m/^$/ ) {
     print "No email sent\n";
   }
   else {
      sendmail(%mail) or die $Mail::Sendmail::error;
      print "OK. Log says:\n", $Mail::Sendmail::log, "\n";
   }



