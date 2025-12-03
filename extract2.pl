#!/usr/bin/perl -w
# usage: perl extract2.pl notified.list > bugzilla-pkg.list
use strict;

our $bugid;
my %pkgs=();
while(my $file=<>) {
    chomp($file);
    open(my $f, "<", "/home/bernhard/Maildir/.opensuse.bugs/cur/".$file) or die "error reading $file : $!";
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
	    $pkgs{$bugid}->{$pkg}=1;
        }
    }
}
foreach my $bugid (sort {$a<=>$b} (keys(%pkgs))) {
    foreach my $pkg (sort(keys(%{$pkgs{$bugid}}))) {
        print "$bugid $pkg\n"
    }
}
