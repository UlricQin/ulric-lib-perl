#! /usr/bin/perl
##################################################
# print Error,Waring,Notice,Trace                #
# @author Ulric<cnperl@163.com>                  #
# @date 2012-11-05                               #
##################################################
package Log;

use strict;
use warnings;

BEGIN {
    require Exporter;
    our @ISA    = qw{ Exporter };
    our @EXPORT = qw{ error warning notice trace debug is_debug};
}

use Date;

my %log_config = (
    'Error'   => 1,
    'Warning' => 1,
    'Notice'  => 1,
    'Trace'   => 1,
    'Debug'   => 0,
);

sub error {
    my ($msg, $file, $line) = @_;
    _print_log($msg, $file, $line, 'Error');
}

sub warning {
    my ($msg, $file, $line) = @_;
    _print_log($msg, $file, $line, 'Warning');
}

sub notice {
    my ($msg, $file, $line) = @_;
    _print_log($msg, $file, $line, 'Notice');
}

sub trace {
    my ($msg, $file, $line) = @_;
    _print_log($msg, $file, $line, 'Trace');
}

sub debug {
    my ($msg, $file, $line) = @_;
    _print_log($msg, $file, $line, 'Debug');
}

sub _print_log {
    my ($msg, $file, $line, $level) = @_;
    if ($log_config{$level}) {
        print STDOUT '['.now_str().']'."[$level] $msg [$file:$line]\n";
    }
}

sub is_debug {
    return $log_config{'Debug'};
}

1;
