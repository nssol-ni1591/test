#!/usr/bin/perl

use warnings;
use strict;

my %HASH = ();

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
		print ::now." [Error] $msg\n";
	}
	exit 1;
}
sub warning {
	for my $msg (@_) {
		print ::now." [Warning] $msg\n";
	}
}

my ($pod, $pod_id, $pod_id2);
my ($heap_min, $heap_max);

my $gc_type;
my ($day_day, $day_time, $day_elaps);
my ($heap_start, $heap_end, $heap_size);
my ($meta_start, $meta_end, $meta_size);
my ($times_user, $times_sys, $times_real);

my ($young_start, $young_end, $young_size);
my ($old_start, $old_end, $old_size);
my ($tenured_start, $tenured_end, $tenured_size);

sub out {
#	print "Path:[$path] GC:[$gc_type]\n";
#	print "  Log: day=[$day_day] time=[$day_time] elaps=[$day_elaps]\n";
##	print "  YoungGen: start=[$young_start] end=[$young_end] size=[$young_size]\n";
##	print "  ParOldGen: start=[$old_start] end=[$old_end] size=[$old_size]\n";
##	print "  Tenured: start=[$tenured_start] end=[$tenured_end] size=[$tenured_size]\n";
#	print "  Heap: start=[$heap_start] end=[$heap_end] size=[$heap_size]\n";
#	print "  Metaspace: start=[$meta_start] end=[$meta_end] size=[$meta_size]\n";
#	print "  Times: user=[$times_user] sys=[$times_sys] real=[$times_real]\n";

	print "$pod,$pod_id,$pod_id2,".($heap_min/1024).",".($heap_max/1024).",$gc_type,$day_day,$day_time,$day_elaps,$heap_start,$heap_end,$heap_size,$meta_start,$meta_end,$meta_size,$times_user,$times_sys,$times_real\n";

	$gc_type = "";
	($day_day, $day_time, $day_elaps) = ("", "", "");
	($heap_start, $heap_end, $heap_size) = ("", "", "");
	($meta_start, $meta_end, $meta_size) = ("", "", "");
	($times_user, $times_sys, $times_real) = ("", "", "");
}

sub main {
	my $line = 0;
	my $file = 0;

	print "pod,pod_id,pod_id2,heap_min,heap_max,gc_type,day_day,day_time,day_elaps,heap_start,heap_end,heap_size,meta_start,meta_end,meta_size,times_user,times_sys,times_real\n";

	while (<STDIN>) {
		chomp;

# 2022-12-20T18:56:56.674+0900: 2.049: [Full GC (Ergonomics) [PSYoungGen: 7138K->5353K(137728K)] [ParOldGen: 27053K->26860K(48128K)] 34191K->32214K(185856K), [Metaspace: 15630K->15630K(1062912K)], 0.0742182 secs] [Times: user=0.18 sys=0.00, real=0.08 secs]
		if (/^([\d\-\.\+:T ]+) \[Full GC \(([\w ]+)\) \[PSYoungGen: ([\dK\->\(\) ]+)\] \[ParOldGen: ([\dK\->\(\) ]+)\] ([\w:\->\(\) ]+), \[Metaspace: ([\dK\->\(\) ]+)\], ([\d\.]+) secs\] \[Times: ([\w:\.=, ]+) secs\].$/) {
#			my @array = ($1, $2, $3, $4, $5, $6, $7, $8, $9);
#			print STDERR join(",", @array). "\n";
			my ($day, $type, $young, $old, $heap, $meta, $meta_tm, $times) = ($1, $2, $3, $4, $5, $6, $7, $8);
			$gc_type = $type;
			($day_day, $day_time, $day_elaps) = $day =~ /^([\d\-]+)T([\d\:]+)\.\d+\+0900: ([\d\.]+):$/;
#			my ($young_start, $young_end, $young_size) = $young =~ /(\d+K)\->(\d+K)\((\d+K)\)/;
#			my ($old_start, $old_end, $old_size) = $old =~ /(\d+K)\->(\d+K)\((\d+K)\)/;
			($heap_start, $heap_end, $heap_size) = $heap =~ /(\d+)K\->(\d+)K\((\d+)K\)/;
			($meta_start, $meta_end, $meta_size) = $meta =~ /(\d+)K\->(\d+)K\((\d+)K\)/;
			($times_user, $times_sys, $times_real) = $times =~ /user=([\d. ]+) sys=([\d. ]+), real=([\d. ]+)/;

#			print STDERR "$day, $wraps, $type, $young, $old, $heap, $meta, $meta_tm, $times\n";
#			print STDERR "Log: day=[$day_day] time=[$day_time] elaps=[$day_elaps]\n";
#			print STDERR "YoungGen: start=[$young_start] end=[$young_end] size=[$young_size]\n";
#			print STDERR "ParOldGen: start=[$old_start] end=[$old_end] size=[$old_size]\n";
#			print STDERR "Heap: start=[$heap_start] end=[$heap_end] size=[$heap_size]\n";
#			print STDERR "Metaspace: start=[$meta_start] end=[$meta_end] size=[$meta_size]\n";
#			print STDERR "Times: user=[$times_user] sys=[$times_sys] real=[$times_real]\n";

			out;
			++$line;
		}
# 2023-01-10T15:17:40.288+0900: 1622909.645: [Full GC (Metadata GC Threshold) 2023-01-10T15:17:40.288+0900: 1622909.645: [Tenured: 15303K->10056K(16132K), 0.0492687 secs] 21511K->10056K(23492K), [Metaspace: 27954K->27954K(1075200K)], 0.0494391 secs] [Times: user=0.05 sys=0.00, real=0.05 secs]
		elsif (/^([\d\-\.\+:T ]+) \[Full GC \(([\w ]+)\) [\d\-\.:T]+\+0900: [\d\.]+: \[Tenured: ([\dK\->\(\) ]+), ([\d\.]+) secs\] ([\dK\->\(\) ]+), \[Metaspace: ([\dK\->\(\) ]+)\], ([\d\.]+) secs\] \[Times: ([\w:\.=, ]+) secs\].$/) {
#			my @array = ($1, $2, $3, $4, $5, $6, $7, $8, $9);
#			print join(",", @array). "\n";
			my ($day, $type, $tenured, $tenured_tm, $heap, $meta, $meta_tm, $times) = ($1, $2, $3, $4, $5, $6, $7, $8);
			$gc_type = $type;
			($day_day, $day_time, $day_elaps) = $day =~ /^([\d\-]+)T([\d\:]+)\.\d+\+0900: ([\d\.]+):$/;
			($heap_start, $heap_end, $heap_size) = $heap =~ /(\d+)K\->(\d+)K\((\d+)K\)/;
			($meta_start, $meta_end, $meta_size) = $meta =~ /(\d+)K\->(\d+)K\((\d+)K\)/;
			($times_user, $times_sys, $times_real) = $times =~ /user=([\d. ]+) sys=([\d. ]+), real=([\d. ]+)/;

#			print STDERR "Log: day=[$day_day] time=[$day_time] elaps=[$day_elaps]\n";
#			print STDERR "Heap: start=[$heap_start] end=[$heap_end] size=[$heap_size]\n";
#			print STDERR "Metaspace: start=[$meta_start] end=[$meta_end] size=[$meta_size]\n";
#			print STDERR "Times: user=[$times_user] sys=[$times_sys] real=[$times_real]\n";

			out;
			++$line;
		}
# 609395714     16 -rw-rw-r--   1  java     java        12874 12月 22 15:40 ./spring-ptl/log/spring-ptl-598d4d7d9-rr7nq_gc.log
		elsif (/ \S+\/spring\-[\w\-]+\/log\/(spring\-\w+([\w\-]+)?)\-(\w+)\-(\w+)_gc.log$/) {
			($pod, $pod_id, $pod_id2) = ($1, $3, $4);
#			print STDERR "Pod: pod=[$pod] pod_id=[$pod_id] pod_id2=[$pod_id2]\n";
			++$file;
		}
		elsif (/^CommandLine flags: [\S ]+ \-XX:InitialHeapSize=(\d+) \-XX:MaxHeapSize=(\d+)/) {
			($heap_min, $heap_max) = ($1, $2);
#			print STDERR "Heap: heap_min=[$heap_min] heap_max=[$heap_max]\n";
		}
#		else {
#			error "nomatch pattern [$_]";
#		}
	}
	print STDERR "Statistics: line=[$line] file=[$file]\n"
}

main;
1;
