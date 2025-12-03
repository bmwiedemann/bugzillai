#!/usr/bin/perl -w
# usage: perl extract2.pl notified.list > bugzilla-pkg.list
use strict;

our $bugid;
while(my $file=<>) {
    chomp($file);
    open(my $f, "<", "/home/bernhard/Maildir/.opensuse.bugs/cur/".$file) or die "error reading $file : $!";
    my %pkgs=();
    while(<$f>) {
	chomp;
	#print;
        if(/This bug \((\d+)\) was mentioned in/) {$bugid=$1}
        if(m,https://build.opensuse.org/request/show/\d+ \S+ / (\S+),) {
	    my $pkg=$1;
	    if($pkg=~s/=$//) {
	        my $cont=<$f>; chomp($cont);
		$pkg.=$cont;
	    }
	    $pkgs{$pkg}=1;
        }
    }
    foreach my $pkg (sort(keys(%pkgs))) {
        print "$bugid $pkg\n"
    }
}
