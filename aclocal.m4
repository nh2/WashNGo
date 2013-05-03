dnl -- Pinched back from FPTOOLS/GHC
dnl
dnl WASH_GHC_VERSION(version)
dnl WASH_GHC_VERSION(major, minor [, patchlevel])
dnl WASH_GHC_VERSION(version, major, minor, patchlevel)
dnl
dnl Test for version of installed ghc.  Uses $GHC.
dnl [original version pinched from c2hs]
dnl
dnl NB: Don't use `+' in sed regexps; Jonas Svensson reports problems with it
dnl     on Solaris 8.
dnl
AC_DEFUN(WASH_GHC_VERSION,
[define([WASH_CV_GHC_VERSION], [ctk_cv_ghc_version])dnl
AC_CACHE_CHECK([version of ${GHC}], WASH_CV_GHC_VERSION, [dnl
  WASH_CV_GHC_VERSION=`${GHC:-ghc} --version | awk '{print $NF}'`
  if test "[$]WASH_CV_GHC_VERSION" = ""
  then
    WASH_CV_GHC_VERSION='unknown'
  fi])
changequote(<<, >>)dnl
WASH_CV_GHC_VERSION<<_major>>=`echo <<$>>WASH_CV_GHC_VERSION | sed -e 's/^\([0-9][0-9]*\).*/\1/'`
WASH_CV_GHC_VERSION<<_minor>>=`echo <<$>>WASH_CV_GHC_VERSION | sed -e 's/^[0-9][0-9]*\.\([0-9]*\).*/\1/'`
WASH_CV_GHC_VERSION<<_pl>>=`echo <<$>>WASH_CV_GHC_VERSION | sed -n -e 's/^[0-9][0-9]*\.[0-9]*\.\([0-9]*\)/\1/p'`
changequote([, ])dnl
if test "[$]WASH_CV_GHC_VERSION[_pl]" = ""
then
  WASH_CV_GHC_VERSION[_all]="[$]WASH_CV_GHC_VERSION[_major].[$]WASH_CV_GHC_VERSION[_minor]"
  WASH_CV_GHC_VERSION[_pl]="0"
else
  WASH_CV_GHC_VERSION[_all]="[$]WASH_CV_GHC_VERSION[_major].[$]WASH_CV_GHC_VERSION[_minor].[$]WASH_CV_GHC_VERSION[_pl]"
fi
ifelse($#, [1], [dnl
[$1]="[$]WASH_CV_GHC_VERSION[_all]"
], $#, [2], [dnl
[$1]="[$]WASH_CV_GHC_VERSION[_major]"
[$2]="[$]WASH_CV_GHC_VERSION[_minor]"
], $#, [3], [dnl
[$1]="[$]WASH_CV_GHC_VERSION[_major]"
[$2]="[$]WASH_CV_GHC_VERSION[_minor]"
[$3]="[$]WASH_CV_GHC_VERSION[_pl]"
], $#, [4], [dnl
[$1]="[$]WASH_CV_GHC_VERSION[_all]"
[$2]="[$]WASH_CV_GHC_VERSION[_major]"
[$3]="[$]WASH_CV_GHC_VERSION[_minor]"
[$4]="[$]WASH_CV_GHC_VERSION[_pl]"
], [AC_MSG_ERROR([wrong number of arguments to [$0]])])dnl
undefine([WASH_CV_GHC_VERSION])dnl
])dnl

dnl -- Pinched from Michael Weber's HaskellMPI
dnl
dnl WASH_PROG_CHECK_VERSION(VERSIONSTR1, TEST, VERSIONSTR2,
dnl                        ACTION-IF-TRUE [, ACTION-IF-FALSE])
dnl
dnl compare versions field-wise (separator is '.')
dnl TEST is one of {-lt,-le,-eq,-ge,-gt}
dnl
dnl quite shell-independent and SUSv2 compliant code
dnl
dnl NOTE: the loop could be unrolled within autoconf, but the
dnl       macro code would be a) longer and b) harder to debug... ;)
dnl
AC_DEFUN(WASH_PROG_CHECK_VERSION,
[if ( IFS=".";
      a="[$1]";  b="[$3]";
      while test -n "$a$b"
      do
              set -- [$]a;  h1="[$]1";  shift 2>/dev/null;  a="[$]*"
              set -- [$]b;  h2="[$]1";  shift 2>/dev/null;  b="[$]*"
              test -n "[$]h1" || h1=0;  test -n "[$]h2" || h2=0
              test [$]{h1} -eq [$]{h2} || break
      done
      test [$]{h1} [$2] [$]{h2}
    )
then ifelse([$4],,[:],[
  $4])
ifelse([$5],,,
[else
  $5])
fi])])dnl
