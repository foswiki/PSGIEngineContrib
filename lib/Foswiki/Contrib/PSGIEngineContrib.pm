# See bottom of file for default license and copyright information

=begin TML

---+ package Foswiki::Contrib::PSGIEngineContrib

This is a stub module for a new contrib. Customise this module as
required.  It is typically not used by the Contrib.  Foswiki does not load it
automatically.  It is used by the Extensions Installer to detect the currently
installed version of the Contrib.

=cut


package Foswiki::Contrib::PSGIEngineContrib;

# Always use strict to enforce variable scoping
use strict;
use warnings;

# $VERSION is referred to by Foswiki, and is the only global variable that
# *must* exist in this package.  Two version formats are supported:
#
# Recommended:  Simple decimal version.   Use "1.2" format for releases
# Do NOT use the "v" prefix.  This style is set either by using the "parse"
# method, or by a simple assignment.
#
#    our $VERSION = "1.20";
#
# If you intend to use the _nnn "alpha suffix, declare it using version->parse().
#
#    use version; our $VERSION = version->parse("1.20_001");
#
# Alternative:  Dotted triplet.  Use "v1.2.3" format for releases,  and
# "v1.2.3_001" for "alpha" versions.  The v prefix is required.
# This format uses the "declare" format These statements MUST be on the same
# line. See "perldoc version" for more information on version strings.
#
#     use version; our $VERSION = version->declare("v1.2.0");
#
# To convert from a decimal version to a dotted version, first normalize the
# decimal version, then increment it.
# perl -Mversion -e 'print version->parse("4.44")->normal'  ==>  v4.440.0
# In this example the next version would be v4.441.0.
#
# Note:  Alpha versions compare as numerically lower than the non-alpha version
# so the versions in ascending order are:
#   v1.2.1_001 -> v1.2.1 -> v1.2.2_001 -> v1.2.2
#
our $VERSION = '1.0';

# $RELEASE is used in the "Find More Extensions" automation in configure.
# It is a manually maintained string used to identify functionality steps.
# You can use any of the following formats:
# tuple   - a sequence of integers separated by . e.g. 1.2.3. The numbers
#           usually refer to major.minor.patch release or similar. You can
#           use as many numbers as you like e.g. '1' or '1.2.3.4.5'.
# isodate - a date in ISO8601 format e.g. 2009-08-07
# date    - a date in 1 Jun 2009 format. Three letter English month names only.
# Note: it's important that this string is exactly the same in the extension
# topic - if you use %$RELEASE% with BuildContrib this is done automatically.
# It is preferred to keep this compatible with $VERSION. At some future
# date, Foswiki will deprecate RELEASE and use the VERSION string.
#
our $RELEASE = '1.0';

our $SHORTDESCRIPTION = 'run foswiki in PSGI environment';

1;

__END__
Foswiki - The Free and Open Source Wiki, http://foswiki.org/

Author: SvenDowideit

Copyright (C) 2008-2013 Foswiki Contributors. Foswiki Contributors
are listed in the AUTHORS file in the root of this distribution.
NOTE: Please extend that file, not this notice.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version. For
more details read LICENSE in the root of this distribution.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

As per the GPL, removal of this notice is prohibited.
