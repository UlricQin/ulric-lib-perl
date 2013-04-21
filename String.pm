#! /usr/bin/perl
#########################################
# @author Ulric<cnperl@163.com>         #
# @date 2012-11-04                      #
#########################################

package String;

use strict;
use warnings;
use Carp;

BEGIN {
    require Exporter;
    our @ISA    = qw{ Exporter };
    our @EXPORT = qw{ str_trim str_ltrim str_rtrim str_eq str_is_blank start_with contains };
}

sub str_trim {
    my $str = shift;
    confess "The str to trim is undefined" if not defined $str;

    if ( $str ne '' ) {
        $str =~ s/^\s+//;
        $str =~ s/\s+$//;
    }

    return $str;
}

sub str_ltrim {
    my $str = shift;
    confess "The str to ltrim is undefined" if not defined $str;

    if ( $str ne '' ) {
        $str =~ s/^\s+//;
    }

    return $str;
}

sub str_rtrim {
    my $str = shift;
    confess "The str to rtrim is undefined" if not defined $str;

    if ( $str ne '' ) {
        $str =~ s/\s+$//;
    }

    return $str;
}

sub str_eq {
    my ( $str1, $str2 ) = @_;
    if ( not defined $str1 and not defined $str2 ) {
        confess "The two parameters are both undefined";
    }

    if ( not defined $str1 or not defined $str2 ) {
        return 0;
    }

    return $str1 eq $str2;
}

sub str_is_blank {
    my $str = shift;
    return 1 if not defined $str;

    $str = str_trim( $str );
    return $str eq '';
}

sub start_with {
    my ( $target_str, $prefix ) = @_;
    if ( not defined $target_str or not defined $prefix ) {
        confess "One of the parameters is undefined";
    }

    my $pos = index $target_str, $prefix;
    return $pos == 0;
}

sub contains {
    my ( $target_str, $search ) = @_;
    if ( not defined $target_str or not defined $search ) {
        confess "One of the parameters is undefined";
    }

    my $pos = index $target_str, $search;
    return $pos >= 0;
}

1;
