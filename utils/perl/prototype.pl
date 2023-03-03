#!/usr/bin/perl

use warnings;
use strict;

sub sub01() {
	
}
# $ ⇒ 1つのスカラー
sub sub02($) {
	
}
sub sub03($$) {
	
}
# ; ⇒ 必須引数とオプションの区切り
sub sub04($;$) {
	
}

# @ ⇒ なんでもOK（%も同じ?）
sub sub11(@) {
	
}
# \ ⇒ 引数の型を強制する
sub sub12(\@) {
	
}
# * ⇒ リファレンス、関数なども使える
sub sub13(*) {
	
}
sub sub14(\\@) {
	
}

my @a = ("a", "b", "c");


sub01;

#sub01 "a";				#Error

sub02 "a";				#Ok

sub02 "a", "b";			#Warning

#sub03 "a";				#Error

sub03 "a", "b";			#Ok

#sub03 "a", "b", "c";	#Error

sub04 "a";				#Ok

sub04 "a", "b";			#Ok

#sub04 "a", "b", "c";	#Ok


sub11 ;					#Ok

sub11 "a";				#Ok

sub11 "a", "b", "c";	#Ok

sub11 @a;				#Ok

sub11 \@a;				#Ok

#sub12;					#Error

#sub12 "a", "b", "c";	#Error

sub12 @a;				#Ok

#sub12 "a";				#Error

#sub12 \@a;				#Error

#sub13;					#Error

sub13 "a";				#Ok

#sub13 "a", "b", "c";	#Warning（引数が多すぎる）

sub13 @a;				#Ok

sub13 \@a;				#Ok

#sub14 ;				#Error

#sub14 "a";				#Error

#sub14 "a", "b", "c";	#Error

#sub14 @a;				#Error

#sub14 \@a;				#Error

