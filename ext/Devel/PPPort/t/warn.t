################################################################################
#
#            !!!!!   Do NOT edit this file directly!   !!!!!
#
#            Edit mktests.PL and/or parts/inc/warn instead.
#
################################################################################

BEGIN {
  if ($ENV{'PERL_CORE'}) {
    chdir 't' if -d 't';
    @INC = ('../lib', '../ext/Devel/PPPort/t') if -d '../lib' && -d '../ext';
    require Config; import Config;
    use vars '%Config';
    if (" $Config{'extensions'} " !~ m[ Devel/PPPort ]) {
      print "1..0 # Skip -- Perl configured without Devel::PPPort module\n";
      exit 0;
    }
  }
  else {
    unshift @INC, 't';
  }

  sub load {
    eval "use Test";
    require 'testutil.pl' if $@;
  }

  if (5) {
    load();
    plan(tests => 5);
  }
}

use Devel::PPPort;
use strict;
$^W = 1;

$^W = 0;

my $warning;

$SIG{'__WARN__'} = sub { $warning = $_[0] };

$warning = '';
Devel::PPPort::warner();
ok($] >= 5.004 ? $warning =~ /^warner bar:42/ : $warning eq '');

$warning = '';
Devel::PPPort::Perl_warner();
ok($] >= 5.004 ? $warning =~ /^Perl_warner bar:42/ : $warning eq '');

$warning = '';
Devel::PPPort::Perl_warner_nocontext();
ok($] >= 5.004 ? $warning =~ /^Perl_warner_nocontext bar:42/ : $warning eq '');

$warning = '';
Devel::PPPort::ckWARN();
ok($warning, '');

$^W = 1;

$warning = '';
Devel::PPPort::ckWARN();
ok($] >= 5.004 ? $warning =~ /^ckWARN bar:42/ : $warning eq '');

