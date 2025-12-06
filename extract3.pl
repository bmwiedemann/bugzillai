#!/usr/bin/perl -w
# zypper in perl-Email-Simple perl-JSON-XS || apt install libemail-simple-perl libjson-xs-perl
# usage: perl extract3.pl bugzilla-pkg.list > out/bugzillapkgdata.json
use strict;
use Email::Simple;
use JSON::XS;

# look for mails with "[Bug NNNNNNN] New: "

sub processbugmail($$$);

our $jsoncoder=JSON::XS->new->canonical;
my %bugid=();
while(<>) {
    chomp();
    my($bugid,$pkg)=split(' ');
    #print "$bugid\n";
    push(@{$bugid{$bugid}}, $pkg);
}
#for my $file (glob('/home/bernhard/Maildir/.opensuse.bugs/cur/1391793774.30658_0.vm12b.zq1.de:2,')) {
#for my $file (glob('/home/bernhard/Maildir/.opensuse.bugs/cur/*')) {
for my $file (glob('cache/mails/*')) {
    open(my $f, '<', $file) or die "error reading $file : $!";
    while(<$f>) {
        if(m/Subject: \[Bug (\d+)\] New: /) {
	    if($bugid{$1}) {
	       processbugmail($1, $f, $file);
	    } else {
	       last; # skip to next file
	    }
	}
    }
}

sub processbugmail($$$)
{
    my($bugid, $fd, $file)=@_;
    my @pkgs = @{$bugid{$bugid}};
    #print "$bugid @pkgs $fd $file\n";
    #system("cp", "-anl", $file, "cache/mails/");
    local $/=undef;
    my $text=<$fd>;
    my $email = Email::Simple->new($text);
    $_=$email->body;
    s/-- .*//s;
    s/(User-Agent: [^\n]*)\n([^\n]+)/$1$2/; # undo linebreak
    while(s/(Summary: [^\n]*)\n                   /$1/){}
    my $summary;
    /Summary: ([^\n]*)/ and $summary=$1;
    $summary =~s/ +$//;
    s/.*User-Agent: [^\n]*\n*//s;
    s/\@([a-z]+\.[a-z])/-at-$1/g; # hide email addrs
    my $body = $_;
    print $jsoncoder->encode({summary=>$summary, body=>$body, pkgs=>\@pkgs}),"\n";
}
