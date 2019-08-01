=pod

=encoding utf-8

=head1 PURPOSE

Unit test that Test::FITesque::RDF transforms HTTP data correctly from RDF

=head1 AUTHOR

Kjetil Kjernsmo E<lt>kjetilk@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is Copyright (c) 2019 by Inrupt Inc.

This is free software, licensed under:

  The MIT (X11) License


=cut

use strict;
use warnings;
use Test::Modern;
use Test::Deep;
use FindBin qw($Bin);
use Data::Dumper;

my $file = $Bin . '/data/http-list.ttl';

use Test::FITesque::RDF;


my $t = object_ok(
						sub { Test::FITesque::RDF->new(source => $file) }, 'RDF Fixture object',
						isa => [qw(Test::FITesque::RDF Moo::Object)],
						can => [qw(source suite transform_rdf)]);




my $data = $t->transform_rdf;

cmp_deeply($data,
[
          [
            [
              'Internal::Fixture::HTTPList'
            ],
            [
              'http_req_res_list_unauthenticated',
              {
					'http-requests' => ignore(),
					'http-responses' => ignore(),
					'-special' => { 'description' => 'More elaborate HTTP vocab for PUT then GET test'},
              }
            ]
          ]
        ], 'Main structure ok');

my $params = $data->[0]->[1]->[1];

is(scalar @{$params->{'http-requests'}}, 2, 'There are two requests');

foreach my $req (@{$params->{'http-requests'}}) {
  object_ok($req, 'Checking request object',
				isa => ['HTTP::Request'],
				can => [qw(method uri headers content)]
			  );
}

is(${$params->{'http-requests'}}[0]->method, 'PUT', 'First method is PUT');
is(${$params->{'http-requests'}}[1]->method, 'GET', 'Second method is GET');

like(${$params->{'http-requests'}}[0]->content, qr/dahut/, 'First request has content');


is(scalar @{$params->{'http-responses'}}, 2, 'There are two responses');

foreach my $res (@{$params->{'http-responses'}}) {
  object_ok($res, 'Checking response object',
				isa => ['HTTP::Response'],
				can => [qw(code headers)]
			  );
}

is(${$params->{'http-responses'}}[0]->code, '201', 'First code is 201');
is(${$params->{'http-responses'}}[1]->content_type, 'text/turtle', 'Second ctype is turtle');

cmp_deeply([${$params->{'http-responses'}}[1]->header('Content-Type')], bag("text/turtle"), 'Response header field value bag comparison can be used for single values');
cmp_deeply([${$params->{'http-responses'}}[1]->header('Accept-Post')], bag("text/turtle", "application/ld+json"), 'Response header field value bag comparison');

# TODO: Test retrieving content from URI

done_testing;

