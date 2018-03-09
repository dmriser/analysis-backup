#!/usr/bin/perl

use strict;
use warnings;

if (not defined @ARGV) {die "usage: $0 <filename to be searched> <output text file name>"};

my $file    = $ARGV[0];
my $outfile = $ARGV[1];

open my $fh, '<', $file or die "can't find '$file'\n";
open my $of, '>', $outfile;

my $nFcupEntries = 0;
my $nEntries     = 0;
my $s            = 0;

while(my $line=<$fh>)
{
	 chomp $line;
	 my @strings1 = $line =~/FCUP_G2:+\s\d+/g;
	 my @strings2 = $line =~/Event:+\s+\d+/g;

	 if (scalar(@strings1) > 0)
	 {  
	     $nFcupEntries++; 
	     $s = 1;

	     foreach my $str (@strings1)
	     {
		 my ($title1, $charge) =split /\s/,$str;  
		 print $of " $charge  "; 
	     }
	 }


 	 if (scalar(@strings2) > 0 && $s eq 1)
	 {  
	     $nEntries++; 
	     
	     foreach my $str (@strings2)
	     {
		 my ($title2, $nentry) =split /\s+/,$str;  
		 print $of " $nentry \n"; 
	     }	     
	     
	     $s = 0;
	 }	 
}

print " > Found $nFcupEntries fcup and $nEntries entries. \n";

close $of;
#	 foreach my $s (@strings1){
#	     my ($name,$num) =split /\s/,$s;
#	     my ($name,$num) =split /\s+/,$s;
#	     print $of "$num \n"; 
#	     print $of "$s \n";
#	 }

#	 foreach my $s (@strings2){
#	     my ($name,$num) =split /\s/,$s;
#	     my ($name,$num) =split /\s+/,$s;
#	     print $of "$num \n"; 
#	     print $of "$s \n";
#	 }




