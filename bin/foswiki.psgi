#!/usr/bin/env perl

use File::Spec;

BEGIN {
    my ( $volume, $rootDir ) = File::Spec->splitpath(__FILE__);
    my $setlib = File::Spec->catpath( $volume, $rootDir, 'setlib.cfg' );
    @INC = ('.', grep { $_ ne '.' } @INC) unless $rootDir;
    require $setlib;
    $Foswiki::cfg{Engine} = 'Foswiki::Engine::CGI';
    $Foswiki::cfg{UseViewFile} = 0;
    $Foswiki::cfg{ScriptSuffix} = '';
}

use CGI ();
use CGI::Carp qw(fatalsToBrowser);
use CGI::Emulate::PSGI ();
use Foswiki ();
use Foswiki::UI ();

my $foswiki = CGI::Emulate::PSGI->handler(sub {
    CGI::initialize_globals();
    $Foswiki::cfg{ScriptSuffix} =~ s/\.psgi$//;
    $Foswiki::engine->run();
});

$Foswiki::cfg{PubUrlPath} ||= '/pub';
$Foswiki::cfg{PubUrlPath} =~ s{^(/..)+/}{/};

use Crypt::PasswdMD5;
use Plack::Builder;
use Plack::App::WrapCGI;

builder {
    mount '/' => builder {
        enable_if { $Foswiki::cfg{PubUrlPath} } 'Plack::Middleware::Static',
            path => qr{^$Foswiki::cfg{PubUrlPath}}, root => "$Foswiki::cfg{PubDir}/../";

        $foswiki;
    };

    mount "$Foswiki::cfg{ScriptUrlPath}/configure" => builder {
        enable_if { $Foswiki::cfg{LoginManager} eq 'Foswiki::LoginManager::ApacheLogin' } 'Auth::Basic', authenticator => sub {
            my($username, $password) = @_;
            return unless $Foswiki::cfg{AdminUserLogin} and $Foswiki::cfg{Password};
            if (my ($salt) = $Foswiki::cfg{Password} =~ /^(\$apr1\$[^\$]*\$)/) {
                return $username eq $Foswiki::cfg{AdminUserLogin} && apache_md5_crypt($password, $salt) eq $Foswiki::cfg{Password};
            }
            return;
        };
        local $SIG{__DIE__} = \&CGI::Carp::confess;
        Plack::App::WrapCGI->new(script => "$Foswiki::cfg{ScriptDir}/configure", execute => 1)->to_app;
    };
};

__END__
Foswiki - The Free and Open Source Wiki, http://foswiki.org/

Copyright (C) 2008-2015 Foswiki Contributors. Foswiki Contributors
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
