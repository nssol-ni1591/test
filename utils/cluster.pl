#!/usr/bin/perl

use strict;
#use warnings;

my $MASTER0="";
my %NODES=();
my %PODS=();

sub error {
        print "[Error] $_[0]\n";
        exit 1;
}

sub find_master {
#       $MASTER0=`kubectl get pods | grep spring-redis-cluster | awk '{print \$1}' | head -1`;
        $MASTER0=`kubectl get pods | grep spring-redis-cluster | grep '1/1' | awk '{print \$1}' | head -1`;
        $MASTER0="spring-redis-cluster0-0" if !${MASTER0};
        chomp $MASTER0;
}

sub pods {
        open my $pipe, "kubectl get pods -o wide | grep spring-redis-cluster |";
        while (<$pipe>) {
                chomp;
                if (/^([\w\-]+)\s+([\d\/]+)\s+(\w+)\s+\d+\s+(\w+)\s+([\d\.]+|<none>)\s+([\w\-\.]+)\s+[\w<>]+$/) {
                        my ($name, $ready, $status, $time, $ip, $node) = ($1, $2, $3, $4, $5, $6);
                        my %pod = (name=>$name, ready=>$ready, status=>$status, time=>$time, ip=>$ip, node=>$node);
#                       $pod{name} = $name;
#                       $pod{ready} = $ready;
#                       $pod{status} = $status;
#                       $pod{time} = $time;
#                       $pod{ip} = $ip;
#                       $pod{node} = $node;
                        %{$PODS{$name}} = %pod;
                }
                else {
                        ::error "unknown pod format rec=[$_]";
                }
        }
        close $pipe;
}
sub find_pod {
        my ($ip) = @_;
        for (keys %PODS) {
                if ($ip eq $PODS{$_}{ip}) {
                        return $PODS{$_};
                }
        }
        return {};
}

sub nodes() {

        open my $pipe, "kubectl exec $MASTER0 -- redis-cli cluster nodes |";
        while (<$pipe>) {
                chomp;
                if (/^(\w+) ([\d\.]+):(\d+)@\d+ ((myself,)?(master|slave),?(fail\S*)?) (-|\w+) \d+ \d+ \d+ (dis)?connected ?((\d+)-(\d+))?$/) {
                        my ($id, $ip, $port, $state, $type, $fail, $mid, $slot) = ($1, $2, $3, $4, $6, $7, $8, $10);
                        my %node = (id=>$id, ip=>$ip, port=>$port, type=>$type, fail=>$fail, mid=>$mid, slot=>$slot);
#                       $node{id} = $id;
#                       $node{ip} = $ip;
#                       $node{port} = $port;
#                       $node{type} = $type;
#                       $node{fail} = $fail;
#                       $node{mid} = $mid;
#                       $node{slot} = $slot;
                        %{$NODES{$ip}} = %node;
                }
                else {
                        ::error "unknown node format (rec=[$_])";
                }
        }
        close $pipe;
}
sub find_node {
        my ($ip) = @_;
        for (keys %NODES) {
                if ($ip eq $NODES{$_}{ip}) {
                        return $NODES{$_};
                }
        }
        return {};
}

sub printout() {
        for (sort keys %PODS) {
                my %pod = %{$PODS{$_}};
                my %node = %{find_node($pod{ip})};
                next if (defined $node{fail} and $node{fail} eq "fail");
                printf "%s: [%-15s] [%s] [%-6s] [%s] [%s] [%s]\n",
                        $pod{name}, $pod{ip}, $pod{ready}, $node{type}, $node{id}, $node{port}, $node{type} eq "master" ? $node{slot} : $node{mid};
        }
print"\n";
        my $flag = 0;
        for (keys %NODES) {
                my %node = %{$NODES{$_}};
                next if (!defined $node{fail});
                next if ($node{fail} ne "fail");
                printf "%6s: [%s] [%-15s] [%s] [%s]\n", $node{fail}, $node{id}, $node{ip}, $node{port}, $node{type};
                $flag = 1;
        }
print"\n" if $flag;
}
pods;
find_master;
nodes;
printout;
1;
