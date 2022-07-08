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
	"auth",
	"type",
	"username",
	"password",
	"driverClassName",
	"url",

	"initialSize",
	"minIdle",
	"maxActive",

	"testOnBorrow",
	"validationQuery",
	"validationInterval",
	"validationQueryTimeout",
	"testWhileIdle",
	"timeBetweenEvictionRunsMillis",
);

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
sub info {
	for my $msg (@_) {
#		print STDERR "$msg\n";
	}
}

sub main {
	my ($file) = @_;

	my %params = ("auth" => "Container",
		"type" => "javax.sql.DataSource",
	);
	my $in_property = 0;
	my $prop_name;

	open my $in, "$file" or die "open: $!";
	while (<$in>) {
#		chomp;

		s/^\s*(\S*)\s*$/$1/;

#		next if (/^<\?xml/);
#		next if (/^<jdbc-data-source/);
#		next if (/<datasource-type>/);
#		next if (/<\/?jdbc-driver-params>/);
#		next if (//);

		if ($in_property) {
			if (/<\/property>/) {
				$in_property = 0;
			}
			else {
				if (/<name>([\S ]+)<\/name>/) {
					$prop_name = $1;
				}
				elsif (/<value>([\S ]+)<\/value>/) {
					if ($prop_name eq "user") {
						$params{"username"} = $1;
					}
					$prop_name = "";
				}
			}
			next;
		}

		my $p = $_;
		my @match = grep { $p =~ /$_/ } keys %TAGS;
		if (@match) {
			::info "OK: @match";

			$p = $match[0];
			my $tag = $TAGS{$p};
			next if (!$tag);

			if (/<[^>]+>([\S ]+)<[^<>]+>/) {
				my $value = $1;
				::info "tag=[$tag] value=[$value]";
				if ($tag eq "validationQuery") {
					$params{$tag} = "\"$value\"";
				}
				elsif ($tag eq "timeBetweenEvictionRunsMillis" and !$value) {
					$params{$tag} = 60000;
				}
				elsif ($tag eq "validationInterval" 
					or $tag eq "validationQueryTimeout"
					or $tag eq "timeBetweenEvictionRunsMillis") {
					$params{$tag} = $value * 1000;
				}
				else {
					$params{$tag} = $value;
				}
			}
			else {
				::error "xml format (rec=[$_])";
			}
		}
		elsif ($_ =~ /<property>/) {
			$in_property = 1;
		}
		else {
			::info "NG: $_";
		}
	}
	close $in;

#	for my $key (sort keys %params) {
#		print "$key : $params{$key}\n";
#	}
	my @array = ();
	push @array, $file;
	for my $key (@COLUMNS) {
		push @array, $params{$key};
	}
	print (join "\t", @array);
	print "\n";
}

print "file\t".(join "\t", @COLUMNS)."\n";
for my $f (@ARGV) {
	::main $f;
}
0;
