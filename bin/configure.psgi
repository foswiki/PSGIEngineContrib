#!/opt/local/bin/perl
use strict;
use warnings;

our($cfg, $cwd);
#use Cwd qw(realpath);
use Cwd;
use File::Basename;

BEGIN {
    ###################################
    # Config
    $cfg = {
        config_user => "admin",          #auth-name for the config script (this is not use Foswiki::cfg)
        config_pass => "change-this",    #clear-text password - the simpliest way ;( - need better handling here...
        config_hosts => ['+ 127.0.0.1'], #hosts, allowed access the configure script
        fwdir => "foswiki",        #name of the foswiki subdirectory. Must be in the dir, where is this script.

        #$ENV{PATH} - MUST BE without writable dirs, or configure will complain (-T)
        env_path => "/opt/local/bin:/usr/bin:/bin:/usr/local/bin",
        #env_path => 'c:/windows/system32;c:/windows'
        
    };
    ###################################

    #$cwd = dirname( realpath(__FILE__) );
    $cwd = dirname(__FILE__);
    
    print STDERR "\n\nexpecting to find the configure script in $cwd\n";
    print STDERR "configured to require authentication user: $cfg->{config_user} with password: $cfg->{config_pass}\n\n";
    
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

#configure script: standard (forked) CGI application
my $configure = Plack::App::WrapCGI->new( script => "$cwd/configure")->to_app;

builder {
    enable "Runtime";

    mount "/configure" => builder {
        enable "Auth::Basic", authenticator => \&authen_cb;
        #enable 'IPAddressFilter', rules => $cfg->{config_hosts};
        $ENV{AUTH_TYPE} = "BASIC";
        $configure;
    };
};
sub authen_cb {
    my($username, $password) = @_;
    return $username eq $cfg->{config_user} && $password eq $cfg->{config_pass};
}
