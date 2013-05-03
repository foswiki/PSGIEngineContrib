#!/opt/local/bin/perl
use strict;
use warnings;

our($cfg, $cwd);
use Cwd qw(realpath);
use File::Basename;

BEGIN {
    ###################################
    # Config
    $cfg = {
        config_user => "admin",          #auth-name for the config script (this is not use Foswiki::cfg)
        config_pass => "change-this",    #clear-text password - the simpliest way ;( - need better handling here...
        config_hosts => ['+ 127.0.0.1'], #hosts, allowed access the configure script
        fwdir => "",        #name of the foswiki subdirectory. Must be in the dir, where is this script.

        #$ENV{PATH} - MUST BE without writable dirs, or configure will complain (-T)
        env_path => "/opt/local/bin:/usr/bin:/bin:/usr/local/bin",
        #env_path => 'c:/windows/system32;c:/windows'
        
    };
    ###################################

    $cwd = dirname( realpath(__FILE__) );
    
    require "setlib.cfg";
    die $@ if $@;
   
    $Foswiki::cfg{Engine} = 'Foswiki::Engine::CGI'; #ESSENTIAL - need to tell foswiki than we not running Engine::Legacy.
    
$ENV{FOSWIKI_ASSERTS} = 1;
$ENV{FOSWIKI_MONITOR} = 1;
    
}

use Plack::Builder;
use CGI::Emulate::PSGI;
use Plack::App::WrapCGI;
$ENV{PATH} = $cfg->{env_path};


#foswiki application - PSGI, with emulated CGI environment
my $foswiki = CGI::Emulate::PSGI->handler(sub {
    use CGI;
    use CGI::Cookie;
    use utf8;
    use Encode;
    #use uni::perl;
    CGI::initialize_globals();
    use CGI::Carp qw(fatalsToBrowser);
    $SIG{__DIE__} = \&CGI::Carp::confess;

    use Foswiki     ();
    use Foswiki::UI ();
    $Foswiki::engine->run();
});
sub authen_cb {
    my($username, $password) = @_;
    return $username eq $cfg->{config_user} && $password eq $cfg->{config_pass};
}

print STDERR "\n======= cwd $Foswiki::cfg{PubDir}\n\n";

builder {
    enable "Runtime";
    enable "Plack::Middleware::Static", path => sub { s!^/pub/!! }, root => $Foswiki::cfg{PubDir};

    my @actions = qw(view edit save rest oops
                    attach changes compare login logon manage preview rdiff rdiffauth
                    register rename resetpasswd search statistics upload viewauth viewfile);
    foreach my $act (@actions) {
        mount "/$act" => $foswiki;
    }
    mount '/' => $foswiki;
};
