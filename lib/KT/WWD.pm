package KT::WWD;

#############################################
# WWD File parser for integration with Apache
# (C) Copyright 2001-2003 Kaizen Technologies
# All rights reserved.
#############################################

use 5.0;
#use strict;
use warnings;
use CGI qw(:standard escapeHTML);
use HTTP::Request;
use LWP::UserAgent;
use HTTP::Headers;
use CGI::Carp "fatalsToBrowser";
use Data::Dumper;
use Carp;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use KT::WWD ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.

our %EXPORT_TAGS = ( 'all' => [ qw() ] );
our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT = qw();
our $VERSION = '0.51';

my $header = HTTP::Headers->new('content-type' => 'text/html');
my $ua = LWP::UserAgent->new;

# Preloaded methods go here.

my $web=$user=$pass="";

sub new {
        my $proto = shift;
        my $self = {};

        bless $self, $proto;
        return $self;
}

sub auth {
        my($self,$usr,$pw) = @_;
        $user = $usr;
        $pass = $pw;
        return 1;
}

sub get {
        my ($self,$site,$link,$rp) = @_;
        if(!defined $rp) { $rp = ""; }
        if($site !~ /^http:/) { $site = "http://${site}"; }
        my $data = webget("${site}/wwd/wwd.cgi?t=${link}&user=${user}&pw=${pass}&rp=${rp}&gonow");
        if($data =~ /\n\n/) { $data = $'; }
        if($data =~ /:/) { $modtime = $`; $data = $'; }
        if($data =~ /:/) { $ttl = $`; $data = $'; }
        $data =~ s/\n$//;
        return $data;
}

sub set {
        my ($self,$site,$link,$value,$modpass,$newmodpass,$temppass,$ttl,$readpass,$allowed) = @_;
        if($site !~ /^http:/) { $site = "http://${site}"; }
        if(!defined $value) { $value = ""; }
        if(!defined $modpass) { $modpass = ""; }
        if(!defined $newmodpass) { $newmodpass = ""; }
        if(!defined $temppass) { $temppass = ""; }
        if(!defined $ttl) { $ttl = ""; }
        if(!defined $readpass) { $readpass = ""; }
        if(!defined $allowed) { $allowed = ""; }
        if($site !~ /^http:/) { $site = "http://${site}"; }
        my $data = webget("${site}/wwd/wwd.cgi?ac=save&v=${value}&t=${link}&user=${user}&pw=${pass}&p=${modpass}&mp=${newmodpass}&tp=${temppass}&ttl=${ttl}&rp=${readpass}&a=${allowed}&gonow");

        if($data =~ /\n\n/) { $data = $'; }
        $data =~ s/\n$//;
        return $data;
}

sub delete {
        my ($self,$site,$link,$rp) = @_;
        if(!defined $rp) { $rp = ""; }

        if($site !~ /^http:/) { $site = "http://${site}"; }
        my $data = webget("${site}/wwd/wwd.cgi?t=${link}&user=${user}&pw=${pass}&p=${rp}&ac=del&gonow");

        if($data =~ /\n\n/) { $data = $'; }
        $data =~ s/\n$//;
        return $data;
}

sub webget {
        my($url, $data) = @_;
        if(!defined $url) { $url = ""; }
        if(!defined $data) { $data = ""; }
	$url .= "?";
	$url .= $data;
	
        my $req = HTTP::Request->new(GET,"${url}?${data}",$header);
        return $ua->request($req)->as_string();
}


1;
__END__

=head1 NAME

KT::WWD - Perl module for the World Wide Database

=head1 SYNOPSIS

use KT::WWD;



  $wwd = new KT::WWD;
  $wwd->auth($username,$password);
  print $wwd->get($domainname, $link, $readpassword);
  $wwd->set($domainname, $link, $modifypassword, $newmodifypassword, $temporarypassword, $timetoliveinseconds, $readpassword, $allowediplist);
  $wwd->delete($domainname, $link, $readpassword);


=head2 EXPORT

None by default.

=head1 AUTHOR

John Baleshiski, E<lt>john@idserver.orgE<gt>

For more information and the technical specification, visit http://idserver.org/wwd

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2004 by john@idserver.org

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.0 or,
at your option, any later version of Perl 5 you may have available.


=cut
