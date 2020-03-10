#use strict;
#use warnings;

$| = 1;

BEGIN {
    #no warnings 'once';
    ${^WARNING_BITS} = 'UUUUUUUUUUUUUUUUUUU';
    print __LINE__ . "\n";

    # no warnings "numeric";
    ${^WARNING_BITS} = 'UUUEUUUUUUUUUUU';
    print __LINE__ . "\n";
    {
        print __LINE__ . "\n";
        print ${^WARNING_BITS} . "\n";
        print __LINE__ . "\n";
        ${^WARNING_BITS} = 'UUUEUUUUUUUUUUUUUUU';
    }
    print __LINE__ . "\n";
}

print qq[\ndone\n];

