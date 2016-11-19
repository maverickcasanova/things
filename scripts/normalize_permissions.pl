#!/usr/bin/env perl

# Normalize files and dirs in current working directory to a 'umask 022' one.
# 
# Useful when one runs with umask 077 but needs a easy way to 'publish' files.
# For example, the /usr/src/ kernel sources, so the Gentoo's portage user can
# actually build kernel modules in case of FEATURES=userpriv.

use warnings;
use strict;
use File::Find;

my %modes = (
    7 => 755,
    6 => 644,
    5 => 555,
    4 => 444,
    3 => 311,
    2 => 200,
    1 => 111,
);

sub normalize_permissions {
    my $file = $_;

    if (-l $file) {
        return;
    }

    my $mode = sprintf('%04o', (stat($file))[2] & 07777);

    my $first           = substr($mode, 0, 1);
    my $change_to       = $first . $modes{substr($mode, 1, 1)};

    if ($mode != $change_to) {
        print "[$mode -> $change_to] $File::Find::name\n";
        chmod(oct($change_to), $file);
    }
}

find(\&normalize_permissions, ".");
