#!/usr/bin/env perl
#############################################################################
#
# Author:  Chris Weyl (cpan:RSRCHBOY), <cweyl@alumni.drew.edu>
# Company: No company, personal work
#
# Copyright (c) 2010  <cweyl@alumni.drew.edu>
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
#############################################################################

=head1 DESCRIPTION

This test exercises using MooseX::MarkAsMethods with just Class::MOP, rather
than Moose.

=cut

use strict;
use warnings;

{
    package TestClass;

    use metaclass;
    use MooseX::MarkAsMethods autoclean => 1;

    use overload q{""} => sub { shift->stringify }, fallback => 1;

    sub new {
        my $class = shift;
        my $instance = bless {@_}, $class;
        return $instance;
    }

    TestClass->meta->add_attribute(class_att => (reader => 'class_att_r'));

    sub stringify { 'val: ' . shift->class_att_r }
}

use Test::More 0.92;
use Test::Moose;

require 't/funcs.pm' unless eval { require funcs };

check_sugar_removed_ok('TestClass');

can_ok('TestClass', 'class_att_r');

my $t = make_and_check(
    'TestClass',
    undef,
    [ 'class_att' ],
);

# slight deviation...
my $t2 = TestClass->new(class_att => 'class_att value');
check_overloads($t2, '""' => 'val: class_att value');

done_testing;

__END__