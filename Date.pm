#! /usr/bin/perl
#########################################
# @author Ulric<cnperl@163.com>         #
# @date 2012-11-05                      #
#########################################

package Date;

use strict;
use warnings;

BEGIN {
    require Exporter;
    our @ISA    = qw{ Exporter };
    our @EXPORT = qw{ today_str now_str };
}

# e.g. 2012-11-05
sub today_str {
    my $split_char = shift;
    $split_char = '-' if not defined $split_char;

    my (undef, undef, undef, $mday, $mon, $year, undef, undef, undef) = localtime(time);
    $mon = $mon + 1;
    return ($year + 1900).$split_char.($mon < 10 ? "0$mon" : $mon).$split_char.($mday < 10 ? "0$mday" : $mday);
}

# e.g. 2012-11-05 18:03:32
sub now_str {
    my $split_char = shift;
    $split_char = '-' if not defined $split_char;

    my ($sec, $min, $hour, $mday, $mon, $year, undef, undef, undef) = localtime(time);
    $mon++;
    $mon  = $mon  < 10 ? "0$mon"  : $mon;
    $mday = $mday < 10 ? "0$mday" : $mday;
    $hour = $hour < 10 ? "0$hour" : $hour;
    $min  = $min  < 10 ? "0$min"  : $min;
    $sec  = $sec  < 10 ? "0$sec"  : $sec;

    return ($year + 1900).$split_char.$mon.$split_char.$mday.' '.$hour.':'.$min.':'.$sec;
}

1;
