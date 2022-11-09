#!/usr/bin/perl

use strict;
use warnings;

my $SELECT="spring-redis";
my $MASTER0="spring-redis-single-0";
my @TYPES = ('lists', 'hashs', 'strings', 'streams', 'sets', 'zsets');

sub now() {
	my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime;
	$sec = "0".$sec if $sec < 10;
	$min = "0".$min if ++$min < 10;
	$hour = "0".$hour if $hour < 10;
	$mday = "0".$mday if $mday < 10;
	$mon = "0".$mon if $mon < 10;
	return ($year + 1900)."-".$mon."-".$mday." ".$hour.":".$min.":".$sec;
}
sub error($) {
	print now." [Error] $_[0]\n";
	exit 1;
}

sub find_master() {
	$MASTER0=`kubectl get pods | grep $SELECT | grep '1/1' | awk '{print \$1}' | head -1`;
	chomp $MASTER0;
}

sub memkeys() {
	my %map = ();
	open my $pipe, "kubectl exec $MASTER0 -- redis-cli --memkeys |";
	while (<$pipe>) {
		chomp;
		
		if (/^(\d+) (\w+) with (\d+) bytes \([\S ]+\)$/) {
			my ($num, $type, $size) = ($1, $2, $3);
			$map{$type} = $size;
		}
	}
	return \%map;
}

my $SLEEP = 10;
$SLEEP = $ARGV[0] if ($#ARGV >= 0);

print "".(join "\t", ('time', @TYPES))."\n";
while (1) {
	my $map = memkeys;
	my @values = ();
	push @values, $map->{$_} foreach (@TYPES);
	print "".(join "\t", (now, @values))."\n";
	sleep $SLEEP;
}
1;
