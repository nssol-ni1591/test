#!/usr/bin/perl

use warnings;
use strict;

binmode STDOUT, ":crlf";

my %TAGS = (
	"jndi-name"						=> "name",
	"url"							=> "url",
	"driver-name"					=> "driverClassName",
	"password"						=> "password",				# 暗号化

	"initial-capacity"				=> "initialSize",	# 1		# initialSize: 10
	"min-capacity"					=> "minIdle",		# 1		# minIdle: maxActive
	"max-capacity"					=> "maxActive",		#15		# maxActive: 100
	"test-table-name"				=> "validationQuery",		# -		# validationQuery: select 1 from dual
	"test-frequency-seconds"		=> "validationQueryTimeout",# 900	# validationQueryTimeout: -1
	"shrink-frequency-seconds"		=> "validationInterval",	# 120	# validationInterval: 3000 
	"jndi-name"						=> "name",			# -
	"test-connections-on-reserve"	=> "testOnBorrow",	# true	# testOnBorrow: false

	"highest-num-waiters"			=> "",				# 2147483647
	"connection-creation-retry-frequency-seconds"	=> "",	# 0
	"connection-reserve-timeout-seconds"	=> "",		# 10

	"ignore-in-use-connections-enabled"		=> "testWhileIdle",		# true	# testWhileIdle: false アイドル中のコネクション検証
	"inactive-connection-timeout-seconds"	=> "timeBetweenEvictionRunsMillis",		# 0		# timeBetweenEvictionRunsMillis: 5000 アイドル中の接続検証の間隔
	"login-delay-seconds"			=> "",				# 0		# 説明が見つからない

    "statement-cache-size"			=> "",				# 10
	"statement-cache-type"			=> "",				# LRU
	"remove-infected-connections"	=> "",				# true
	"seconds-to-trust-an-idle-pool-connection"	=> "",	# 10
    "statement-timeout"				=> "",				# -1
    "pinned-to-thread"				=> "",				# false
    "wrap-types"					=> "",				# true

	"connection-harvest-max-count"			=> "",		# 1
    "connection-harvest-trigger-count"		=> "",		# -1
    "count-of-test-failures-till-flush"		=> "",		# 2
	"count-of-refresh-failures-till-disable"=> "",		# 2

## 接続テストのタイミング
	"test-connections-on-create"	=> "testOnConnect",	# false	# testOnConnect: false 接続時テスト
	"test-connections-on-release"	=> "testOnReturn",	# testOnReturn: false 返却時テスト
);

my @COLUMNS = (
	"name",
	"module-type",
	"source-path",
#	"war-name",
);

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
		print STDERR ::now." [Error] $msg\n";
	}
	exit 1;
}
sub warning {
	for my $msg (@_) {
		print STDERR ::now." [Warning] $msg\n";
	}
}
sub info {
	for my $msg (@_) {
#		print STDERR "$msg\n";
	}
}

sub main {
	my ($file) = @_;

	my %params = ();
	my $in_app_deployment = 0;

	open my $in, "$file" or die "open: $!";
	while (<$in>) {
#		chomp;

		s/^\s*(\S*)\s*$/$1/;

#		next if (/^<\?xml/);
#		next if (/^<jdbc-data-source/);
#		next if (/<datasource-type>/);
#		next if (/<\/?jdbc-driver-params>/);
#		next if (//);

		if ($in_app_deployment) {
			if (/<\/app-deployment>/) {
				$in_app_deployment = 0;

#				my $path = $params{"source-path"};
#				$path =~ s/\w*\/([\w-]+)\.war$/$1/;
#				$params{"war-name"} = $path;

				my @array = ();
				for my $key (@COLUMNS) {
					push @array, $params{$key};
				}
				print (join "\t", @array);
				print "\n";
				next;
			}

			for my $c (@COLUMNS) {
				if (/<$c>([\S ]+)<\/$c>/) {
					$params{$c} = $1;
					next;
				}
			}
		}
		elsif (/<app-deployment>/) {
			$in_app_deployment = 1;
		}
		else {
#			::info "NG: $_";
		}

	}
	close $in;

#	for my $key (sort keys %params) {
#		print "$key : $params{$key}\n";
#	}
}

print (join "\t", @COLUMNS);
print "\n";
for my $f (@ARGV) {
	::main $f;
}
0;
