#!/usr/bin/perl

#use strict;
use warnings;

# ベースはsample.pl
# 関数の引数と返却値に実体とリファレンスを渡したときに、
# サブ側で追加した値がメイン側のコード（$hash{..} or $hash->{..}）
# の違いによる挙動を確認するためのスクリプト

my %HASH = ();

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
		return %hash;
	}
	elsif ($hash =~ /^HASH/) {
		print "setup_hash2: \$hash=[$hash]\n";
# 引数がリファレンスなので%{}でデリファレンスする
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
	elsif ($hash eq "1") {
		print "setup_hash2: \$hash=[$hash] return scaler\n";
		my %hash = ();
		$hash{a} = \@a;
		$hash{b} = @b;
		print "setup_hash2: \$hash{a}=[$hash{a}] \@{\$hash{a}}=[@{$hash{a}}]\n";
		print "setup_hash2: \$hash{b}=[$hash{b}] \@{\$hash{b}}=[@{$hash{b}}]\n";
# 実体を生成して実体のまま返却するパターン
		return %hash;
	}
	elsif ($hash eq "2") {
		print "setup_hash2: \$hash=[$hash] return reference\n";
		my %hash = ();
		$hash{a} = \@a;
		$hash{b} = @b;
		print "setup_hash2: \$hash{a}=[$hash{a}] \@{\$hash{a}}=[@{$hash{a}}]\n";
		print "setup_hash2: \$hash{b}=[$hash{b}] \@{\$hash{b}}=[@{$hash{b}}]\n";
# 実体を生成してリファレンスを返却するパターン
		return \%hash;
	}
	elsif ($hash eq "3") {
		print "setup_hash2: \$hash=[$hash] return reference\n";
		my $hash = {};
		$hash->{a} = \@a;
		$hash->{b} = @b;
		print "setup_hash2: \$hash->{a}=[$hash->{a}] \@{\$hash->{a}}=[@{$hash->{a}}]\n";
		print "setup_hash2: \$hash->{b}=[$hash->{b}] \@{\$hash->{b}}=[@{$hash->{b}}]\n";
# リファレンスで生成してリファレンスを返却するパターン
		return $hash;
	}
	else {
		print "setup_hash2: \$hash=[$hash] is scaler and return scaler\n";
		my (%hash) = @_;
		print "setup_hash2: \$hash{a}=[$hash{a}] \@{\$hash{a}}=[@{$hash{a}}]\n";
		print "setup_hash2: \$hash{b}=[$hash{b}] \@{\$hash{b}}=[@{$hash{b}}]\n";
		$hash{a} = \@a;
		$hash{b} = @b;
# 引数を実体として扱い、データを追加したのち、実体を返却する
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

print "---- pattern 1 ----\n";
# ハッシュの実体が返却される場合
%HASH = setup_hash2 "1";
print "\n";

# $HASHの{a}が「ARRAY(0x...)」ならば、@{}でキャストすれば配列として取得できる
print "main:".__LINE__." \$HASH{a}=[$HASH{a}] \@\%HASH{a}=[@{$HASH{a}}]\n";
print "main:".__LINE__." \$HASH->{a}=[$HASH->{a}] \@\%HASH->{a}=[@{$HASH->{a}}]\n";

print "main:".__LINE__." \$HASH{b}=[$HASH{b}] \@\%HASH{b}=[@{$HASH{b}}]\n";
print "main:".__LINE__." \$HASH->{b}=[$HASH->{b}] \@\%HASH->{b}=[@{$HASH->{b}}]\n";
print "\n";

print "---- pattern 2 ----\n";
# ハッシュのリファレンスが返却される場合
%HASH = %{setup_hash2 "2"};
print "\n";

# $HASHの{a}が「ARRAY(0x...)」ならば、@{}でキャストすれば配列として取得できる
print "main:".__LINE__." \$HASH{a}=[$HASH{a}] \@\%HASH{a}=[@{$HASH{a}}]\n";
print "main:".__LINE__." \$HASH->{a}=[$HASH->{a}] \@\%HASH->{a}=[@{$HASH->{a}}]\n";

print "main:".__LINE__." \$HASH{b}=[$HASH{b}] \@\%HASH{b}=[@{$HASH{b}}]\n";
print "main:".__LINE__." \$HASH->{b}=[$HASH->{b}] \@\%HASH->{b}=[@{$HASH->{b}}]\n";
print "\n";

print "---- pattern 2-2 ----\n";
# ハッシュのリファレンスが返却される場合
$HASH = setup_hash2 "2";
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
# ハッシュのリファレンスが返却される場合（その2）
%HASH = %{setup_hash2 "3"};
print "\n";

# $HASHの{a}が「ARRAY(0x...)」ならば、@{}でキャストすれば配列として取得できる
print "main:".__LINE__." \$HASH{a}=[$HASH{a}] \@\%HASH{a}=[@{$HASH{a}}]\n";
print "main:".__LINE__." \$HASH->{a}=[$HASH->{a}] \@\%HASH->{a}=[@{$HASH->{a}}]\n";

print "main:".__LINE__." \$HASH{b}=[$HASH{b}] \@\%HASH{b}=[@{$HASH{b}}]\n";
print "main:".__LINE__." \$HASH->{b}=[$HASH->{b}] \@\%HASH->{b}=[@{$HASH->{b}}]\n";
print "\n";

print "---- pattern 3-2 ----\n";
%HASH = (a=>"aaa", b=>"bbb");
# ハッシュのリファレンスが返却される場合（その2）
$HASH = setup_hash2 "3";
print "\n";

# $HASHの{a}が「ARRAY(0x...)」ならば、@{}でキャストすれば配列として取得できる
print "main:".__LINE__." \$HASH{a}=[$HASH{a}] \@\%HASH{a}=[@{$HASH{a}}]\n";
print "main:".__LINE__." \$HASH->{a}=[$HASH->{a}] \@\%HASH->{a}=[@{$HASH->{a}}]\n";

print "main:".__LINE__." \$HASH{b}=[$HASH{b}] \@\%HASH{b}=[@{$HASH{b}}]\n";
print "main:".__LINE__." \$HASH->{b}=[$HASH->{b}] \@\%HASH->{b}=[@{$HASH->{b}}]\n";
print "\n";

print "---- pattern else-1 ----\n";
# ハッシュの実体を引き渡した場合
%HASH = (a=>"aaa", b=>"bbb");
# 関数の引数に配列の実体を指定すると、関数には引数のコピーが渡される
# 子関数の更新はコピーに行われるので、親に戻った時点で子関数の更新は反映されない
setup_hash2 %HASH;
print "\n";

# 実体をアクセス=>引数に中身は更新されないので初期値のまま
print "main:".__LINE__." \$HASH{a}=[$HASH{a}] \@\%HASH{a}=[@{$HASH{a}}]\n";
# リファレンスをアクセス=>setupで追加した値が取得できる...why?
print "main:".__LINE__." \$HASH->{a}=[$HASH->{a}] \@\%HASH->{a}=[@{$HASH->{a}}]\n";

print "main:".__LINE__." \$HASH{b}=[$HASH{b}] \@\%HASH{b}=[@{$HASH{b}}]\n";
print "main:".__LINE__." \$HASH->{b}=[$HASH->{b}] \@\%HASH->{b}=[@{$HASH->{b}}]\n";
print "\n";

print "---- pattern else-2 ----\n";
# ハッシュのリファレンスを引き渡した場合
%HASH = (a=>"aaa", b=>"bbb");
# 関数の引数に配列のリファレンスを指定した場合
# 関数の更新はコピーに行われるので、親に戻った時点で%HASHを更新する
%HASH = setup_hash2 %HASH;
print "\n";

# 実体をアクセス=>引数に中身は更新されないので初期値のまま...why?
print "main:".__LINE__." \$HASH{a}=[$HASH{a}] \@\%HASH{a}=[@{$HASH{a}}]\n";
# リファレンスをアクセス=>setupで追加した値が取得できる
print "main:".__LINE__." \$HASH->{a}=[$HASH->{a}] \@\%HASH->{a}=[@{$HASH->{a}}]\n";

print "main:".__LINE__." \$HASH{b}=[$HASH{b}] \@\%HASH{b}=[@{$HASH{b}}]\n";
print "main:".__LINE__." \$HASH->{b}=[$HASH->{b}] \@\%HASH->{b}=[@{$HASH->{b}}]\n";
print "\n";
1;
