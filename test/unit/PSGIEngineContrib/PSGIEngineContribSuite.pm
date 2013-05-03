package PSGIEngineContribSuite;

use Unit::TestSuite;
our @ISA = qw( Unit::TestSuite );

sub name { 'PSGIEngineContribSuite' }

sub include_tests { qw(PSGIEngineContribTests) }

1;
