#!/usr/bin/perl

use warnings;
use strict;

my $OPT_1 = 0;

sub now {
	my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime;
	$sec  = "0".$sec  if $sec < 10;
	$min  = "0".$min  if ++$min < 10;
	$hour = "0".$hour if $hour < 10;
	$mday = "0".$mday if $mday < 10;
	$mon  = "0".$mon  if $mon < 10;
	return ($year + 1900)."-$mon-$mday $hour:$min:$sec";
}

sub error {
	my $header = ::now." [Error]";
	for my $msg (@_) {
		print "$header $msg\n";
		$header = "\t";
	}
	exit 1;
}
sub warning {
	my $header = ::now." [Warning]";
	for my $msg (@_) {
		print "$header $msg\n";
		$header = "\t";
	}
}

my ($pod, $pod_id, $pod_id2);
my ($heap_min, $heap_max);

my ($gc_type, $gc_reason);
my ($day_day, $day_time, $day_elaps);
my ($heap_start, $heap_end, $heap_size);
my ($meta_start, $meta_end, $meta_size);
my ($times_user, $times_sys, $times_real);

my ($young_start, $young_end, $young_size);
my ($old_start, $old_end, $old_size);
#my ($defnew_start, $defnew_end, $defnew_size);
#my ($tenured_start, $tenured_end, $tenured_size);

my ($prev_type, $prev_reason) = ();
my ($count, $c_gc, $c_fullgc);

sub init {
#	($gc_type, $gc_reason) = ("", "");
#	($day_day, $day_time, $day_elaps) = ("", "", "");
#	($heap_start, $heap_end, $heap_size) = ("", "", "");
	($meta_start, $meta_end, $meta_size) = ("", "", "");
#	($times_user, $times_sys, $times_real) = ("", "", "");
	
	($young_start, $young_end, $young_size) = ("", "", "");
	($old_start, $old_end, $old_size)  = ("", "", "");
#	($defnew_start, $defnew_end, $defnew_size) = ("", "", "");
#	($tenured_start, $tenured_end, $tenured_size) = ("", "", "");
	$count = 0;
}

sub print_gclog {
	print "$pod,$pod_id,$pod_id2,".($heap_min/1024).",".($heap_max/1024).",$gc_type,$gc_reason,$day_day,$day_time,$day_elaps,$young_start,$young_end,$young_size,$old_start,$old_end,$old_size,$heap_start,$heap_end,$heap_size,$meta_start,$meta_end,$meta_size,$times_user,$times_sys,$times_real,$count\n";
	init;
}

sub out_gclog {
	my ($type, $reason, $day, $young, $old, $heap, $meta, $times) = @_;

	++$count;
	if ($type eq "GC") {
		++$c_gc;
	}
	elsif ($type eq "Full GC") {
		++$c_fullgc;
	}

	if (!$type and !$reason) {
		print_gclog;
		return;
	}

	if (!$prev_type and !$prev_reason) {
		($prev_type, $prev_reason) = ($type, $reason);
	}
	elsif ($type ne $prev_type or $reason ne $prev_reason) {
		print_gclog;
		($prev_type, $prev_reason) = ($type, $reason);
	}
	elsif ($prev_type eq "Full GC") {
		print_gclog;
		($prev_type, $prev_reason) = ($type, $reason);
	}
	$gc_type   = $type;
	$gc_reason = $reason;
	($day_day    , $day_time , $day_elaps ) = $day   =~ /^([\d\-]+)T([\d\:]+)\.\d+\+0900: ([\d\.]+):$/;
	($young_start, $young_end, $young_size) = $young =~ /(\d+)K\->(\d+)K\((\d+)K\)/ if ($young);
	($old_start  , $old_end  , $old_size  ) = $old   =~ /(\d+)K\->(\d+)K\((\d+)K\)/ if ($old);
	($heap_start , $heap_end , $heap_size ) = $heap  =~ /(\d+)K\->(\d+)K\((\d+)K\)/;
	($meta_start , $meta_end , $meta_size ) = $meta  =~ /(\d+)K\->(\d+)K\((\d+)K\)/ if ($meta);
	($times_user , $times_sys, $times_real) = $times =~ /user=([\d. ]+) sys=([\d. ]+), real=([\d. ]+)/;
}

sub parse {
	my ($file) = @_;
	($c_gc, $c_fullgc) = (0, 0);

	init;
	open my $in, $file or die "open: $file $!";

	print "pod,pod_id,pod_id2,heap_min,heap_max,gc_type,gc_reason,day_day,day_time,day_elaps,young_start,young_end,young_size,old_start,old_end,old_size,heap_start,heap_end,heap_size,meta_start,meta_end,meta_size,times_user,times_sys,times_real\n" if (!$OPT_1);
	while (<$in>) {
		chomp;
#--------------------------------
# 2023-02-06T15:30:58.568+0900: 0.180: [_____GC (Allocation Failure___) 2023-02-06T15:30:58.568+0900: 0.180: [DefNew_: _4992K->__575K(_5568K), 0.0041667 secs] _4992K->_1515K(17856K), ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^0.0042324 secs] [Times: user=0.01 sys=0.00, real=0.00 secs] 
# 2023-02-22T12:58:14.472+0900: 1.787: [Full GC (Metadata GC Threshold) 2023-02-22T12:58:14.472+0900: 1.787: [Tenured: 11047K->10467K(12288K), 0.0312261 secs] 14923K->10467K(17856K), [Metaspace: 20670K->20670K(1069056K)], 0.0313958 secs] [Times: user=0.03 sys=0.00, real=0.04 secs]
		if (/^([\d\-\.\+:T ]+) \[([\w ]+) \(([\w ]+)\) [\d\-\.:T]+\+0900: [\d\.]+: (\[DefNew: ([\dK\->\(\) ]+), ([\d\.]+) secs\] )?(\[Tenured: ([\dK\->\(\) ]+), ([\d\.]+) secs\] )?([\dK\->\(\) ]+), (\[Metaspace: ([\dK\->\(\) ]+\]), )?([\d\.]+) secs\] \[Times: ([\w:\.=, ]+) secs\] $/) {
			my ($day, $type, $reason, $defnew, $defnew_tm, $tenured, $tenured_tm, $heap, $meta, $heap_tm, $times) = ($1, $2, $3, $5, $6, $8, $9, $10, $12, $13, $14);
			out_gclog $type, $reason, $day, $defnew, $tenured, $heap, $meta, $times;
		}
# 2023-02-03T13:44:46.063+0900: 4.742: [GC (Allocation Failure) 2023-02-03T13:44:46.063+0900: 4.742: [DefNew: 6912K->704K(6912K), 0.0029000 secs]2023-02-03T13:44:46.066+0900: 4.745: [Tenured: 16512K->11720K(16652K), 0.0549684 secs] 21834K->11720K(23564K), [Metaspace: 22527K->22527K(1069056K)], 0.0580253 secs] [Times: user=0.04 sys=0.01, real=0.06 secs] ]
		elsif (/^([\d\-\.\+:T ]+) \[(\w+) \(([\w ]+)\) [\d\-\.:T]+\+0900: [\d\.]+: \[DefNew: ([\dK\->\(\) ]+), ([\d\.]+) secs\][\d\-\.:T]+\+0900: [\d\.]+: \[Tenured: ([\dK\->\(\) ]+), ([\d\.]+) secs\] ([\dK\->\(\) ]+), \[Metaspace: ([\dK\->\(\) ]+)\], ([\d\.]+) secs\] \[Times: ([\w:\.=, ]+) secs\].\]?$/) {
			my ($day, $type, $reason, $defnew, $defnew_tm, $tenured, $tenured_tm, $heap, $meta, $heap_tm, $times) = ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11);
			out_gclog $type, $reason, $day, $defnew, $tenured, $heap, $meta, $times;
		}

#--------------------------------
# 2023-02-06T11:58:04.953+0900: 0.221: [GC (Allocation Failure) [PSYoungGen: 8192K->1008K(9216K)] 8192K->2182K(29696K), 0.0029798 secs] [Times: user=0.01 sys=0.00, real=0.01 secs] ]
# 2022-12-20T18:56:56.674+0900: 2.049: [Full GC (Ergonomics) [PSYoungGen: 7138K->5353K(137728K)] [ParOldGen: 27053K->26860K(48128K)] 34191K->32214K(185856K), [Metaspace: 15630K->15630K(1062912K)], 0.0742182 secs] [Times: user=0.18 sys=0.00, real=0.08 secs]
		elsif (/^([\d\-\.\+:T ]+) \[([\w ]+) \(([\w ]+)\) \[PSYoungGen: ([\dK\->\(\) ]+)\] (\[ParOldGen: ([\dK\->\(\) ]+)\] )?([\w:\->\(\) ]+), (\[Metaspace: ([\dK\->\(\) ]+)\], )?([\d\.]+) secs\] \[Times: ([\w:\.=, ]+) secs\] \]?$/) {
			my ($day, $type, $reason, $young, $old, $heap, $meta, $meta_tm, $times) = ($1, $2, $3, $4, $6, $7, $9, $10, $11);
			out_gclog $type, $reason, $day, $young, $old, $heap, $meta, $times;
		}
		elsif (/^CommandLine flags: [\S ]+ \-XX:InitialHeapSize=(\d+) \-XX:MaxHeapSize=(\d+)/) {
			($heap_min, $heap_max) = ($1, $2);
		}
		elsif (/^OpenJDK|^Memory/) { }
		else {
			error "nomatch pattern in parse [$_]";
		}
	}
	out_gclog;
	close $in;
	print STDERR "  Statistics: file=[$file] GC=[$c_gc] FullGC=[$c_fullgc]\n";
}

sub main {
	print "pod,pod_id,pod_id2,heap_min,heap_max,gc_type,gc_reason,day_day,day_time,day_elaps,young_start,young_end,young_size,old_start,old_end,old_size,heap_start,heap_end,heap_size,meta_start,meta_end,meta_size,times_user,times_sys,times_real,count\n" if ($OPT_1);
	while (<STDIN>) {
		chomp;
# 609395714     16 -rw-rw-r--   1  java     java        12874 12月 22 15:40 ./spring-ptl/log/spring-ptl-598d4d7d9-rr7nq_gc.log
		if (/(\S+\/(spring\-\w+([\w\-]+)?)\-(\w+)\-(\w+)_gc.log)$/) {
			($pod, $pod_id, $pod_id2) = ($2, $4, $5);
#			print STDERR "Pod: pod=[$pod] pod_id=[$pod_id] pod_id2=[$pod_id2]\n";
			parse $1;
		}
		else {
			error "nomatch pattern in main [$_]";
		}
	}
}

foreach (@ARGV) {
	$OPT_1 = 1 if ($_ eq "-1");
}
main;
1;
