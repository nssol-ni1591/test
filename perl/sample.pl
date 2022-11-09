#!/usr/bin/perl

#use strict;
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

#sub print_hash1 {
#	my (%hash) = @_;
#
#	my $a = $hash{a};
#	print "print_hash1: \$a=[$a]\n";
#	my @a = @{$hash{a}};
#	print "print_hash1: \@a=[@a]\n";
#	my @b = @{$hash{b}};
#	print "print_hash1: \@b=[@b]\n";
#}
sub print_hash2 {
	my ($hash) = @_;

	print "print_hash2: \$hash=[$hash]\n";
	if (!$hash) {
		print "print_hash2: \%hash is empty\n";
		return;
	}
	elsif ($hash =~ /^HASH/) {
		# リファレンス
		my %hash = %{$hash};
	}
	else {
		print "print_hash2: \%hash is unknown type\n";
		return;
	}

	# hashはリファレンスなのでhash{a}でアクセスしても値は取得できない
	print "print_hash2: \$hash{a}=[$hash{a}] \$hash{b}=[$hash{b}]\n";
	# hash->{a}はリファレンスなので型情報、hash->{b}はコピーなので要素数
	print "print_hash2: \$hash->{a}=[$hash->{a}] \$hash->{b}=[$hash->{b}]\n";

	my @a = @{$hash->{a}};
	print "print_hash2: \@a=[@a]\n";
	my @b = $hash->{b};
	print "print_hash2: \@b=[@b]\n";
}

sub setup_hash1 {
	my ($hash1) = @_;
	print "setup_hash1: hash1=[$hash1]\n";
	my (%hash) = @_;
	print "setup_hash1: hash=[$(%hash)]\n";
# setup_hash1は引数がコピーなので、そのまま扱うことができる
	my @a = ();
	push @a, "a1";
	push @a, "a2";
	push @a, "a3";
# 配列を配列に積むときはリファレンスを使う
	$hash{a} = \@a;

	my @b = ();
	push @b, "b1";
	push @b, "b2";
#	push @b, "b3";
#	要素数が$hash{b}に設定される
	$hash{b} = @b;

	print "setup_hash1: \@a=[@a]\n";
	print "setup_hash1: \@b=[@b]\n";

	my $x = $hash{a};
	print "setup_hash1: \$x=[$x]\n";
	my @x = @{$hash{a}};
	print "setup_hash1: \@x=[@x]\n";

#	my $y = $hash->{b};
#	print "setup_hash1: \$y=[$y]\n";
#	my @y = @{$hash->{b}};
#	print "setup_hash1: \@y=[@y]\n";
}

sub setup_hash2 {
	my ($hash) = @_;

	my @a = ();
	push @a, "a1";
	push @a, "a2";
	push @a, "a3";

	my @b = ();
	push @b, "b1";
	push @b, "b2";
#	push @b, "b3";
#	print "setup_hash2: \@a=[@a] \@b=[@b]\n";

	if (!$hash) {
		print "setup_hash2:  \$hash=[$hash] \%hash is empty\n";
		my %hash = ();
		$hash{a} = \@a;
		$hash{b} = @b;
		print "setup_hash2: \$hash{a}=[$hash{a}] \@{\$hash{a}}=[@{$hash{a}}]\n";
		print "setup_hash2: \$hash{b}=[$hash{b}] \@{\$hash{b}}=[@{$hash{b}}]\n";
# 引数が実体なので返却値も実体と想定する
#		return %hash;
	}
	elsif ($hash =~ /^HASH/) {
		print "setup_hash2: \$hash=[$hash]\n";
# 引数がリファレンスなので%{}でキャストする
		my %hash = %{$hash};
# 配列を配列に積むときはリファレンスを使う
		$hash->{a} = \@a;
# リファレンスを使用しないと要素数が代入される
		$hash->{b} = @b;
		print "setup_hash2: \$hash->{a}=[$hash->{a}] \@{\$hash->{a}}=[@{$hash->{a}}]\n";
		print "setup_hash2: \$hash->{b}=[$hash->{b}] \@{\$hash->{b}}=[@{$hash->{b}}]\n";
# 引数のリファレンスを更新するパターン
#		return %hash;
	}
	elsif ($hash == 1) {
		print "setup_hash2: \$hash=[$hash] return scaler\n";
		my %hash = ();
		$hash{a} = \@a;
		$hash{b} = @b;
		print "setup_hash2: \$hash{a}=[$hash{a}] \@{\$hash{a}}=[@{$hash{a}}]\n";
		print "setup_hash2: \$hash{b}=[$hash{b}] \@{\$hash{b}}=[@{$hash{b}}]\n";
# 実体で生成して、実体のまま返却するパターン
		return %hash;
	}
	elsif ($hash == 2) {
		print "setup_hash2: \$hash=[$hash] return reference\n";
		my %hash = ();
		$hash{a} = \@a;
		$hash{b} = @b;
		print "setup_hash2: \$hash{a}=[$hash{a}] \@{\$hash{a}}=[@{$hash{a}}]\n";
		print "setup_hash2: \$hash{b}=[$hash{b}] \@{\$hash{b}}=[@{$hash{b}}]\n";
# 実体で生成して、returnでリファレンスを返却するパターン
		return \%hash;
	}
	elsif ($hash == 3) {
		print "setup_hash2: \$hash=[$hash] return reference\n";
		my $hash = {};
		$hash->{a} = \@a;
		$hash->{b} = @b;
		print "setup_hash2: \$hash->{a}=[$hash->{a}] \@{\$hash->{a}}=[@{$hash->{a}}]\n";
		print "setup_hash2: \$hash->{b}=[$hash->{b}] \@{\$hash->{b}}=[@{$hash->{b}}]\n";
# リファレンスで生成して、そのままリファレンスを返却するパターン
		return $hash;
	}
	else {
		print "setup_hash2: \$hash=[$hash] \%hash is unknown type\n";
		my %hash = ();
		$hash{a} = \@a;
		$hash{b} = @b;
		print "setup_hash2: \$hash{a}=[$hash{a}] \@{\$hash{a}}=[@{$hash{a}}]\n";
		print "setup_hash2: \$hash{b}=[$hash{b}] \@{\$hash{b}}=[@{$hash{b}}]\n";
		return %hash;
	}
}

print "---- original ----\n";
%HASH = ();
# リファレンス(\)を使うのは関数の引数として使用する場合で多重配列では使用しない
setup_hash2 \%HASH;
print "\n";

#print_hash2 \%HASH;
# $HASHの{a}が「ARRAY(0x...)」ならば、@{}でキャストすれば配列として取得できる
print "main:".__LINE__." \$HASH{a}=[$HASH{a}] \@\%HASH{a}=[@{$HASH{a}}]\n";
print "main:".__LINE__." \$HASH->{a}=[$HASH->{a}] \@\%HASH->{a}=[@{$HASH->{a}}]\n";

print "main:".__LINE__." \$HASH{b}=[$HASH{b}] \@\%HASH{b}=[@{$HASH{b}}]\n";
print "main:".__LINE__." \$HASH->{b}=[$HASH->{b}] \@\%HASH->{b}=[@{$HASH->{b}}]\n";
print "\n";

print "---- original 2 ----\n";
%HASH = ();
# 関数の引数に配列の実体を指定すると、子関数には引数のコピーが渡される
# 子関数の更新はコピーに行われるので、親に戻った時点で子関数の更新は反映されない
setup_hash2 %HASH;
print "\n";

# 引数は更新されない。つまり空のまま
print "main:".__LINE__." \$HASH{a}=[$HASH{a}] \@\%HASH{a}=[@{$HASH{a}}]\n";
print "main:".__LINE__." \$HASH->{a}=[$HASH->{a}] \@\%HASH->{a}=[@{$HASH->{a}}]\n";

print "main:".__LINE__." \$HASH{b}=[$HASH{b}] \@\%HASH{b}=[@{$HASH{b}}]\n";
print "main:".__LINE__." \$HASH->{b}=[$HASH->{b}] \@\%HASH->{b}=[@{$HASH->{b}}]\n";
print "\n";

print "---- pattern 1 ----\n";
%HASH = setup_hash2 1;
print "\n";

# $HASHの{a}が「ARRAY(0x...)」ならば、@{}でキャストすれば配列として取得できる
print "main:".__LINE__." \$HASH{a}=[$HASH{a}] \@\%HASH{a}=[@{$HASH{a}}]\n";
print "main:".__LINE__." \$HASH->{a}=[$HASH->{a}] \@\%HASH->{a}=[@{$HASH->{a}}]\n";

print "main:".__LINE__." \$HASH{b}=[$HASH{b}] \@\%HASH{b}=[@{$HASH{b}}]\n";
print "main:".__LINE__." \$HASH->{b}=[$HASH->{b}] \@\%HASH->{b}=[@{$HASH->{b}}]\n";
print "\n";

print "---- pattern 2 ----\n";
%HASH = %{setup_hash2 2};
print "\n";

# $HASHの{a}が「ARRAY(0x...)」ならば、@{}でキャストすれば配列として取得できる
print "main:".__LINE__." \$HASH{a}=[$HASH{a}] \@\%HASH{a}=[@{$HASH{a}}]\n";
print "main:".__LINE__." \$HASH->{a}=[$HASH->{a}] \@\%HASH->{a}=[@{$HASH->{a}}]\n";

print "main:".__LINE__." \$HASH{b}=[$HASH{b}] \@\%HASH{b}=[@{$HASH{b}}]\n";
print "main:".__LINE__." \$HASH->{b}=[$HASH->{b}] \@\%HASH->{b}=[@{$HASH->{b}}]\n";
print "\n";

print "---- pattern 2-2 ----\n";
$HASH = setup_hash2 2;
print "\n";

# $HASHの{a}が「ARRAY(0x...)」ならば、@{}でキャストすれば配列として取得できる
print "main:".__LINE__." \$HASH{a}=[$HASH{a}] \@\%HASH{a}=[@{$HASH{a}}]\n";
print "main:".__LINE__." \$HASH->{a}=[$HASH->{a}] \@\%HASH->{a}=[@{$HASH->{a}}]\n";
#print "main:".__LINE__." \$HASH->{'a'}=[$HASH->{'a'}] \@\%HASH->{'a'}=[@{$HASH->{'a'}}]\n";

print "main:".__LINE__." \$HASH{b}=[$HASH{b}] \@\%HASH{b}=[@{$HASH{b}}]\n";
print "main:".__LINE__." \$HASH->{b}=[$HASH->{b}] \@\%HASH->{b}=[@{$HASH->{b}}]\n";
#print "main:".__LINE__." \$HASH->{'b'}=[$HASH->{'b'}] \@\%HASH->{'b'}=[@{$HASH->{'b'}}]\n";
print "\n";

print "---- pattern 3 ----\n";
%HASH = %{setup_hash2 3};
print "\n";

# $HASHの{a}が「ARRAY(0x...)」ならば、@{}でキャストすれば配列として取得できる
print "main:".__LINE__." \$HASH{a}=[$HASH{a}] \@\%HASH{a}=[@{$HASH{a}}]\n";
print "main:".__LINE__." \$HASH->{a}=[$HASH->{a}] \@\%HASH->{a}=[@{$HASH->{a}}]\n";

print "main:".__LINE__." \$HASH{b}=[$HASH{b}] \@\%HASH{b}=[@{$HASH{b}}]\n";
print "main:".__LINE__." \$HASH->{b}=[$HASH->{b}] \@\%HASH->{b}=[@{$HASH->{b}}]\n";
print "\n";

print "---- pattern 4 ----\n";
$HASH = setup_hash2 3;
print "\n";

# $HASHの{a}が「ARRAY(0x...)」ならば、@{}でキャストすれば配列として取得できる
print "main:".__LINE__." \$HASH{a}=[$HASH{a}] \@\%HASH{a}=[@{$HASH{a}}]\n";
print "main:".__LINE__." \$HASH->{a}=[$HASH->{a}] \@\%HASH->{a}=[@{$HASH->{a}}]\n";

print "main:".__LINE__." \$HASH{b}=[$HASH{b}] \@\%HASH{b}=[@{$HASH{b}}]\n";
print "main:".__LINE__." \$HASH->{b}=[$HASH->{b}] \@\%HASH->{b}=[@{$HASH->{b}}]\n";
print "\n";

1;
