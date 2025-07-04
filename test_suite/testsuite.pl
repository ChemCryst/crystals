#!/usr/bin/perl -w

# Specify some environment variables, which can then
# be read and set as if they were program variables.

use Env qw(CRYUSEFILE CRYSDIR COMPCODE CROUTPUT);

use Getopt::Std;
my %testsuite_options=();
getopts("csl", \%testsuite_options);
$clean = 0;
$smoketest = 0;
$leave = 0;

if ( defined $testsuite_options{c} )
{
    print "\nRunning Cleanup\n";
    $clean = 1;
}
if ( defined $testsuite_options{l} )
{
    print "\nLeaving log files\n";
    $leave = 1;
}
if ( defined $testsuite_options{s} )
{
    print "\nRunning smoketest only\n" ;
    $smoketest = 1;
}

my $windows=($^O=~/Win/)?1:0;# Are we running on windows?

my $diff = "diff --strip-trailing-cr";
if ( $windows ) {
   $diff = "fc";
}

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
            "publish.cif", "RIDEH.DAT", "Script.log", "delh.tmp", "delh.dat", "perh.tmp", "histogram.dat",
			"cameron.ini", "regular.l5i", "regular.oby", "regular.dat", "fourier.map");     # to remove.

$CRYSHOME = $CRYSDIR;
$CRYSHOME =~ s/.*,//g;                 # Remove owt before comma, repeatedly.
$CRYSHOME =~ s/\\/\//g;                 # Swap backslash for forward
$CRYSEXE = $CRYSHOME . "crystals";    # Append exe name
#$CRYSEXE = $CRYSHOME . "crystalsd";  # Append debug exe name
$exitcode=0;

print (" using $CRYSEXE ");
if (-e $CRYSEXE) {
    print "which exists.\n";
} else {
    print "which does not exist! ";
    if (-e $CRYSEXE . ".exe") {
        print "But ". $CRYSEXE . ".exe does exist.\n";
	} else {
        print "And neither does ". $CRYSEXE . ".exe\n";
	}
} 

# Either clean up, or run the tests.

  if ($clean)
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



sub obscureMachinePrecision() {

    print("Post-processing $CROUTPUT\n");

	if (-e $CROUTPUT) {

        print("Copying to $CROUTPUT.temp\n");

		use File::Copy;
		$new_file = "$CROUTPUT.temp";
		copy($CROUTPUT, $new_file) or die "Copy failed: $!";
		unlink( $CROUTPUT );
		open(my $fhi, '<', "$CROUTPUT.temp") or die $!;
		open(my $fho, '>', "$CROUTPUT") or die $!;

        print("Copying back to original $CROUTPUT\n");

		while (<$fhi>) {

			my $line = $_;

	#Catch negative zero formats from MINGW compiler.
			$line =~ s/(\s)-(0+\.0*\s)/$1 $2/g;
			chomp($line);

	#  su_max shift often has too much precision to be stable across platforms
		   if($line =~ m/^(_refine_ls_shift\/su_max\s+\d+.\d\d\d\d)\d+.*$/ ) {
				  print $fho "[01] $1\n";
	# su_mean shift often has too much precision to be stable across platforms
		   } elsif($line =~ m/^(_refine_ls_shift\/su_mean\s+\d+\.\d\d\d\d).*$/ ) {
				  print $fho "[02] $1\n";
	# Some difabs output
	#   -0.0474   -0.0116    0.0017    0.0059    0.0032   -0.0036   -0.0013
		   } elsif($line =~ m/^(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d\s*$/ ) {
				  print $fho "[77] $1 $2 $3 $4 $5 $6 $7\n";
	#   -0.0474   -0.0116    0.0017    0.0059    0.0032   -0.0036   -0.0013
		   } elsif($line =~ m/^(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d\s*$/ ) {
				  print $fho "[72] $1 $2 $3 $4 $5 $6\n";
	# Some difabs output
	#   -0.0193   -0.0082   -0.0035   -0.0001    0.0030
		   } elsif($line =~ m/^(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d\s*$/ ) {
				  print $fho "[73] $1 $2 $3 $4 $5\n";
	# Some difabs output
	#   -0.0193   -0.0082   -0.0035   -0.0001    0.0030
		   } elsif($line =~ m/^(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d\s*$/ ) {
				  print $fho "[74] $1 $2 $3 $4\n";
	# Some difabs output
	#  25  0.82 0.80 0.78 0.77 0.76 0.76 0.76 0.76 0.76 0.77 0.78 0.81 0.84 0.87 0.91 0.93 0.94 0.92
		   } elsif($line =~ m/^(\s+\d+\s+0.\d)\d(\s+0.\d)\d(\s+0.\d)\d(\s+0.\d)\d(\s+0.\d)\d(\s+0.\d)\d(\s+0.\d)\d(\s+0.\d)\d(\s+0.\d)\d(\s+0.\d)\d(\s+0.\d)\d(\s+0.\d)\d(\s+0.\d)\d(\s+0.\d)\d(\s+0.\d)\d(\s+0.\d)\d(\s+0.\d)\d(\s+0.\d)\d\s*$/ ) {
				  print $fho "[75] $1$2$3$4$5$6$7$8$9$10$11$12$13$14$15$15$17$18\n";
	#  11   0.100E+01     -563  560    0    0    0 -607    0    0    0    0    0    0    0    0    0    0    0    0    0    0
		   } elsif($line =~ m/^(\s+\d+\s+0.\d\d\dE.\d\d..)\s+-?(\d+)\s+-?(\d+)\s+-?(\d+)\s+-?(\d+)\s+-?(\d+)\s+-?(\d+)\s+-?(\d+)\s+-?(\d+)\s+-?(\d+)\s+-?(\d+)\s+-?(\d+)\s+-?(\d+)\s+-?(\d+)\s+-?(\d+)\s+-?(\d+)\s+-?(\d+)\s+-?(\d+)\s+-?(\d+)\s+-?(\d+)\s+-?(\d+)\s*$/ ) {
				  print $fho "[76] $1 $2 $3 $4 $5 $6 $7 $8 $9 $10 $11 $12 $13 $14 $15 $16 $17 $18 $19 $20 $21\n";
	# Reversal stats are unstable wrt very tiny changes in shifts
		  } elsif($line =~ m/^( Reversals).*$/ ) {
				  print $fho "[03] $1\n";
	# Shift/esd stats unstable for very small shifts
	#	  } elsif($line =~ m/^( The largest \(shift\/esd\) =      0.00).*$/ ) {
	#              print $fho "[04] $1\n";
		  } elsif($line =~ m/^( The largest \(shift\/esd\) =      \d+\.\d)\d(.*)$/ ) {
				  print $fho "[05] $1 $2\n";
	# Shift/esd stats unstable
		  } elsif($line =~ m/^(All cycle\s+shift\/esd).*$/ ) {
				  print $fho "[06] $1\n";
	# Unstable appears sometimes
		  } elsif($line =~ m/^\s+Block\s+1.*$/ ) {
	#              print $fho "$1\n";
	# Unstable appears sometimes
		  } elsif($line =~ m/^\s+Param\.\s+Rel\.\s+param\.\s+Calc\.\sshift.*$/ ) {
	#              print $fho "$1\n";
	# Shift/esd stats unstable
		  } elsif($line =~ m/^( SRATIO ).*$/ ) {
	#              print $fho "$1\n"; #print nothing
	# Sum of the squares of the ratio unstable
		  } elsif($line =~ m/Sum of the squares of the ratio/ ) {
	#              print $fho "$1\n"; #print nothing
	# Overall parameter shifts " S/ESD     1           1             0.012      0.6E+03    0.8 E-02          1.4     SCALE"
	#	  } elsif($line =~ m/^(\s*S\/ESD\s+\d+\s+\d+\s+-?\d+\.\d\d\d\s+0\.\dE.\d\d\s+0\.\d)\d\d(E.\d\d\s+-?\d+\.\d)\d(.*)$/ ) {
	 #             print $fho "$1 $2 $3\n";
	# Intercycle min unstable for small shifts
		  } elsif($line =~ m/^(Inter cycle Min function          0.0).*$/ ) {
				  print $fho "[07] $1\n";
	# Chebyshev terms "   2            15599.61             1798.93      8.67"
		  } elsif($line =~ m/^(\s+\d\s+\d+\.)\d\d(\s+\d+)\d\d\.\d\d(\s+\d+\.\d\d)\s*$/ ) {
				  print $fho "[08] $1 $2"."00 $3\n";
	# Fc too much precision "      Fc           0.180888E+00   0.925735E+02"
		  } elsif($line =~ m/^(\s+Fc\s+0\.\d\d\d)\d\d\d(E.\d\d\s+0\.\d\d\d)\d\d\d(E.\d\d\s*)$/ ) {
				  print $fho "[09] $1 $2 $3\n";
	# "     2    -0.23884E-07   0.21388E-06"
	# "     3     0.75592E-08   0.13236E-06   0.12431E-06"
		  } elsif($line =~ m/^(\s+Fc\s+0\.\d\d\d)\d\d\d(E.\d\d\s+0\.\d\d\d)\d\d\d(E.\d\d\s*)$/ ) {
				  print $fho "[10] $1 $2 $3\n";

	# " Slope =    -3376.353 Intercept = 2538924.750 C-Coef=      -0.026"
		  } elsif($line =~ m/^(\s+Slope =\s+-?\d+\.\d)\d\d(\s+Intercept =\s+-?\d+)\d\.\d\d\d(\s+C-Coef=\s+-?\d+\.\d)\d\d\s*/ ) {
				  print $fho "[11] $1 $2"."0 $3\n";
	# Slope =        0.000 Intercept =       0.937 C-Coef=       0.011  #fewer leading figs on intercept
		  } elsif($line =~ m/^(\s+Slope =\s+-?\d+\.\d)\d\d(\s+Intercept =\s+-?\d+).\d\d\d(\s+C-Coef=\s+-?\d+\.\d)\d\d\s*/ ) {
				  print $fho "[11] $1 $2"."0 $3\n";
	# Flack table too much precision in Ds "   1   3   4    20.737   130.004    -4.668    -3.755     0.913"
		  } elsif($line =~ m/^((?:\s+-?\d+){3}\s+-?\d+\.\d\d)\d(\s+-?\d+\.\d\d)\d((?:\s+-?\d+\.\d\d\d){3}\s*)$/ ) {
				  print $fho "[12] $1 $2 $3\n";
	# Large shift (e.g. extparam need less precision) " LARGE     1           1             1.1      0.2E+01    0.958E+00          1.15 .*"
		   } elsif($line =~ m/^( LARGE\s+\d+\s+\d+\s+-?\d+.\d)\d\d(\s+-?0\.\dE\S\d\d\s+-?0\.\d)\d\d(E\S\d\d\s+-?\d+\.\d)\d(.*)/ ) {
				  print $fho "[13] $1 $2 $3 $4\n";
	# If tiny s/esd - cut line.	"		   S/ESD    31          31            0.000.*"
		   } elsif($line =~ m/^\s*S\/ESD\s+\d+\s+\d+\s+-?0.00.*/ ) {
		   # do nothing
	# Large s/esd                " S /ESD    45    45     0.  0 1 9       - 0 . 2E+ 0 1     0 . 1 8  7 E-01          1.03        O      8 U[11]"
		   } elsif($line =~ m/^(\s*S\/ESD\s+\d+\s+\d+\s+-?0\.\d\d\d)\d(\s+-?0\.\dE.\d\d\s+-?0\.\d\d)\d(E\S\d\d\s+)(-?\d+\.\d\d)(.*)/ ) {
   				  $spfour = sprintf "%.1f", $4;
				  print $fho "[14] $1 $2 $3 $spfour $5\n";
		   } elsif($line =~ m/^(\s*LARGE\s+\d+\s+\d+\s+-?0\.\d\d\d)\d(\s+-?0\.\dE.\d\d\s+-?0\.\d\d)\d(E\S\d\d\s+-?\d+\.\d)\d(.*)/ ) {
				  print $fho "[14a] $1 $2 $3 $4\n";
		   } elsif($line =~ m/^(\s*S\/ESD\s+\d+\s+\d+\s+-?0\.\d\d\d)\d(\s+-?0\.\dE.\d\d\s+-?0\.\d\d)\d(\s+-?\d+\.\d)\d(.*)/ ) {
				  print $fho "[15] $1 $2 $3 $4\n";
	#Layer based agreement analysis output "        -9             39        25.37        26.3       0.177E+05       0.922E+00     7.34   14.68           *      "
		   } elsif($line =~ m/^(\s+-?\d+\s+\d+\s+\d+\.\d\d\s+\d+\.\d\s+0\.\d)\d\d(E.\d\d\s+0\.\d)\d\d(E.\d\d\s+\d+\.\d)\d(\s+\d+\.\d)\d(\s+\*\s*)/ ) {
				  print $fho "[16] $1 $2 $3 $4 $5\n";
	#FO Range based agreement analysis output "                        4       293.09       298.7       0.377E+02       0.942E+00     1.90    1.96           * "
		   } elsif($line =~ m/^(\s+\d+\s+\d+\.\d\d\s+\d+\.\d\s+0\.\d\d)\d(E.\d\d\s+0\.\d)\d\d(E.\d\d\s+\d+\.)\d\d(\s+\d+\.)\d\d(\s+\.?\*\.?\s*)/ ) {
				  print $fho "[17] $1 $2 $3 $4 $5\n";
	# Fourier 'collect' edge cases  "QN        1.     0.6250    0.9375    0.2500       -1.7  Hole"
		   } elsif($line =~ m/^( QN ).*(-\d+\.\d\s+Hole\s*)/ ) { #Get rid of coords, keep height
				  print $fho "[18] $1 $2\n";
	# Fourier 'collect' edge cases  " Q        1.     0.6250    0.9375    0.2500       -1.7  Poor Shape"
		   } elsif($line =~ m/^( Q\s+\d+\.).*(\d+\.\d\s+Poor Shape\s*)/ ) { #Get rid of coords, keep height
				  print $fho "[19] $1 $2\n";
	# Fourier 'collect' edge cases
		   } elsif($line =~ m/^(\s+The deepest hole is at\s+).*/ ) { #Get rid of coords, keep message
				  print $fho "[20] $1\n";
	# " Distances about atom  Q      2.          X =  0.24208     Y = -0.12688     Z = 0.74464 "
		   } elsif($line =~ m/^(\s+Distances about atom.*X =\s+-?\d+\.\d\d\d)\d\d(\s+Y =\s+-?\d+\.\d\d\d)\d\d(\s+Z =\s+-?\d+\.\d\d\d)\d\d\s*/ ) {
				  print $fho "[21] $1 $2 $3\n";
	# Some shifts (8) [37] does better
		   } elsif($line =~ m/^(\s+\d+\.\d\d)\d\d((?:\s+-?\d+\.\d\d\d\d){7})\s*$/ ) {
				  print $fho "[22] $1 $2\n";
	# Some shifts (7)   "                     0.8165           -0.0117  -0.0117  -0.0117  -0.0117  -0.0117  -0.0117  -0.0117"
		   } elsif($line =~ m/^(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d\s*$/ ) {
				  print $fho "[23] $1 $2 $3 $4 $5 $6 $7\n";
	# "All cycle   shift/esd            0.30E-01       0.53E-04       0.10E+05"
	#	   } elsif($line =~ m/^(All cycle.*\d\.\d\dE.\d\d\s+\d\.\d)\d(E.\d\d\s+\d\.\d\dE.\d\d\s*)/ ) {
	#              print $fho "$1 $2\n";
	# " C      14.    0.0494    0.1250    0.8787    0.3510    0.1757    2.2240    Might be split"
		   } elsif($line =~ m/^(.*\d+\.\d\d\d)\d(\s+\d+\.\d\d\d)\d(\s+\d+\.\d\d\d)\d(\s+\d+\.\d\d\d)\d(\s+\d+\.\d\d\d)\d(\s+\d+\.\d\d\d)\d(\s+Might be split)\s*/ ) {
				  print $fho "[24] $1 $2 $3 $4 $5 $6 $7\n";
	# "Inter cycle shift/esd*
		   } elsif($line =~ m/^(Inter cycle shift\/esd)/ ) {
				  print $fho "[69] $1\n";
	# "Inter cycle R*                   -5.0           0.11E-02       0.10E+03"
		   } elsif($line =~ m/^(Inter cycle .*\s+-?\d+\.\d*\s+-?0\.)\d\d(E.\d\d\s+0\.\d)\d(E.\d\d\s*)/ ) {
				  print $fho "[25] $1 $2 $3\n";
	# "Inter cycle R*                   -5.0           0.11       0.10E+03"
		   } elsif($line =~ m/^(Inter cycle .*\s+-?\d+\.\d*\s+-?0\.\d)\d(\s+0\.\d)\d(E.\d\d\s*)/ ) {
				  print $fho "[26] $1 $2 $3\n";
	# "<Fo>-<Fc> =   19.479    100*(<Fo>-<Fc>)/<Fo> =    86.33"
		   } elsif($line =~ m/^(<Fo>-<Fc> =\s+\d+\.\d)\d\d(.*\d+\.)\d\d/ ) {
				  print $fho "[27] $1 $2\n";
	# "  -8   4   8    9.4    0.3   2.8 37.39     2  18   2    0.0    9.0   2.8  0.00"
	# "  -1   3  13    2.6    1.4   4.4   1.9     2   1  10    1.6    0.9   2.6   1.8"
	# "  0   1   2   -0.3   19.5  34.2 -0.01     0   2   0    5.0   20.4  26.7  0.25"
	# "[28]    0   2   1   34.0   48.1  24.3  0.      1   0   1   25.9   30.2   7.4  0."
	# "    5   0   3    0.9    0.0   1.9  78.2     0   4  19    1.2    0.0   1.9  65.6"
	# "    5   0   3    0.9    0.0   1.9  78.3     0   4  19    1.2    0.0   1.9  65.5"
	#                                5   0   3             0.9         0.0         1.9        78.3     0   4  19    1.2    0.0   1.9  65.5
		   } elsif($line =~ m/^((?:\s+-?\d{1,2}){3}\s+-?\d+\.\d\s+-?\d+\.\d\s+-?\d+\.)\d(\s+-?\d+\.)\d+((?:\s+-?\d{1,2}){3}\s+-?\d+\.\d\s+-?\d+\.\d\s+-?\d+\.)\d(\s+-?\d+\.)\d+\s*/ ) {
				  print $fho "[28] - not suitable for comparison, sort order based on small differences\n";
    # "  -2   1   2      38.92      5904.6      1166.6       121.7"
		   } elsif($line =~ m/^((?:\s+-?\d{1,2}){3}\s+\d+\.\d\d\s+\d+\.\d\s+)(\d+\.\d)(\s+\d+\.\d)\s*/ ) {
   				  $sptwo = sprintf "%.0f", $2;
				  print $fho "[94] $1$sptwo$3\n";

	# Mean shift line
	#	   } elsif($line =~ m/^ Mean\s+\d+\.\d\d\s+.*/ ) {
	#              print $fho "$1 $2\n";
	# RMS sh/esd line
		   } elsif($line =~ m/^ RMS sh\/esd\s+\d+\.\d\d\s+.*/ ) {
	#              print $fho "$1 $2\n";
	# SumFo/SumFc=  0.479   SumFoFc/SumFc^2=  0.479   SumwFoFc/SumwFc^2=  0.477
		   } elsif($line =~ m/^(SumFo\/SumFc=\s+\d+\.\d\d)\d(\s+\S+\s+\d+\.\d\d)\d(\s+\S+\s+\d+\.\d\d)\d\s*/ ) {
				  print $fho "[29] $1 $2 $3\n";
	# Min func " Minimisation function              0.946E+03         0.000E+00         0.946E+03"
		   } elsif($line =~ m/^( Minimisation function\s+\d+\.\d\d)\d(E\S\d\d\s+\d+\.\d)\d\d(E\S\d\d\s+\d+\.\d\d)\d(E\S\d\d.*)/ ) {
				  print $fho "[30] $1$2$3$4\n";
	# Shift max  "                                         0.0762   0.0487   0.0794"
		   } elsif($line =~ m/^           \s*(-?\d\.\d\d\d\d)   (-?\d\.\d\d\d\d)   (-?\d.\d\d\d\d)(\s*)/ ) {
			      $spone = sprintf "%.2f", $1;
			      $sptwo = sprintf "%.2f", $2;
			      $spthree = sprintf "%.2f", $3;
				  print $fho "[31]           $spone   $sptwo   $spthree $4\n";
	#			  print("Line edited (rule 31): $line \n");
	# Min funcs "    211786.        195909.          21729.               0.3664E+06          On scale of /FO/"
		   } elsif($line =~ m/^(\s+\d+)\d\.(\s+\d+)\d\.(\s+\d+)\d\.(\s+0\.\d\d)\d\d(E.\d\d\s+On scale of \/FO\/\s*)/ ) {
				  print $fho "[32] $1"."0 $2"."0 $3"."0 $4 $5\n";
	# Min funcs "    211786.        195909.          21729.                                   On scale of /FC/"
		   } elsif($line =~ m/^(\s+\d+)\d\d\d\.(\s+\d+)\d\d\d\.(\s+\d+)\d\d\.(\s+On scale of \/FC\/\s*)/ ) {
				  print $fho "[33] $1"."000 $2"."000 $3"."00 $4\n";
	#  "                               The rms (shift/su)  =           0.808"
	#  "                            The mean abs(shift/su) =           0.808"
		   } elsif($line =~ m/^(\s+The.*\(shift\/su\)\s+=\s+\d+\.)\d\d\d\s*/ ) {
				  print $fho "[64] $1\n";
	## TLS output "    0.000    0.000   20.047      0.002   -0.002    0.030     -0.082    0.129    0.051"
	#	   } elsif($line =~ m/^(    0.000    0.000\s+\d+.\d\d)\d(\s+.*)/ ) {
	#             print $fho "$1 $2\n";
	#TLS output "     20.047            -0.0396    0.6070    0.7937 "
		   } elsif($line =~ m/^(\s+\d+\.\d)\d\d(\s+-?\d+\.\d\d\d)\d(\s+-?\d+\.\d\d\d)\d(\s+-?\d+\.\d\d\d)\d\s*/ ) {
				  print $fho "[34] $1 $2 $3 $4\n";
	# TLS matrices
		   } elsif($line =~ m/^(\s+-?\d+\.\d\d)\d(\s+-?\d+\.\d\d)\d(\s+-?\d+\.\d)\d\d(\s+-?\d+\.\d\d)\d(\s+-?\d+\.\d\d)\d(\s+-?\d+\.\d\d)\d(\s+-?\d+\.\d\d)\d(\s+-?\d+\.\d\d)\d(\s+-?\d+\.\d\d)\d\s*/) {  #3rd element only captures 1dp in this version (cf. next version below).
				  print $fho "[35] $1 $2 $3 $4 $5 $6 $7 $8 $9\n";
	#  			  print("Line edited (rule 35) $line \n");
		   } elsif($line =~ m/^(\s+-?\d+\.\d\d)\d(\s+-?\d+\.\d\d)\d(\s+-?\d+\.\d\d)\d(\s+-?\d+\.\d\d)\d(\s+-?\d+\.\d\d)\d(\s+-?\d+\.\d\d)\d(\s+-?\d+\.\d\d)\d(\s+-?\d+\.\d\d)\d(\s+-?\d+\.\d\d)\d\s*/) {
				  print $fho "[36] $1 $2 $3 $4 $5 $6 $7 $8 $9\n";
	# List of Fx.4 x10 -. Fx.2
		   } elsif($line =~ m/^(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d\s*/) {
				  $temps = "[37] $1 $2 $3 $4 $5 $6 $7 $8 $9 $10\n";
				  $temps =~ s/(\s)-(0+\.0*\s)/$1 $2/g;
				  print $fho $temps
				  
	# List of C 1. Fx.4 x5 -. Fx.2    " C         13.    0.3844   1.0000  -0.1691  -0.2515   0.0560   0.0981"
		   } elsif($line =~ m/^(\s+\S+\s+\d+\.\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d\s*/) {
				  $temps = "[37] $1 $2 $3 $4 $5 $6\n";
				  $temps =~ s/(\s)-(0+\.0*\s)/$1 $2/g;
				  print $fho $temps
	# List of Fx.4 x11 following Maximum x.xx -> Fx.2, except first -> Fx.0
		   } elsif($line =~ m/^(.*Maximum\s+\d+\.)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d\s*/) {
				  print $fho "[70] $1 $2 $3 $4 $5 $6 $7 $8 $9 $10 $11 $12\n";
	# List of Fx.4 x11 following R.M.S. x.xx -> Fx.2, except first -> Fx.0
		   } elsif($line =~ m/^(.*R\.M\.S\.\s+\d+\.)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d\s*/) {
				  print $fho "[71] $1 $2 $3 $4 $5 $6 $7 $8 $9 $10 $11 $12\n";
	# List of 3Fx.4 x11 following spaces -> Fx.2
		   } elsif($line =~ m/^(\s+-?\d+\.\d\d)\d\d+(\s+-?\d+\.\d\d)\d\d+(\s+-?\d+\.\d\d)\d\d+\s*$/) {
				  $temps = "[89] $1 $2 $3\n";
				  $temps =~ s/(\s)-(0+\.0*\s)/$1 $2/g;
				  print $fho $temps
	#DECLINAT =    72.72     DECLINAT/100 =   0.7272
		   } elsif($line =~ m/^(.*DECLINAT.*\s*\d*)\.\d+\s+(.*\d*\.\d\d).*/ ) {
				  print $fho "[90] $1 $2\n";
	# List of Fx.4 x11 following anything -> Fx.2
		   } elsif($line =~ m/^(.*\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\d\s*/) {
				  print $fho "[38] $1 $2 $3 $4 $5 $6 $7 $8 $9 $10 $11\n";
	# List of Fx.5 x12 following anything -> Fx.2
		   } elsif($line =~ m/^(.*\s+-?\d+\.\d\d)\d\d\d(\s+-?\d+\.\d\d)\d\d\d(\s+-?\d+\.\d\d)\d\d\d(\s+-?\d+\.\d\d)\d\d\d(\s+-?\d+\.\d\d)\d\d\d(\s+-?\d+\.\d\d)\d\d\d(\s+-?\d+\.\d\d)\d\d\d(\s+-?\d+\.\d\d)\d\d\d(\s+-?\d+\.\d\d)\d\d\d(\s+-?\d+\.\d\d)\d\d\d(\s+-?\d+\.\d\d)\d\d\d(\s+-?\d+\.\d\d)\d\d\d\s*/) {
				  print $fho "[39] $1 $2 $3 $4 $5 $6 $7 $8 $9 $10 $11 $12\n";
	# TLS matrices 2  "         4.338    -3.907     4.821                  0.8807   -0.3540    0.3147"
		   } elsif($line =~ m/^(\s+-?\d+\.\d\d)\d(\s+-?\d+\.\d\d)\d(\s+-?\d+\.\d\d)\d(\s+-?\d+\.\d\d)\d(\s+-?\d+\.\d\d)\d(\s+-?\d+\.\d\d)\d\s*/) {
				  print $fho "[40] $1 $2 $3 $4 $5 $6\n";
	# TLS matrices 3
		   } elsif($line =~ m/^(\s+-?\d+\.\d\d)\d(\s+-?\d+\.\d\d)\d(\s+-?\d+\.\d\d)\d\s*/) {
				  print $fho "[41] $1 $2 $3\n";
	# "      Mean value =   1.0000  Mean delta =   0.0000  r.m.s. delta =   0.1518"
		   } elsif($line =~ m/^(.*r\.m\.s\. delta =\s+\d+\.\d\d)\d\d\s*/) {
				  print $fho "[41] $1\n";
	# "      0.17     0.000    0.000    0.000    0.000   266.24" - don't know
	#                          "      0  . 1 7      0  . 0 0  0       0  . 0 0  0       0  . 0 0  0       0  . 0 0  0     266  .  2 4" - don't know
		   } elsif($line =~ m/^(\s+-?\d+\.\d\d\s+-?\d+\.\d\d)\d(\s+-?\d+\.\d\d)\d(\s+-?\d+\.\d\d)\d(\s+-?\d+\.\d\d)\d(\s+-?\d+)\d\d\.\d\d\s*/) {
				  print $fho "[42] $1 $2 $3 $4 $5\n";
		   } elsif($line =~ m/^(\s+-?\d+\.\d\d\s+-?\d+\.\d\d)\d(\s+-?\d+\.\d\d)\d(\s+-?\d+\.\d\d)\d(\s+-?\d+\.\d\d)\d(\s+-?\d+)\d\.\d\d\s*/) {
				  print $fho "$1 $2 $3 $4 $5\n";
	# "Resetting shift for Extinction  Shift=     299   Esd=     104.51  New shift=     143.86"
		   } elsif($line =~ m/^(.*\d+\.)\d\d(\s+Esd=\s+\d+)\d\.\d+(\s+New shift=\s+\d+.\d).*/) {
				  print $fho "[43] $1 $2 $3\n";
		   } elsif($line =~ m/^(.*\d+\.\d)\d(\s+Esd=\s+\d+\.\d)\d(.*)/) {
				  print $fho "[44] $1 $2 $3\n";
	# Weighted r
		   } elsif($line =~ m/^( Hamilton weighted R-value\s+\d+\.)\d\d\d(\s+\d+\.\d\d)\d(\s+\d+\.)\d\d\d(.*)/ ) {
				  print $fho "[45] $1 $2 $3 $4\n";
	# Large shift reset
		   } elsif($line =~ m/^(Resetting shift for Extinction  Shift=     \d*).\d*(\s+Esd=.*)/ ) {
				  print $fho "[46] $1 $2\n";
	# Large value eigenfilter precision
		   } elsif($line =~ m/^(      \d\.\d\d\d    \d\.\d\d\d    \d\.\d\d\d    \d\.\d\d\d    \d\.\d\d\d   \d\d\d\.)\d\d/ ) {
				  print $fho "[47] $1\n";
	# Large value eigenfilter max
		   } elsif($line =~ m/^( Maximum      \d\d\d\.)\d\d(   0.0000.*)/ ) {
				  print $fho "[48] $1 $2\n";
	# Large value eigenfilter output    3   H       101.      1   1    0    0    0     119.77  119.77
		   } elsif($line =~ m/^(\s+\d+\s+\w+\s+\d+\.\s+\d+\s+\d+\s+\d+\s+\d+\s+\d+\s+\d+\.\d)\d(\s+\d+\.\d)\d.*/) {
				  print $fho "[49] $1 $2\n";
	# Too much detail 9 (Print 11)
		   } elsif($line =~ m/^(\s+\d+\s+)(-?0\.\d\d\d\d\d)(E.\d\d\s+)(-?0\.\d\d\d\d\d)(E.\d\d\s+)(-?0\.\d\d\d\d\d)(E.\d\d\s+)(-?0\.\d\d\d\d\d)(E.\d\d\s+)(-?0\.\d\d\d\d\d)(E.\d\d\s+)(-?0\.\d\d\d\d\d)(E.\d\d\s+)(-?0\.\d\d\d\d\d)(E.\d\d\s+)(-?0\.\d\d\d\d\d)(E.\d\d)/) {
   				  $sptwo = sprintf "%.1f", $2;
   				  $spfour = sprintf "%.1f", $4;
   				  $spsix = sprintf "%.1f", $6;
   				  $speight = sprintf "%.1f", $8;
   				  $spten = sprintf "%.1f", $10;
   				  $sptwelve = sprintf "%.1f", $12;
   				  $spfourteen = sprintf "%.1f", $14;
   				  $spsixteen = sprintf "%.1f", $16;
				  print $fho "[50] $1$sptwo$3$spfour$5$spsix$7$speight$9$spten$11$sptwelve$13$spfourteen$15$spsixteen$17\n";
	# Too much detail 8 (Print 11)
		   } elsif($line =~ m/^(\s+\d+\s+-?0\.\d\d)\d\d\d(E.\d\d\s+-?0\.\d\d)\d\d\d(E.\d\d\s+-?0\.\d\d)\d\d\d(E.\d\d\s+-?0\.\d\d)\d\d\d(E.\d\d\s+-?0\.\d\d)\d\d\d(E.\d\d\s+-?0\.\d\d)\d\d\d(E.\d\d\s+-?0\.\d\d)\d\d\d(E.\d\d)\s*/) {
				  print $fho "[51] $1$2$3$4$5$6$7$8\n";
	# Too much detail 7
		   } elsif($line =~ m/^(\s+\d+\s+-?0\.\d\d)\d\d\d(E.\d\d\s+-?0\.\d\d)\d\d\d(E.\d\d\s+-?0\.\d\d)\d\d\d(E.\d\d\s+-?0\.\d\d)\d\d\d(E.\d\d\s+-?0\.\d\d)\d\d\d(E.\d\d\s+-?0\.\d\d)\d\d\d(E.\d\d)\s*/) {
				  print $fho "[52] $1$2$3$4$5$6$7\n";
	# Too much detail 6
		   } elsif($line =~ m/^(\s+\d+\s+-?0\.\d\d)\d\d\d(E.\d\d\s+-?0\.\d\d)\d\d\d(E.\d\d\s+-?0\.\d\d)\d\d\d(E.\d\d\s+-?0\.\d\d)\d\d\d(E.\d\d\s+-?0\.\d\d)\d\d\d(E.\d\d)\s*/) {
				  print $fho "[53] $1$2$3$4$5$6\n";
	# Too much detail 5
		   } elsif($line =~ m/^(\s+\d+\s+-?0\.\d\d)\d\d\d(E.\d\d\s+-?0\.\d\d)\d\d\d(E.\d\d\s+-?0\.\d\d)\d\d\d(E.\d\d\s+-?0\.\d\d)\d\d\d(E.\d\d)\s*/) {
				  print $fho "[54] $1$2$3$4$5\n";
	# Too much detail 4
		   } elsif($line =~ m/^(\s+\d+\s+-?0\.\d\d)\d\d\d(E.\d\d\s+-?0\.\d\d)\d\d\d(E.\d\d\s+-?0\.\d\d)\d\d\d(E.\d\d)\s*/) {
				  print $fho "[55] $1$2$3$4\n";
	# Too much detail 3
		   } elsif($line =~ m/^(\s+\d+\s+-?0\.\d\d)\d\d\d(E.\d\d\s+-?0\.\d\d)\d\d\d(E.\d\d)\s*/) {
				  print $fho "[56] $1$2$3\n";
	# Too much detail 2 (print 11)
		   } elsif($line =~ m/^(\s+\d+\s+-?0\.\d\d)\d\d\d(E.\d\d)\s*/) {
				  print $fho "[57] $1$2\n";
	# Too many sigfigs
		   } elsif($line =~ m/^(\s+PARAMETE\s+\d\.\d\d\d)\d\d(\s+-?\d\.\d\d\d)\d\d(\s*)/) {
				  print $fho "[58] $1 $2 $3\n";
	# Overall parameter shifts "     -1.185    0.000    0.000    0.000    0.000   143.87"
		  } elsif($line =~ m/^(\s{4,6}-?\d+\.\d\d)\d(    0.000    0.000    0.000    0.000\s+\d+\.\d\d\s*)$/ ) {
				  print $fho "[59] $1 $2\n";
	# Too many sigfigs on aniso
		   } elsif($line =~ m/^(\s+\w+\s+\d+\.\s+\d+\.\d+\s+\d+\.\d+\s+-?\d+\.\d\d)\d\d  #x
							   (\s+-?\d+\.\d\d)\d\d #y
							   (\s+-?\d+\.\d\d)\d\d #z
							   (\s+\d+\.\d\d)\d\d  #U11
							   (\s+\d+\.\d\d)\d\d  #U22
							   (\s+\d+\.\d\d)\d\d  #U33
							   (\s+-?\d+\.\d\d)\d\d  #U32
							   (\s+-?\d+\.\d\d)\d\d  #U31
							   (\s+-?\d+\.\d\d)\d\d.*/x )
							   {
				  print $fho "[60] $1 $2 $3 $4 $5 $6 $7 $8 $9\n";
	#    5.   5.   1.     1.85     2.86
	#    6.   2.   0.   -20.53     0.88
		   } elsif($line =~ m/^(\s+-?\d+\.\s+-?\d+\.\s+-?\d+\. #hkl
							   \s+-?\d+\.)\d\d  # fo
							   (\s+\d+\.)\d\d.*/x) # fc
							   {
				  print $fho "[61] $1 $2\n";
	# "  46.08       71.73         ************"
		   } elsif($line =~ m/^(\s+\d+\.)\d\d(\s+\d+\.)\d\d(\s+\*{12}\s+)/) {
				  print $fho "[62] $1 $2 $3\n";
	# Version number in CIF changes
		   } elsif($line =~ m/^_audit_creation_method.*$/ ) {
				  print $fho "[63] _audit_creation_method CRYSTALS\n";
	#     TOTALS          2016     96782.09     96957.7       0.105E+06       0.960E+00     3.01    6.37     .  .  *
		  } elsif($line =~ m/^(\s+TOTALS\s+\d+\s+\d+\.)\d+(\s+\d+\.)\d+(.*)$/ ) {
				  print $fho "[65] $1 $2 $3\n";
	#  Best fit this cycle:      0.017     0.298 .0 .0 .0 .333
		  } elsif($line =~ m/^(\s*Best fit this cycle.\s+\d+\.\d\d\d\s+\d+.\d)\d\d(.*)$/ ) {
				  print $fho "[66] $1 $2\n";
	#    <wdelsq> :      0.979          S :      1.013
		  } elsif($line =~ m/^(\s*<wdelsq>\s\S\s+\d+\.\d)\d\d(.*\d+\.\d).*$/ ) {
				  print $fho "[67] $1 $2\n";
	# With parameter(s) :      0.1656E-01     0.2975E+00     0.0000E+00     0.0000E+00     0.0000E+00     0.3333E+00
		  } elsif($line =~ m/^(\s*With parameter\S+\s\S\s+0\.\d\d)\d\d(E\S\d\d\s+0\.\d\d)\d\d(E\S\d\d.*)$/ ) {
				  print $fho "[67] $1 $2 $3\n";
	#     H   = 2N         1002        47.07        47.1       0.101E+06       0.106E+01     3.25    6.72           *
		  } elsif($line =~ m/^(\s*\S+\s+(?:=|#)\s\S+\s+\d+\s+\d+\.\d\d\s+\d+\.\d\s+0\.\d\d\dE\S\d\d\s+0\.\d)\d\d(E\S\d\d\s+\d+\.)\d\d(\s+\d+\.)\d\d(\s+.*)$/ ) {
				  print $fho "[68] $1 $2 $3 $4\n";
	#The minimum and maximum map densities are -0.378     0.423    electrons /A^3
		} elsif($line =~ m/^(.*The minimum and maximum map densities are\s+-?\d+\.\d\d)\d(\s+-?\d+\.\d\d)\d(.*)$/ ) {
				  print $fho "[68] $1 $2 $3\n";
	#         1  1  0  0  0    5.70E-02     5.70E-02    -3.22E-05    1.000    U33_local - <U33_local> == 0
	#         (           1   )( 2 )(    3 )(4 )(  5  )(  6  )(7                                           )
		} elsif($line =~ m/^(\s+1\s+1\s+0\s+0\s+0\s+)(-?\d+\.\d+)(E.\d+\s+)(-?\d+\.\d+)(E.\d+\s+)(-?\d+\.\d+)(E.\d+\s+)(\d+\.\d+)(.*)$/ ) {
			#               1                        2           3         4           5         6           7         8         9
				  $sptwo = sprintf "%.0f", $2;
				  $spfour = sprintf "%.0f", $4;
				  $spsix = sprintf "%.0f", $6;
				  $speight = sprintf "%.2f", $8;
			 print $fho "[79] $1$sptwo$3$spfour$5$spsix$7$speight$9\n";

	# There is an alternative to [79] with no final leverage number ($8).
		} elsif($line =~ m/^(\s+1\s+1\s+0\s+0\s+0\s+)(-?\d+\.\d+)(E.\d+\s+)(-?\d+\.\d+)(E.\d+\s+)(-?\d+\.\d+)(E.\d+\s+)(.*)$/ ) {
			#               1                        2           3         4           5         6           7         8         
				  $sptwo = sprintf "%.0f", $2;
				  $spfour = sprintf "%.0f", $4;
				  $spsix = sprintf "%.0f", $6;
			 print $fho "[78] $1$sptwo$3$spfour$5$spsix$7$8\n";

	#    } elsif($line =~ m/^(\s+1\s+1\s+0\s+0\s+0\s+-?\d+\.\d)\d(E.\d\d\s+-?\d+\.\d)\d(E.\d\d\s+-?\d+\.\d)\d(.*)$/ ) {
	#              print $fho "[78] $1$2$3$4\n";


	# (sp inverse) 1-norm:  1.85E+00 cond. number:  1.28E+01 rel. error:  1.52E-06
	   } elsif($line =~ m/^(.*norm:\s+)(-?\d+\.\d+)(.*cond\. number:\s+)(-?\d+\.\d+)(.*rel\. error:\s+)(-?\d+\.\d+)(.*)$/ ) {   #$2 and $4 hold float parts
				  $sptwo = sprintf "%.0f", $2;
				  $spfour = sprintf "%.0f", $4;
				  $spsix = sprintf "%.0f", $6;
				  print $fho "[80] $1$sptwo$3$spfour$5$spsix$7\n";
	# Block No  1.  Single precision relative error:  4.41E-05
	   } elsif($line =~ m/^(.*precision relative error:\s+)(-?\d+\.\d+)(.*)$/ ) {   #$2 hold float parts
				  $sptwo = sprintf "%.1f", $2;
				  print $fho "[80a] $1$sptwo$3\n";

	#C11 . C1 . C2 . O3 . -131.8(12)    yes
	  } elsif($line =~ m/^(.*\w* \. \w* \. \w* \. \w* \.\s+-?\d+\.).*(\(.*)$/ ) {
				  print $fho "[81] $1$2\n";
				  
	# H        102.0    1.00000        1.    0.6988   -0.1121    0.1377    0.0506
	  } elsif($line =~ m/^(\s*H\s.*\s-?\d\.\d\d)\d\d(\s*-?\d\.\d\d)\d\d(\s*-?\d\.\d\d)\d\d(\s*-?\d\.\d\d)\d\d(.*)$/ ) {
				  print $fho "[82] $1  $2  $3  $4  $5\n";

	#                    0.1000E+07                    0.4673E-03                    0.4697E-02
	  } elsif($line =~ m/^(\s*-?0\.\d\d)\d\d(E.\d\d\s*-?0\.\d\d)\d\d(E.\d\d\s*-?0\.\d\d)\d\d(E.\d\d\s*)$/ ) {
				  print $fho "[83] $1$2$3$4\n";
	# Mean C-C su =   0.0215
	  } elsif($line =~ m/^(.*Mean C-C su =\s*\d*\.\d\d).*$/ ) {
				  print $fho "[84] $1\n";
	#                 -1.3805    3.7124   18.2368             -0.16299   0.39160   0.91966
	  } elsif($line =~ m/^(\s*-?\d*\.\d\d\d)\d(\s*-?\d*\.\d\d\d)\d(\s*-?\d*\.\d\d\d)\d(\s*-?\d*\.\d\d\d)\d\d(\s*-?\d*\.\d\d\d)\d\d(\s*-?\d*\.\d\d\d)\d\d\s*/ ) {
   			      $spx = sprintf "%.2f", $1;
			      $spy = sprintf "%.2f", $2;
			      $spz = sprintf "%.2f", $3;
   			      $spa = sprintf "%.2f", $4;
			      $spb = sprintf "%.2f", $5;
			      $spc = sprintf "%.2f", $6;
				  print $fho "[85] $spx  $spy  $spz  $spa  $spb  $spc\n";

	#    0.00000            0.02964   0.39160   0.91966
	  } elsif($line =~ m/^(\s*-?\d*\.\d\d\d)\d\d(\s*-?\d*\.\d\d\d)\d\d(\s*-?\d*\.\d\d\d)\d\d(\s*-?\d*\.\d\d\d)\d\d\s*$/ ) {
 			    $spx = sprintf "%.2f", $2;
			    $spy = sprintf "%.2f", $3;
			    $spz = sprintf "%.2f", $4;
				print $fho "[86] $1  $spx  $spy  $spz\n";
				
	#<Fo>-<Fc> = -0.219    100*(<Fo>-<Fc>)/<Fo> =    -2.85
	   } elsif($line =~ m/^(\s*\<Fo\>-\<Fc\> = -?\d*\.\d\d)\d(.*)$/ ) {
				  print $fho "[91] $1$2\n";
	#Symmetry related peaks on the cusp of peak collection algorithm switch cause differences. Remove sym and coords.
	#C        11.         Q         2.      1   1    1   -1    0    0.389      Deleted    0.095   0.991   0.152      4.1
	   } elsif($line =~ m/^(.*Q\s+\d+\.\s*)-?\d+\s+-?\d+\s+-?\d+\s+-?\d+\s+-?\d+(.*Deleted).*(\d+\.\d+)$/ ) {
				  print $fho "[91] $1$2 $3\n";

	# Reduced Chisq=  1.4438
	   } elsif($line =~ m/^(.*Reduced Chisq=\s*\d*\.\d\d).*$/ ) {
				  print $fho "[88] $1\n";
	# Maximum /FO/    =     0.76E+03           Estimated variance =    1827.5     
	   } elsif($line =~ m/^(.*Maximum .FO.*\d+\.)\d+\s+$/ ) {
				  print $fho "[88] $1\n";
#	 Minimum signal : noise used =  1.1491
	   } elsif($line =~ m/^(.*Minimum signal.*\d+\.\d\d)\d+\s*$/ ) {
				  print $fho "[93] $1\n";
#  0  158      146     12          1.1491           0.000
	  } elsif($line =~ m/^(\s*\d+\s+\d+\s+\d+\s+\d+\s+\d+\.\d\d)\d\d(\s+-?\d+\.\d\d)\d\ *$/ ) {
				  print $fho "[92] $1  $2\n";

	#     7.421 * X +      -7.131 * Y +       5.978 * Z  =    -0.527
	   } elsif($line =~ m/^(\s+)(-?\d+\.\d+)(\s+\*\s+X\s\+\s+)(-?\d+\.\d+)(\s+\*\s+Y\s\+\s+)(-?\d+\.\d+)(\s+\*\s+Z\s+\=\s+)(-?\d+\.\d+)(\s+.*)$/ ) {  
	#                      1    2           3                 4           5                  6           7                8           9     
				  $spx = sprintf "%.1f", $2;
				  $spy = sprintf "%.1f", $4;
				  $spz = sprintf "%.1f", $6;
				  $spd = sprintf "%.1f", $8;
				  print $fho "[87] $1$spx$3$spy$5$spz$7$spd$9\n";
			} else {
				  print $fho "$line\n";
	#			  print ( "pass thru: $line \n" );
				  
			}
		}
		close ($fhi);
		close ($fho);
	} else {
		print $CROUTPUT . " was not created by crystals run. Check logs.";
	}
	
	#RIC Feb16 - leave this here so we can inspect the original
	#     unlink ($new_file);
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
        unlink "crfilev2.h5";
        print("Running crystals (release version) on $name.tst using $CRYSEXE \n");
        `$CRYSEXE`;                   # Run it

        print "Perl process exit code: $?\n";
		if ($? == 0) {
			print "crystals exited OK: $!\n";
		} elsif ($? == -1) {
			print "failed to execute: $!\n";
            $exitcode = 1;
		}
		elsif ($? & 127) {
			printf "crystals died with signal %d \n", ($? & 127);
            $exitcode = 1;
		}
		else {
			printf "crystals exited with value %d\n", $? >> 8;
            $exitcode = 1;
		}


        if ( not $smoketest ) {
			obscureMachinePrecision();


			if ($leave == 0) {
				print("Removing bfiles (use '-l' to leave in place)\n");
				cleanUp(@cleanup);
			}
			print ("Running $diff $CROUTPUT $COMPCODE.org/$CROUTPUT\n");

			print `$diff $CROUTPUT $COMPCODE.org/$CROUTPUT`;

			print "diff exitcode: $?\n";
			if ( "$?" != "0" ) {
			   $exitcode = 1;
			}
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
#print `compare.bat`
}
