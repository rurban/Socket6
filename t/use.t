#!/usr/bin/env perl -w

# Copyright (C) 2003 Hajimu UMEMOTO <ume@mahoroba.org>.
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

# $Id: use.t,v 1.3 2013/12/07 18:29:38 ume Exp $

use strict;
use Test;
use Socket qw(AF_INET AF_INET6 SOCK_STREAM);
BEGIN { plan tests => 9 }

use Socket6; ok(1);
my @tmp = getaddrinfo("localhost", "", AF_INET, SOCK_STREAM, 0, 0);
if ($#tmp >= 1) {
    ok(2);
}
my($family, $socktype, $protocol, $sin, $canonname) = splice(@tmp, $[, 5);
my($addr, $port) = getnameinfo($sin, NI_NUMERICHOST | NI_NUMERICSERV);
if ($addr eq "127.0.0.1" && $port eq "0") {
    ok(3);
}
ok(inet_ntop(AF_INET6, inet_pton(AF_INET6, "::")), "::");
ok(inet_ntop(AF_INET6, inet_pton(AF_INET6, "::21")), "::21") # this fails under darwin
  or print "# ",unpack("H*", inet_pton(AF_INET6, "::21")),"\n";
ok(inet_ntop(AF_INET6, inet_pton(AF_INET6, "43::")), "43::");
ok(inet_ntop(AF_INET6, inet_pton(AF_INET6, "1:2:3:4:5:6:7::")), "1:2:3:4:5:6:7:0");
ok(inet_ntop(AF_INET6, inet_pton(AF_INET6, "1::8")), "1::8");
ok(inet_ntop(AF_INET6, inet_pton(AF_INET6, "FF00::FFFF")), "ff00::ffff");
