#!/usr/bin/perl

# Test that our declared minimum Perl version matches our syntax

use strict;
BEGIN {
        $|  = 1;
        $^W = 1;
}

my @MODULES = (
	'File::Find::Rule 0.32',
	'File::Find::Rule::Perl 1.09',
	'Perl::MinimumVersion 1.27',
	'Test::MinimumVersion 0.101080',
);

# Don't run tests for installs
use Test::More;
unless ( $ENV{AUTOMATED_TESTING} or $ENV{RELEASE_TESTING} ) {
        plan( skip_all => "Author tests not required for installation" );
}

# Load the testing modules
foreach my $MODULE ( @MODULES ) {
        eval "use $MODULE";
        if ( $@ ) {
                $ENV{RELEASE_TESTING}
                ? die( "Failed to load required release-testing module $MODULE" )
                : plan( skip_all => "$MODULE not available for testing" );
        }
}

all_minimum_version_from_metayml_ok( {
	paths => [
		grep {
			! /23_unicode/
		} File::Find::Rule->perl_file->in('.')
	],
} );
