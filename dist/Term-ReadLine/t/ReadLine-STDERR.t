#!./perl -w
use strict;

use Test::More;

## unit test for RT 132008 - https://rt.perl.org/Ticket/Display.html?id=132008

if ( $^O eq 'MSWin32' || !-e q{/dev/tty} ) {
    plan skip_all => "Test not tested on windows or when /dev/tty do not exists";
}
else {
    plan tests => 9;
}

if ( -e q[&STDERR] ) {
    note q[Removing existing file &STDERR];
    unlink q[&STDERR] or die q{Cannot remove existign file &STDERR [probably created from a previous run]};
}

use_ok('Term::ReadLine');
can_ok( 'Term::ReadLine::Stub', qw{new devtty findConsole} );

is( Term::ReadLine->devtty(), q{/dev/tty} );
my @out = Term::ReadLine::Stub::findConsole();
is_deeply \@out, [ q{/dev/tty}, q{/dev/tty} ], "findConsole is using /dev/tty";

{
    no warnings 'redefine';
    my $donotexist = q[/this/should/not/exist/hopefully];

    ok !-e $donotexist, "File $donotexist does not exist";
    local *Term::ReadLine::Stub::devtty = sub { $donotexist };
    is( Term::ReadLine->devtty(), $donotexist, "devtty mocked" );

    my @out = Term::ReadLine::Stub::findConsole();
    is_deeply \@out, [ q{&STDIN}, q{&STDERR} ], "findConsole is using /dev/tty" or diag explain \@out;

    ok !-e q[&STDERR], 'file &STDERR do not exist before Term::ReadLine call';
    my $tr = Term::ReadLine->new('whatever');
    ok !-e q[&STDERR], 'file &STDERR was not created by mistake';
}
