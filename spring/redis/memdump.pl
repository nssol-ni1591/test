#!/usr/bin/perl

use warnings;
use strict;

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

my @INFO_KEYS = ("connected_clients", "used_memory", "used_memory_rss_human", "used_memory_peak_human");
my @TYPES = ('day', 'time', 'lists', 'hashs', 'strings', 'streams', 'sets', 'zsets', @INFO_KEYS);

sub out {
	my ($map) = @_;
	my @values = ();
	push @values, $map->{$_} foreach (@TYPES);
#	print "".(join "\t", @values)."\n";
	print "".(join ",", @values)."\n";
}

sub main {
	my %map = ();
	my $info_flag = 0;

	print "".(join "\t", (@TYPES))."\n";

	while (<STDIN>) {
		chomp;

		if ($info_flag) {
			s/\r//g;

			if (/^INFO: end$/) {
				$info_flag = 0;
			}
			elsif (/^(\w+):([\S ]+)$/) {
				my ($key, $val) = ($1, $2);
				if (grep { $_ eq $key } @INFO_KEYS) {
					$val =~ s/M$//g if ($key =~ /^used_memory/);
					$map{$key} = $val;
				}
			}
			elsif (/^$/ or /^#/) {}
			else {
				error "nomatch pattern in INFO [$_]";
			}
		}
		elsif (/^(\d+) (\w+) with (\d+) bytes \([\S ]+\)$/) {
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
		elsif (/^INFO: start$/) {
			$info_flag = 1;
		}
		else {
#			error "nomatch pattern in main [$_]";
		}
	}
	out \%map if %map;
}

main;
1;
