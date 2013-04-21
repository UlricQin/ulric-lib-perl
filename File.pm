#! /usr/bin/perl
#########################################
# @author Ulric<cnperl@163.com>         #
# @date 2012-12-03                      #
#########################################

package File;

use strict;
use warnings;

use FileHandle;
use File::Basename;
use File::Path;
use File::Copy;
use Cwd;
use Carp;

BEGIN {
    require Exporter;
    our @ISA    = qw{ Exporter };
    our @EXPORT = qw{ basename_of close_file_ref mkpath_ex rmfile_ex mvfile rmrf md5_check filelist_of_dir files_in file_get_contents};
}

use String;
use Log;

sub basename_of {
    my $url_path = shift;
    if ( str_is_blank($url_path) ) {
        confess "The parameter url_path is blank";
    }
    return basename($url_path);
}

sub close_file_ref {
    my $fh = shift;
    if ( defined $fh ) {
        close($fh);
    }
}

# mkdir -p
# mkpath enhanced version
# if the dest dir is exists,return 0
# if not assign $mode, use default value: 0755
sub mkpath_ex {
    my ($dir, $mode) = @_;
    my $ret = -1;
    if (defined $mode) {
        $ret = mkpath($dir, 0, $mode);
    }
    else {
        $ret = mkpath($dir, 0, 0775);
    }
    if (-e $dir and -d $dir) {
        return 0;
    }
    unless ($ret =~ m/[0-9]+/) {
        error("[mkpath_ex]Internal Error:call mkpath fail", __FILE__, __LINE__);
        return -1;
    }
    return 0;
}

# rm -f /path/to/file
sub rmfile_ex {
    my $file = shift;
    if (not -e $file) {
        return 0;
    }

    my @params = ("rm", "-f", $file);
    if (system(@params) != 0) {
        error("[rmfile_ex]rm -f $file fail", __FILE__, __LINE__);
        return -1;
    }else {
        return 0;
    }
}

sub rmrf {
    my $file = shift;
    if (not -e $file) {
        return 0;
    }
    # ^_^
    if ( $file eq '/' or $file eq '/home' or $file eq '/root' or $file eq '' or $file eq '/boot') {
        error("[rmrf]rm -rf $file fail,It's too dangerous", __FILE__, __LINE__);
        return -1;
    }
    my @params = ("rm", "-r", "-f", $file);
    if ( system(@params) ) {
        error("[rmrf]rm -rf $file fail", __FILE__, __LINE__);
        return -1;
    } else {
        return 0;
    }
}

# if check success, return 1
# e.g. if ( md5_check("/path/to/file", `cat /path/to/file.md5`) ) { print "check success"; }
sub md5_check {
    my ( $to_check_file, $right_md5 ) = @_;
    if ( str_is_blank($to_check_file) or str_is_blank($right_md5) ) {
        croak('The parameter $to_check_file and $right_md5 are both necessary');
    }

    if ( not -e $to_check_file ) {
        error("[md5_check]$to_check_file is not exists", __FILE__, __LINE__);
        return 0;
    }

    my $real_md5_info = qx(md5sum "$to_check_file");
    my ($real_md5, undef) = split(/\s+/, $real_md5_info);
    
    chomp $right_md5;
    my $position = index $right_md5, " ";
    if ($position > 0) {
        ($right_md5, undef) = split(/\s+/, $right_md5);
    }

    return $right_md5 eq $real_md5;
}

# mv file to file
sub mvfile{
    my ($src, $dest) = @_;
    my $parent_dir = dirname($dest);
    my $ret;
    if (not -e $parent_dir) {
        return -1 if mkpath_ex($parent_dir);
    }
    if (not -e $src and not -l $src) {
        error("file:$src is not exists!", __FILE__, __LINE__);
        return -1;
    }
    if (-e $dest and -d $dest) {
        error("$dest is already a dir!", __FILE__, __LINE__);
        return -1;
    }
    my @params = ("mv", "-f", $src, $dest);
    if (0 != system(@params)) {
        error("mv -f $src to $dest fail!", __FILE__, __LINE__);
        return -1;
    }else {
        return 0;
    }
}

sub filelist_of_dir {
    my ($dir_path, $files_ref, $empty_dirs_ref) = @_;

    my $old_cwd =  getcwd;

    chdir $dir_path;
    my @dirs = ( './' );

    my ($dir, $file);
    while ($dir = pop(@dirs)) {
        local *DH;
        if (!opendir (DH, $dir)) {
            error("Can not open dir:$dir:$!", __FILE__, __LINE__);
            return -1;
        }
        my $file_count = 0;
        foreach (readdir(DH)) {
            if ($_ eq '.' || $_ eq '..') {
                next;
            }
            $file = $dir . $_;
            if (!-l $file && -d $file) {
                $file .= '/';
                push (@dirs, $file);
            }else {
                unshift (@$files_ref, $file);
            }
            $file_count ++;
        }
        if ($file_count == 0) {
            unshift (@$empty_dirs_ref, $dir);
        }
        closedir(DH);
    }
    chdir $old_cwd;
    return 0;
}

# no recursion
sub files_in {
    my ($dir, $files_ref)  = @_;
    if ( not defined $dir or $dir eq '' ) {
        confess("The parameter dir is necessary");
    }
    if ( not defined($files_ref) ) {
        confess("The parameter files_ref is necessary");
    }

    local *DIR;
    if ( not opendir (DIR, $dir) ) {
        error("Can not open dir:$dir:$!", __FILE__, __LINE__);
        return -1;
    }

    while (my $file = readdir(DIR)) {
        if (not -f "$dir/$file") {
            next;
        }
        push(@{$files_ref}, $file);
    }
    closedir(DIR);

    return 0;
}

sub file_get_contents {
    my $filepath = shift;
    if ( not defined $filepath ) {
        confess("[ERROR] parameter filepath is necessary");
    }
    my $ret_content;
    if ( -l $filepath ) {
        $filepath = `readlink -f $filepath`;
        chomp $filepath;
    }

    if ( -T $filepath ) {
        # TODO encoding?
        open (FILE, "<", $filepath) or die $!;
        {
            local $/=undef;
            $ret_content= <FILE>;
            close FILE;
        }
    }
    else {
        croak("[ERROR] file_get_contents need a text file");
    }

    return $ret_content;
}

1;
