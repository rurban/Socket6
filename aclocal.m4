dnl Copyright (C) 2000 Hajimu UMEMOTO <ume@mahoroba.org>.
dnl All rights reserved.
dnl 
dnl Redistribution and use in source and binary forms, with or without
dnl modification, are permitted provided that the following conditions
dnl are met:
dnl 1. Redistributions of source code must retain the above copyright
dnl    notice, this list of conditions and the following disclaimer.
dnl 2. Redistributions in binary form must reproduce the above copyright
dnl    notice, this list of conditions and the following disclaimer in the
dnl    documentation and/or other materials provided with the distribution.
dnl 3. Neither the name of the project nor the names of its contributors
dnl    may be used to endorse or promote products derived from this software
dnl    without specific prior written permission.
dnl
dnl THIS SOFTWARE IS PROVIDED BY THE PROJECT AND CONTRIBUTORS ``AS IS'' AND
dnl ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
dnl IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
dnl ARE DISCLAIMED.  IN NO EVENT SHALL THE PROJECT OR CONTRIBUTORS BE LIABLE
dnl FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
dnl DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
dnl OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
dnl HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
dnl LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
dnl OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
dnl SUCH DAMAGE.

dnl $Id: aclocal.m4,v 1.2 2000/03/14 13:15:29 ume Exp $

dnl SOCKET6_CHECK_PL_SV_UNDEF(VALUE-IF-FOUND , VALUE-IF-NOT-FOUND
dnl                           [, PERL-PATH])
AC_DEFUN(SOCKET6_CHECK_PL_SV_UNDEF, [
AC_MSG_CHECKING([whether your Perl5 have PL_sv_undef])
AC_CACHE_VAL(socket6_cv_pl_sv_undef,[
rm -rf conftest
mkdir conftest
cd conftest
cat >Makefile.PL <<EOF
use ExtUtils::MakeMaker;
WriteMakefile(
    NAME	 => 'conftest',
    VERSION_FROM => 'conftest.pm',
    XSPROTOARG	 => '-noprototypes',
);
EOF
cat > conftest.pm <<EOF
package conftest;
use vars qw(\$VERSION);
\$VERSION = "0.0";
EOF
cat > conftest.xs <<EOF
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
MODULE = conftest	PACKAGE = conftest
void
conftest()
	CODE:
	ST(0) = &PL_sv_undef;
EOF
ifelse([$3], , socket6_cv_perl_path='perl', socket6_cv_perl_path=$3)
if { (eval $socket6_cv_perl_path Makefile.PL) 2>&5 >/dev/null; (eval make) 2>&5 >/dev/null; }; then
	socket6_cv_pl_sv_undef='yes'
else
	socket6_cv_pl_sv_undef='no'
fi
cd ..
rm -rf conftest
])
if test $socket6_cv_pl_sv_undef = 'yes'; then
	AC_MSG_RESULT(yes)
	ifelse([$1], , :, [$1])
else
	AC_MSG_RESULT(no)
	ifelse([$2], , :, [$2])
fi
])

dnl SOCKET6_CHECK_SA_LEN(VALUE-IF-FOUND , VALUE-IF-NOT-FOUND)
AC_DEFUN(SOCKET6_CHECK_SA_LEN, [
AC_MSG_CHECKING([whether you have sa_len in struct sockaddr])
AC_TRY_COMPILE([
#include <sys/types.h>
#include <sys/socket.h>
],[
struct sockaddr sa;
int i = sa.sa_len;
],[	AC_MSG_RESULT([yes])
	ifelse([$1], , :, [$1])
],[	AC_MSG_RESULT([no])
	ifelse([$2], , :, [$2])
])
])

dnl SOCKET6_CHECK_SIN6_SCOPE_ID(VALUE-IF-FOUND , VALUE-IF-NOT-FOUND)
AC_DEFUN(SOCKET6_CHECK_SIN6_SCOPE_ID, [
AC_MSG_CHECKING([whether you have sin6_scope_id in struct sockaddr_in6])
AC_TRY_COMPILE([
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
],[
struct sockaddr_in6 sin6;
int i = sin6.sin6_scope_id; 
],[	AC_MSG_RESULT([yes])
	ifelse([$1], , :, [$1])
],[	AC_MSG_RESULT([no])
	ifelse([$2], , :, [$2])
])
])

dnl SOCKET6_CHECK_FUNC(FUNC, VALUE-IF-FOUND [, V6LIB-DIR])
AC_DEFUN(SOCKET6_CHECK_FUNC, [
AC_CHECK_FUNC($1, AC_DEFINE($2), [
ifelse([$3], , :, [
LDFLAGS="-L$3/lib"
AC_CHECK_LIB(inet6, $1, [
AC_DEFINE($2)
INET6LIBS="$LDFLAGS -linet6"],)])])])
