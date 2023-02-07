#!/usr/bin/perl

use warnings;
use strict;

my %HASH = ();

sub now {
	my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime;
	
	# localtime関数からは1900年から数えた年が返却される。
	$year += 1900;

	# 月は0から始まるので、表示するときは1を加える。
	$mon++;

	return "$year-$mon-$mday $hour:$min:$sec";
}

sub error {
	for my $msg (@_) {
		print STDERR ::now." [Error] $msg\n";
	}
	exit 1;
}
sub warning {
	for my $msg (@_) {
		print STDERR ::now." [Warning] $msg\n";
	}
}

sub main {
	while (<STDIN>) {
		chomp;

	#172.29.133.23 - - [13/Jun/2022:07:06:33 +0900] "GET /nci_wf_app_ns_purchase/js/outside/11/3_BWFAjax.js HTTP/1.1" 200 3350
		if (/^([\d\.]+) - - \[([\S ]+)\] "([\S ]+)" (\S+) (\S+)$/) {
			my ($ip, $date, $url, $st, $len) = ($1, $2, $3, $4, $5);
	#		print "ip=[$ip] date=[$date] url=[$url]\n";

			next if ($st != 200);
#			print "url=[$url]\n";

#			if ($url =~ /^(\w+) ([\w\/\.\-\(%\)]+|\*)(\?\S+)? ([\S]+)$/) {
			if ($url =~ /^(\w+) ([^\s\?;]+|\*)((\?|;)\S*)? ([\S]+)$/) {
				my ($method, $path, $http) = ($1, $2, $5);
	#			print "method=[$method] path=[$path] http=[$http]\n";

				next if ($method eq "OPTIONS");
				next if ($path =~ /^\/commonservices\/weblogic_chk\.html/);
				next if ($path =~ /\.cfm$/);
				next if ($path =~ /\.gif|\.GIF$/);
				next if ($path =~ /\.png|\.PNG$/);
				next if ($path =~ /\.jpg|\.JPG$/);
				next if ($path =~ /\.js$/);
				next if ($path =~ /\.css$/);

				my $context;
				if ($path =~ /^\/(\w+)\S+$/) {
					$context = $1;
				}
				else {
					error ("unknown path format",
							"  path=[$path]",
							"  rec=[$_]");

				}

				my $cnt = 0;
				$cnt = $HASH{$context};
				$HASH{$context} = ++$cnt;

#				print "path=[$path]\n";
			}
			elsif ($url eq "-") { }
			else {
				error ("unknown url format",
						"  url=[$url]",
						"  rec=[$_]");
			}
		}
		else {
			error "unknown log format (rec=[$_])";
		}
	}

	for my $context (keys %HASH) {
		print "$context\t$HASH{$context}\n";
	}
}

::main;
0;
