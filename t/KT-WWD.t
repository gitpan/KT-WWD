# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl KT-WWD.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

#use Test::More tests => 2;
BEGIN { $| = 1; print "1..2\n"; }
END {print "not ok 1\n" unless $loaded;}
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

# Test 2:

use KT::WWD;
$wwd = new KT::WWD;
if($wwd->get("idserver.org","id") eq "IDSERVER.Org") {
	print "ok 2\n";
} else {
	print "not ok 2\n";
}

