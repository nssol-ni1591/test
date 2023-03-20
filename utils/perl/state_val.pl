use strict;
use warnings;
use feature 'state'; # state を使う場合に必要

{
	my $c = 0;
sub cnt {
	state $c =0;
	++$c;
	print "count=[$c]\n";
}
sub sum {
	print "  sum=[$c]\n";
}
}

cnt;
cnt;
cnt;
cnt;

sum;
