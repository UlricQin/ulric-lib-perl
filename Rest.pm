#! /usr/bin/perl
#########################################
# @author Ulric<cnperl@163.com>         #
# @date 2013-04-08                      #
#########################################

package Rest;

use strict;
use warnings;
use Carp;
use LWP::UserAgent;

BEGIN {
    require Exporter;
    our @ISA    = qw{ Exporter };
    our @EXPORT = qw{ rest_get rest_post };
}

use Log;

sub rest_get {
    my ($url, $param) = @_;
    return _rest($url, 'get', $param);
}

sub rest_post {
    my ($url, $param) = @_;
    return _rest($url, 'post', $param);
}

sub _rest {
    my ($url, $method, $param) = @_;

    if ( not defined $url ) {
        confess("Param url is necessary");
    }

    if ( not defined $method or $method eq '' ) {
        $method = 'get';
    }

    if ( not defined($param) ) {
        $param = [];
    }

    my $browser = LWP::UserAgent->new;
    my $response;

    if ( 'get' eq lc($method) ) {
        $response = $browser->get($url, $param);
    }
    elsif ( 'post' eq lc($method) ) {
        $response = $browser->post($url, $param);
    }
    else {
        confess("method must be get or post");
    }

    if (not $response->is_success) {
        error("Get response from $url fail, status line:".$response->status_line, __FILE__, __LINE__);
        return 0;
    }

    return $response;
}

1;
