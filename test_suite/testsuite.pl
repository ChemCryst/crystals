#!/usr/bin/perl -w

# Specify some environment variables, which can then
# be read and set as if they were program variables.

use Env qw(CRYUSEFILE CRYSDIR COMPCODE CROUTPUT);


@files = glob("*.tst");                # List of files to run tests with.


 foreach $i (@ARGV)    {
     unless ($i =~ m/-/ ) {
       push @clfiles, $i;
     }
 }

 if ( $#clfiles > -1 ) {
     @files = @clfiles;
 }


@cleanup = ("absences.dat", "mergingr.dat", "PERH.DAT",    # List of files
            "publish.cif", "RIDEH.DAT", "Script.log");     # to remove.

$CRYSHOME = $CRYSDIR;
$CRYSHOME =~ s/.*,//g;                 # Remove owt before comma, repeatedly.
$CRYSEXE = $CRYSHOME . "crystals";    # Append exe name
$CRYSDEXE = $CRYSHOME . "crystalsd";  # Append debug exe name
$exitcode=0;

print (" using $CRYSEXE \n");

# Either clean up, or run the tests.

  if (TRUE eq contains("-c", @ARGV))
  {
    print "Doing clean up\n";
    cleanUp(@cleanup);
  }
  else
  {
    $starttime = time();
    print "Running tests...\n";
    runTest();
    print "\nTime taken: " . ( time() - $starttime ) . " seconds.\n";
  }


  exit $exitcode;

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
 # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
 # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 


sub cleanUp   # Delete unwanted output files
{
    my (@cleanUpFile) = @_;          # Set to first arg of subroutine.
    my @bfiles = glob ("bfile*.*");  # Get all the bfiles in current dir.
    push @bfiles, @cleanUpFile;      # Append list of files to delete.
    foreach $bfile (@bfiles) {
        unlink $bfile || print ("Could not delete $bfile");
    }
}

sub contains     # Is this $element in the array of tokens?
{
    my ($element, @array) = @_;
    foreach $i (@array)    {
        if ($i eq $element) { return TRUE; }
    }
    return FALSE;
}


sub runTest      # Run each .tst file through both versions of CRYSTALS.
{
    foreach $currentFileName (@files)
    {
	$CRYUSEFILE=$currentFileName;
        $name = $currentFileName;   
        $name =~ s\.tst\\g;           # Remove the .tst extension.
	
        $CROUTPUT="$name.out";        # Set environment variable
        unlink "$CROUTPUT";
        unlink "crfilev2.dsc";
        print("Running Crystals (release version) on $name.tst\n");
        `$CRYSEXE`;                   # Run it
	
        if (TRUE ne contains("-l", @ARGV)) {
            print("Removing bfiles (use '-l' to leave in place)\n");
	    cleanUp(@cleanup);
	}
        print `fc $CROUTPUT $COMPCODE.org/$CROUTPUT`;
        
        print "$?";
        if ( "$?" != "0" ) {
           $exitcode = 1;
        }	
	
#        $CROUTPUT="$name.d.out";      # Set environment variable
#        print("Deleting files... ");
# 	unlink "$CROUTPUT";
# 	unlink "crfilev2.dsc";
#        print("Running Crystals (debug version) on $name.tst\n");
#        `$CRYSDEXE`;                  # Run it
#	
#        if (TRUE ne contains("-l", @ARGV)) {
#            print("Removing bfiles (use '-l' to leave in place)\n");
#	    cleanUp(@cleanup);
#	}
#	print("Doing diff!\n");
#        print `diff $CROUTPUT $COMPCODE.org/$CROUTPUT > diffs/$name.d.diff`;
    }
}

