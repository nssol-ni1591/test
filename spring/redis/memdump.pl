#!/usr/bin/perl

use warnings;
use strict;

my %HASH = ();

sub now {
	my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime;
	$sec = "0".$sec if $sec < 10;
	$min = "0".$min if ++$min < 10;
	$hour = "0".$hour if $hour < 10;
	$mday = "0".$mday if $mday < 10;
	$mon = "0".$mon if $mon < 10;
	return ($year + 1900)."-$mon-$mday $hour:$min:$sec";
}

sub error {
	for my $msg (@_) {
		print ::now." [Error] $msg\n";
	}
	exit 1;
}
sub warning {
	for my $msg (@_) {
		print ::now." [Warning] $msg\n";
	}
}

my @TYPES = ('day', 'time', 'lists', 'hashs', 'strings', 'streams', 'sets', 'zsets');

sub out {
	my ($map) = @_;
	my @values = ();
	push @values, $map->{$_} foreach (@TYPES);
	print "".(join "\t", @values)."\n";
}

sub main {
	my %map = ();
	print "".(join "\t", (@TYPES))."\n";

	while (<STDIN>) {
		chomp;

		if (/^(\d+) (\w+) with (\d+) bytes \([\S ]+\)$/) {
			my ($num, $type, $size) = ($1, $2, $3);
			$map{$type} = $size;
		}
		elsif (/^DATE: ([\w\-]+)_([\w:]+)$/) {
			my ($day, $time) = ($1, $2);

			out \%map if %map;
			%map = ();

			$map{day} = $day;
			$map{time} = $time;
		}
		else {
#			error "nomatch pattern [$_]";
		}
	}
}

main;
1;
