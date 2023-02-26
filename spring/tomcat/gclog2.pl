#!/usr/bin/perl

use warnings;
use strict;

my %HASH = ();

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

sub init {
	($gc_type, $gc_reason) = ("", "");
	($day_day, $day_time, $day_elaps) = ("", "", "");
	($heap_start, $heap_end, $heap_size) = ("", "", "");
	($meta_start, $meta_end, $meta_size) = ("", "", "");
	($times_user, $times_sys, $times_real) = ("", "", "");
	
	($young_start, $young_end, $young_size) = ("", "", "");
	($old_start, $old_end, $old_size)  = ("", "", "");
#	($defnew_start, $defnew_end, $defnew_size) = ("", "", "");
#	($tenured_start, $tenured_end, $tenured_size) = ("", "", "");
}

sub out_gc {
#	print "$pod,$pod_id,$pod_id2,".($heap_min/1024).",".($heap_max/1024).",$gc_type,$gc_reason,$day_day,$day_time,$day_elaps,$young_start,$young_end,$young_size,$old_start,$old_end,$old_size,$heap_start,$heap_end,$heap_size,$meta_start,$meta_end,$meta_size,$times_user,$times_sys,$times_real\n";
}
sub out_fullgc {
	print "$pod,$pod_id,$pod_id2,".($heap_min/1024).",".($heap_max/1024).",$gc_type,$gc_reason,$day_day,$day_time,$day_elaps,$young_start,$young_end,$young_size,$old_start,$old_end,$old_size,$heap_start,$heap_end,$heap_size,$meta_start,$meta_end,$meta_size,$times_user,$times_sys,$times_real\n";
	init;
}

sub parse {
	my ($file) = @_;
	my $line = 0;
	init;

	open my $in, $file or die "open: $file $!";

	print "pod,pod_id,pod_id2,heap_min,heap_max,gc_type,gc_reason,day_day,day_time,day_elaps,young_start,young_end,young_size,old_start,old_end,old_size,heap_start,heap_end,heap_size,meta_start,meta_end,meta_size,times_user,times_sys,times_real\n";
	while (<$in>) {
		chomp;

#		init;

# 2023-02-06T15:30:58.568+0900: 0.180: [GC (Allocation Failure) 2023-02-06T15:30:58.568+0900: 0.180: [DefNew: 4992K->575K(5568K), 0.0041667 secs] 4992K->1515K(17856K), 0.0042324 secs] [Times: user=0.01 sys=0.00, real=0.00 secs] 
		if (/^([\d\-\.\+:T ]+) \[(\w+) \(([\w ]+)\) [\d\-\.:T]+\+0900: [\d\.]+: \[DefNew: ([\dK\->\(\) ]+), ([\d\.]+) secs\] ([\dK\->\(\) ]+), ([\d\.]+) secs\] \[Times: ([\w:\.=, ]+) secs\].\]?$/) {
			my ($day, $type, $reason, $defnew, $defnew_tm, $heap, $heap_tm, $times) = ($1, $2, $3, $4, $5, $6, $7, $8);
			$gc_type   = $type;
			$gc_reason = $reason;
			($day_day    , $day_time , $day_elaps ) = $day    =~ /^([\d\-]+)T([\d\:]+)\.\d+\+0900: ([\d\.]+):$/;
			($young_start, $young_end, $young_size) = $defnew =~ /(\d+)K\->(\d+)K\((\d+)K\)/;
			($heap_start , $heap_end , $heap_size ) = $heap   =~ /(\d+)K\->(\d+)K\((\d+)K\)/;
			($times_user , $times_sys, $times_real) = $times  =~ /user=([\d. ]+) sys=([\d. ]+), real=([\d. ]+)/;

			out_gc;
			++$line;
		}
# 2023-02-03T13:44:46.063+0900: 4.742: [GC (Allocation Failure) 2023-02-03T13:44:46.063+0900: 4.742: [DefNew: 6912K->704K(6912K), 0.0029000 secs]2023-02-03T13:44:46.066+0900: 4.745: [Tenured: 16512K->11720K(16652K), 0.0549684 secs] 21834K->11720K(23564K), [Metaspace: 22527K->22527K(1069056K)], 0.0580253 secs] [Times: user=0.04 sys=0.01, real=0.06 secs] ]
		elsif (/^([\d\-\.\+:T ]+) \[(\w+) \(([\w ]+)\) [\d\-\.:T]+\+0900: [\d\.]+: \[DefNew: ([\dK\->\(\) ]+), ([\d\.]+) secs\][\d\-\.:T]+\+0900: [\d\.]+: \[Tenured: ([\dK\->\(\) ]+), ([\d\.]+) secs\] ([\dK\->\(\) ]+), \[Metaspace: ([\dK\->\(\) ]+)\], ([\d\.]+) secs\] \[Times: ([\w:\.=, ]+) secs\].\]?$/) {
			my ($day, $type, $reason, $defnew, $defnew_tm, $tenured, $tenured_tm, $heap, $meta, $heap_tm, $times) = ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11);
			$gc_type   = $type;
			$gc_reason = $reason;
			($day_day    , $day_time , $day_elaps ) = $day     =~ /^([\d\-]+)T([\d\:]+)\.\d+\+0900: ([\d\.]+):$/;
			($young_start, $young_end, $young_size) = $defnew  =~ /(\d+)K\->(\d+)K\((\d+)K\)/;
			($old_start  , $old_end  , $old_size  ) = $tenured =~ /(\d+)K\->(\d+)K\((\d+)K\)/;
			($heap_start , $heap_end , $heap_size ) = $heap    =~ /(\d+)K\->(\d+)K\((\d+)K\)/;
			($meta_start , $meta_end , $meta_size ) = $meta    =~ /(\d+)K\->(\d+)K\((\d+)K\)/;
			($times_user , $times_sys, $times_real) = $times   =~ /user=([\d. ]+) sys=([\d. ]+), real=([\d. ]+)/;

			out_gc;
			++$line;
		}
# 2023-02-06T11:58:04.953+0900: 0.221: [GC (Allocation Failure) [PSYoungGen: 8192K->1008K(9216K)] 8192K->2182K(29696K), 0.0029798 secs] [Times: user=0.01 sys=0.00, real=0.01 secs] ]
		elsif (/^([\d\-\.\+:T ]+) \[(\w+) \(([\w ]+)\) \[PSYoungGen: ([\dK\->\(\) ]+)\] ([\dK\->\(\) ]+), ([\d\.]+) secs\] \[Times: ([\w:\.=, ]+) secs\].\]?$/) {
			my ($day, $type, $reason, $young, $heap, $heap_tm, $times) = ($1, $2, $3, $4, $5, $6, $7);
			$gc_type   = $type;
			$gc_reason = $reason;
			($day_day    , $day_time , $day_elaps ) = $day   =~ /^([\d\-]+)T([\d\:]+)\.\d+\+0900: ([\d\.]+):$/;
			($young_start, $young_end, $young_size) = $young =~ /(\d+)K\->(\d+)K\((\d+)K\)/;
			($heap_start , $heap_end , $heap_size ) = $heap  =~ /(\d+)K\->(\d+)K\((\d+)K\)/;
			($times_user , $times_sys, $times_real) = $times =~ /user=([\d. ]+) sys=([\d. ]+), real=([\d. ]+)/;

			out_gc;
			++$line;
		}
# 2022-12-20T18:56:56.674+0900: 2.049: [Full GC (Ergonomics) [PSYoungGen: 7138K->5353K(137728K)] [ParOldGen: 27053K->26860K(48128K)] 34191K->32214K(185856K), [Metaspace: 15630K->15630K(1062912K)], 0.0742182 secs] [Times: user=0.18 sys=0.00, real=0.08 secs]
		elsif (/^([\d\-\.\+:T ]+) \[([\w ]+) \(([\w ]+)\) \[PSYoungGen: ([\dK\->\(\) ]+)\] \[ParOldGen: ([\dK\->\(\) ]+)\] ([\w:\->\(\) ]+), \[Metaspace: ([\dK\->\(\) ]+)\], ([\d\.]+) secs\] \[Times: ([\w:\.=, ]+) secs\].$/) {
			my ($day, $type, $reason, $young, $old, $heap, $meta, $meta_tm, $times) = ($1, $2, $3, $4, $5, $6, $7, $8, $9);
			$gc_type   = $type;
			$gc_reason = $reason;
			($day_day    , $day_time , $day_elaps ) = $day   =~ /^([\d\-]+)T([\d\:]+)\.\d+\+0900: ([\d\.]+):$/;
			($young_start, $young_end, $young_size) = $young =~ /(\d+)K\->(\d+)K\((\d+)K\)/;
			($old_start  , $old_end  , $old_size  ) = $old =~ /(\d+)K\->(\d+)K\((\d+)K\)/;
			($heap_start , $heap_end , $heap_size ) = $heap =~ /(\d+)K\->(\d+)K\((\d+)K\)/;
			($meta_start , $meta_end , $meta_size ) = $meta =~ /(\d+)K\->(\d+)K\((\d+)K\)/;
			($times_user , $times_sys, $times_real) = $times =~ /user=([\d. ]+) sys=([\d. ]+), real=([\d. ]+)/;

			out_fullgc;
			++$line;
		}
# 2023-02-22T12:58:14.472+0900: 1.787: [Full GC (Metadata GC Threshold) 2023-02-22T12:58:14.472+0900: 1.787: [Tenured: 11047K->10467K(12288K), 0.0312261 secs] 14923K->10467K(17856K), [Metaspace: 20670K->20670K(1069056K)], 0.0313958 secs] [Times: user=0.03 sys=0.00, real=0.04 secs]
		elsif (/^([\d\-\.\+:T ]+) \[([\w ]+) \(([\w ]+)\) [\d\-\.:T]+\+0900: [\d\.]+: \[Tenured: ([\dK\->\(\) ]+), ([\d\.]+) secs\] ([\dK\->\(\) ]+), \[Metaspace: ([\dK\->\(\) ]+)\], ([\d\.]+) secs\] \[Times: ([\w:\.=, ]+) secs\].\]?$/) {
			my ($day, $type, $reason, $tenured, $tenured_tm, $heap, $meta, $meta_tm, $times) = ($1, $2, $3, $4, $5, $6, $7, $8, $9);
			$gc_type   = $type;
			$gc_reason = $reason;
			($day_day    , $day_time , $day_elaps ) = $day     =~ /^([\d\-]+)T([\d\:]+)\.\d+\+0900: ([\d\.]+):$/;
			($old_start  , $old_end  , $old_size  ) = $tenured =~ /(\d+)K\->(\d+)K\((\d+)K\)/;
			($heap_start , $heap_end , $heap_size ) = $heap    =~ /(\d+)K\->(\d+)K\((\d+)K\)/;
			($meta_start , $meta_end , $meta_size ) = $meta    =~ /(\d+)K\->(\d+)K\((\d+)K\)/;
			($times_user , $times_sys, $times_real) = $times   =~ /user=([\d. ]+) sys=([\d. ]+), real=([\d. ]+)/;

			out_fullgc;
			++$line;
		}
		elsif (/^CommandLine flags: [\S ]+ \-XX:InitialHeapSize=(\d+) \-XX:MaxHeapSize=(\d+)/) {
			($heap_min, $heap_max) = ($1, $2);
#			print STDERR "Heap: heap_min=[$heap_min] heap_max=[$heap_max]\n";
		}
		elsif (/^OpenJDK|^Memory/) { }
		else {
			error "nomatch pattern in parse [$_]";
		}
	}
	print STDERR "Statistics: line=[$line] file=[$file]\n";
	close $in;
}

sub main {
	while (<STDIN>) {
		chomp;
# 609395714     16 -rw-rw-r--   1  java     java        12874 12月 22 15:40 ./spring-ptl/log/spring-ptl-598d4d7d9-rr7nq_gc.log
#		if (/(\S+\/spring\-[\w\-]+\/log\/(spring\-\w+([\w\-]+)?)\-(\w+)\-(\w+)_gc.log)$/) {
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

main;
1;
