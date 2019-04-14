=pod

=encoding utf-8

=head1 PURPOSE

Integration tests using Test::FITesque::Test with RDF data to see tests actually working

=head1 AUTHOR

Kjetil Kjernsmo E<lt>kjetilk@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is Copyright (c) 2019 by Inrupt Inc.

This is free software, licensed under:

  The MIT (X11) License


=cut


use strict;
use warnings;

use Test::More;
use Path::Tiny;
use Data::Dumper;
use FindBin qw($Bin);
use Test::FITesque;
use Test::FITesque::Test;

use lib 't/lib';

my $file = $Bin . '/data/multi.ttl';

use Test::FITesque::Test::RDF;

my $suite = Test::FITesque::Test::RDF->new(source => $file)->suite;

$suite->run_tests;

done_testing;
  

