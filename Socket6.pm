# Copyright (C) 2000 Hajimu UMEMOTO <ume@mahoroba.org>.
# All rights reserved.
# 
# This moduled is besed on perl5.005_55-v6-19990721 written by KAME
# Project.
#
# Copyright (C) 1995, 1996, 1997, 1998, and 1999 WIDE Project.
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. Neither the name of the project nor the names of its contributors
#    may be used to endorse or promote products derived from this software
#    without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE PROJECT AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE PROJECT OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.

# $Id: Socket6.pm,v 1.8 2000/03/17 22:18:45 ume Exp $

package Socket6;

use vars qw($VERSION @ISA @EXPORT %EXPORT_TAGS);
$VERSION = "0.05";

=head1 NAME

Socket6, sockaddr_in6, inet_pton, inet_ntop - load IPv6 related part of the C socket.h defines and structure manipulators 

=head1 SYNOPSIS

    use Socket6;

    ($family, $socktype, $proto, $sin) =
	getaddrinfo('hishost.com', 'daytime', AF_UNSPEC, SOCK_STREAM);
    socket(Socket_Handle, $family, $socktype, $proto);
    connect(Socket_Handle, $sin);

    ($host, $port) = getnameinfo(getpeername(Socket_Handle));

=head1 DESCRIPTION

This module support getaddrinfo() and getnameinfo() to intend to
enable protocol independent programing.
If your environment supports IPv6, IPv6 related defines such as
AF_INET6 are included.

=over

=back

=cut

use Carp;

require Exporter;
require DynaLoader;
@ISA = qw(Exporter DynaLoader);
@EXPORT = qw(
	inet_pton inet_ntop pack_sockaddr_in6 pack_sockaddr_in6_all
	unpack_sockaddr_in6 unpack_sockaddr_in6_all sockaddr_in6
	gethostbyname2 getaddrinfo getnameinfo
	in6addr_any in6addr_loopback
	AF_INET6
	AI_ADDRCONFIG
	AI_ALL
	AI_CANONNAME
	AI_NUMERICHOST
	AI_DEFAULT
	AI_MASK
	AI_PASSIVE
	AI_V4MAPPED
	AI_V4MAPPED_CFG
	IP_AUTH_TRANS_LEVEL
	IP_AUTH_NETWORK_LEVEL
	IP_ESP_TRANS_LEVEL
	IP_ESP_NETWORK_LEVEL
	IPPROTO_IP
	IPPROTO_IPV6
	IPSEC_LEVEL_AVAIL
	IPSEC_LEVEL_BYPASS
	IPSEC_LEVEL_DEFAULT
	IPSEC_LEVEL_NONE
	IPSEC_LEVEL_REQUIRE
	IPSEC_LEVEL_UNIQUE
	IPSEC_LEVEL_USE
	IPV6_AUTH_TRANS_LEVEL
	IPV6_AUTH_NETWORK_LEVEL
	IPV6_ESP_NETWORK_LEVEL
	IPV6_ESP_TRANS_LEVEL
	NI_NOFQDN
	NI_NUMERICHOST
	NI_NAMEREQD
	NI_NUMERICSERV
	NI_DGRAM
	NI_WITHSCOPEID
	PF_INET6
);

%EXPORT_TAGS = (
    all     => [@EXPORT],
);

sub sockaddr_in6 {
    if (wantarray) {
	croak "usage:   (port,iaddr) = sockaddr_in6(sin_sv)" unless @_ == 1;
        unpack_sockaddr_in6(@_);
    } else {
	croak "usage:   sin_sv = sockaddr_in6(port,iaddr))" unless @_ == 2;
        pack_sockaddr_in6(@_);
    }
}

sub AUTOLOAD {
    my($constname);
    ($constname = $AUTOLOAD) =~ s/.*:://o;
    my $val = constant($constname, @_ ? $_[0] : 0);
    if ($! != 0) {
	my ($pack, $file, $line) = caller;
	croak "Your vendor has not defined Socket macro $constname, used";
    }
    eval "sub $AUTOLOAD { $val }";
    goto &$AUTOLOAD;
}

bootstrap Socket6 $VERSION;

1;
