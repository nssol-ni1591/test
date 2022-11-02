#!/usr/bin/perl

use strict;
use warnings;


my %HASH = ();


sub print_hash0 {
	my $param = $_[0];


	if ($param =~ /^HASH/) {
		my %hash1 = %{$param};
		print "print_hash0: \$hash1=[".%hash1."]\n";	

		for my $key (keys %hash1) {
			my $val = $hash1{$key};
#			print "print_hash0: key=[$key] val=[$val]\n";
			print_hash0($val);
		}
	}
	elsif ($param =~ /^ARRAY/) {
		my @array = @{$param};
		print "print_hash0: \@array=[".@array."]\n";	

		for my $val (@array) {
#			print "print_hash0: val=[$val]\n";
			print_hash0($val);
		}
	}
	else {
		print "print_hash0: \$string=[$param]\n";	
	}
}

sub print_hash1 {
	my (%hash) = @_;

	my $a = $hash{'a'};
	print "print_hash1: \$a=[$a]\n";
	my @a = @{$hash{'a'}};
	print "print_hash1: \@a=[@a]\n";

	my @b = @{$hash{'b'}};
	print "print_hash1: \@b=[@b]\n";
	
}
sub print_hash2 {
	my ($hash) = @_;

	my %hash = %{$hash};

	my @a = @{$hash->{'a'}};
	print "print_hash2: \@a=[@a]\n";

	my @b = @{$hash->{'b'}};
	print "print_hash2: \@b=[@b]\n";
	
}

sub setup_hash1 {
	my (%hash) = @_;

	my @a = ();
	push @a, "a1";
	push @a, "a2";
	push @a, "a3";
# 配列を配列に積むときはリファレンスを使う
	$hash{'a'} = \@a;

	my @b = [];
	push @b, "b1";
	push @b, "b2";
	push @b, "b3";
	$hash{'b'} = @b;

	print "setup_hash1: \@a=[@a]\n";
	print "setup_hash1: \@b=[@b]\n";

	my $x = $hash{'a'};
	print "setup_hash1: \$x=[$x]\n";
	my @x = @{$hash{'a'}};
	print "setup_hash1: \@x=[@x]\n";

#	my $y = $hash->{'b'};
#	print "setup_hash1: \$y=[$y]\n";
#	my @y = @{$hash->{'b'}};
#	print "setup_hash1: \@y=[@y]\n";
}

sub setup_hash2 {
	my ($hash) = @_;

	my %hash = %{$hash};

	my @a = ();
	push @a, "a1";
	push @a, "a2";
	push @a, "a3";
# 配列を配列に積むときはリファレンスを使う
	$hash->{'a'} = \@a;

	my @b = ();
	push @b, "b1";
	push @b, "b2";
	push @b, "b3";
	$hash->{'b'} = \@b;

	print "setup_hash2: \@a=[@a]\n";
	print "setup_hash2: \@b=[@b]\n";

	my $x = $hash->{'a'};
	print "setup_hash2: \$x=[$x]\n";
	my @x = @{$hash->{'a'}};
	print "setup_hash2: \@x=[@x]\n";

#	my $y = $hash->{'b'};
#	print "setup_hash2: \$y=[$y]\n";
#	my @y = @{$hash->{'b'}};
#	print "setup_hash2: \@y=[@y]\n";
}

print "\n";
%HASH = ();
# リファレンス(\)を使うのは関数の引数として使用する場合で多重配列では使用しない
setup_hash2 \%HASH;
print "\n";

print "main:".__LINE__." \$HASH{a}=[$HASH{'a'}]\n";
# $変数値にARRAY(0x...)が設定されているならば@{}でキャストすれば配列になる
print "main:".__LINE__." \@\%HASH{a}=[@{$HASH{'a'}}]\n";
print_hash2 \%HASH;

print "\n";
#%HASH = ();
# 関数の引数に配列の実体を指定すると、子関数には引数のコピーが渡される
# 子関数の更新はコピーに行われるので、親に戻った時点で子関数の更新は破棄される
setup_hash1 %HASH;
print "\n";

#print "main:".__LINE__." \$HASH{a}=[$HASH{'a'}]\n";
print_hash1 %HASH;

print "\n";
#%HASH = ();
# リファレンス(\)を使うのは関数の引数として使用する場合で多重配列では使用しない
print_hash0 \%HASH;
print "\n";
1;
