#! /usr/bin/perl -w
# Script for converting all crysedit include and exclude statments to C preprocessor
# if's and else's
# Usage: ./preprocessor.pl IncludeFlag ExcludeFlag CommentFlag filename

sub compare_arrays {
    my ($first, $second) = @_;

    no warnings;  # silence spurious -w undef complaints
    return 0 unless @$first == @$second;
    for (my $i = 0; $i < @$first; $i++) {
	return 0 if $first->[$i] ne $second->[$i];
    }
    return 1;
}

sub macroArray
{
    my ($macrostr) = @_;
    my @results = ();
    for (my $i = 0; $i < length($macrostr)/3; $i++)
    {
	my $macro = substr($macrostr, $i*3, 3);
	$macro =~ s/\-/_/g;
	if ($macro =~ /^[0-9]/)
	{
	    $macro = "CPU" . $macro;
	}
	push(@results, $macro);
    }
    return sort(@results);
}

sub print_defined
{
    my ($macros, $suffix, $oper) = @_;
    for (my $i = 0; $i < @$macros; $i++) {
	print $suffix . "defined(" . $macros->[$i] . ") ";
	if ($i+1 <  @$macros)
	{		    
	    print "$oper ";
	}	
    }
}

sub handle_line
{
    my ($macros, $lastMacros, $lastlineT, $suffix, $oper, $val) = @_;  
  
    if ($lastlineT == 0)
    {
	print "#if ";
	print_defined($macros, $suffix, $oper);
	print "\n";
    }
    else
    {
	if (abs($lastlineT) > 1 || !compare_arrays($macros, $lastMacros))
	{
	    print "#endif\n";
	    print "#if ";
	    print_defined($macros, $suffix, $oper);
	    print "\n";
	}
	elsif ($lastlineT != $val)
	{
	    print "#else\n";
	    $val = $val*2;
	}
    }
    return $val;
}

sub exclude
{
    my ($macros, $lastMacros, $lastlineT) = @_;
    
    return handle_line($macros, $lastMacros, $lastlineT, "!", "\&\&", -1);   
}

sub include
{
    my ($macros, $lastMacros, $lastlineT) = @_;
    return handle_line($macros, $lastMacros, $lastlineT, "", "||", 1);
}

sub print_src_line
{
    my ($line) = @_;
    #match incude macro line
    if ($line =~ /\\([A-Za-z0-9]+)\s*$/)
    {
	print "      INCLUDE '$1.INC'\n";	
    }
    else
    {
	print $line;
    }
}

@lastlineMacros = ("ds");
$lastline = 0;
if ($#ARGV == 2)
{
    $FILE = \*STDIN
}
elsif ($#ARGV == 3) 
{
    open($FILE, $ARGV[3]) || die "Problem opening file $ARGV[3]\n";
}
else
{
    die "Usage $0 includeflag excludeflag commentflag filename\n";
}

$inc = shift  @ARGV;
$excl = shift  @ARGV;
$commentRegExp = shift @ARGV;

while (<$FILE>)
{
    #match inclusion condition line
    if (/^($inc+)[A-Za-z0-9]/)
    {
	if (length($_) - 4*length($1) > 0)
	{
	    my $macros = substr($_, length($1), 3*length($1));
	    @macroArr = &macroArray($macros);
	    
	    $lastline = include(\@macroArr, \@lastlineMacros, $lastline);
	    @lastlineMacros = @macroArr;
	    print_src_line substr($_, length($1)+3*length($1));
	}
    }
    #match exclusion condition line
    elsif (/^($excl+)[A-Za-z0-9]/)
    {	
	if (length($_) - 4*length($1) > 0)
	{
	    my $macros = substr($_, length($1), 3*length($1));
	    @macroArr = &macroArray($macros);
	    
	    $lastline = exclude(\@macroArr, \@lastlineMacros, $lastline);
	    print_src_line substr($_, length($1)+3*length($1));
	    @lastlineMacros = @macroArr;
	}
    }
    #match comment line
    elsif (/$commentRegExp/)
    {
	print $_;
    }
    else
    {
	if ($lastline != 0)
	{
	    print "#endif\n"
	}
	print_src_line $_;
	@lastlineMacros = ();
	$lastline = 0;
    }
    $line = $_;
}
if ($line =~ /[^\r\n]$/)
{
    print "\n";
}
if ($lastline != 0)
{
    print "#endif\n"
}
if ($#ARGV == 3) 
{
    close FILE;
}

