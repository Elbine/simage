# aclocal.m4 generated automatically by aclocal 1.4g

# Copyright 1994, 1995, 1996, 1997, 1998, 1999, 2000
# Free Software Foundation, Inc.
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY, to the extent permitted by law; without
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.

# **************************************************************************
# SIM_AC_CVS_CHANGES( SIM_AC_CVS_CHANGE-MACROS )
#
# This macro is just an envelope macro for SIM_AC_CVS_CHANGE invokations.
# It performs necessary initializations and finalizing.  All the
# SIM_AC_CVS_CHANGE invokations should be preformed inside the same
# SIM_AC_CVS_CHANGES macro.
#
# Authors:
#   Lars J. Aas <larsa@sim.no>
#

AC_DEFUN([SIM_AC_CVS_CHANGES], [
pushdef([sim_ac_cvs_changes], 1)
sim_ac_do_cvs_update=false
sim_ac_cvs_changed=false
sim_ac_cvs_problem=false
sim_ac_cvs_save_builddir=`pwd`
AC_ARG_ENABLE(
  [cvs-auto-update],
  AC_HELP_STRING([--enable-cvs-auto-update],
                 [auto-update CVS repository if possible]),
  [case "$enableval" in
  yes) sim_ac_do_cvs_update=true ;;
  no)  sim_ac_do_cvs_update=false ;;
  *)   AC_MSG_ERROR(["$enableval" given to --enable-cvs-update]) ;;
  esac])
if test -d $srcdir/CVS; then
  ifelse([$1], , :, [$1])
  if $sim_ac_cvs_problem; then
    cat <<"CVS_CHANGES_EOF"
To make the above listed procedure be executed automatically, run configure
again with "--enable-cvs-auto-update" added to the configure options.
CVS_CHANGES_EOF
  fi
fi
$sim_ac_cvs_problem && echo "" && echo "Aborting..." && exit 1
popdef([sim_ac_cvs_changes])
]) # SIM_AC_CVS_CHANGES

# **************************************************************************
# SIM_AC_CVS_CHANGE( UPDATE-PROCEDURE, UPDATE-TEST, UPDATE-TEST, ... )
#
# This macro is used to ensure that CVS source repository changes that need
# manual intervention on all the build systems are executed before the
# configure script is run.
#
# UPDATE-PROCEDURE is the procedure needed to update the source repository.
# UPDATE-TEST is a command that returns failure if the update procedure
# hasn't been executed, and success afterwards.  You can have as many test
# as you like.  All tests must pass for the macro to believe the source
# repository is up-to-date.
#
# All commands (the update procedure and the tests) are executed from the
# CVS repository root.
#
# SIM_AC_CVS_CHANGE must be invoked inside SIM_AC_CVS_CHANGES.
#
# Authors:
#   Lars J. Aas <larsa@sim.no>
#

AC_DEFUN([SIM_AC_CVS_CHANGE], [
ifdef([sim_ac_cvs_changes], ,
      [AC_MSG_ERROR([[SIM_AC_CVS_CHANGE invoked outside SIM_AC_CVS_CHANGES]])])
cd $srcdir;
m4_foreach([testcommand], [m4_shift($@)], [testcommand
if test $? -ne 0; then sim_ac_cvs_changed=true; fi
])
cd $sim_ac_cvs_save_builddir
if $sim_ac_cvs_changed; then
  if $sim_ac_do_cvs_update; then
    echo "Performing repository update:"
    cd $srcdir;
    ( set -x
$1 )
    sim_ac_cvs_unfixed=false
m4_foreach([testcommand], [m4_shift($@)],
[    testcommand
    if test $? -ne 0; then sim_ac_cvs_unfixed=true; fi
])
    cd $sim_ac_cvs_save_builddir
    if $sim_ac_cvs_unfixed; then
      cat <<"CVS_CHANGE_EOF"

The following update procedure does not seem to have produced the desired
effect:

$1

You should investigate what went wrong and alert the relevant software
developers about it.

Aborting...
CVS_CHANGE_EOF
      exit 1
    fi
  else
    $sim_ac_cvs_problem || {
    cat <<"CVS_CHANGE_EOF"

The configure script has detected source hierachy inconsistencies between
your source repository and the master source repository.  This needs to be
fixed before you can proceed.

The suggested update procedure is to execute the following set of commands
in the root source directory:
CVS_CHANGE_EOF
    }
    cat <<"CVS_CHANGE_EOF"
$1
CVS_CHANGE_EOF
    sim_ac_cvs_problem=true
  fi
fi
]) # SIM_AC_CVS_CHANGE

# EOF **********************************************************************

# **************************************************************************
# SIM_AC_SETUP_MSVC_IFELSE( IF-FOUND, IF-NOT-FOUND )
#
# This macro invokes IF-FOUND if the msvccc wrapper can be run, and
# IF-NOT-FOUND if not.
#
# Authors:
#   Morten Eriksen <mortene@coin3d.org>
#   Lars J. Aas <larsa@coin3d.org>

# **************************************************************************

AC_DEFUN([SIM_AC_SETUP_MSVC_IFELSE],
[# **************************************************************************
# If the Microsoft Visual C++ cl.exe compiler is available, set us up for
# compiling with it and to generate an MSWindows .dll file.

: ${BUILD_WITH_MSVC=false}
sim_ac_msvccc=`cd $srcdir; pwd`/cfg/m4/msvccc
if test -z "$CC" -a -z "$CXX" && $sim_ac_msvccc >/dev/null 2>&1; then
  m4_ifdef([$0_VISITED],
    [AC_FATAL([Macro $0 invoked multiple times])])
  m4_define([$0_VISITED], 1)
  CC=$sim_ac_msvccc
  CXX=$sim_ac_msvccc
  export CC CXX
  BUILD_WITH_MSVC=true
fi
AC_SUBST(BUILD_WITH_MSVC)
if $BUILD_WITH_MSVC; then
  :
  $1
else
  :
  $2
fi
]) # SIM_AC_SETUP_MSVC_IFELSE

# **************************************************************************

AC_DEFUN([SIM_AC_MSVC_SUPPORT],
[# **************************************************************************
# If the Microsoft Visual C++ cl.exe compiler is available, set us up for
# compiling with it and to generate an MSWindows .dll file.

: ${BUILD_WITH_MSVC=false}
sim_ac_msvccc=`cd $srcdir; pwd`/cfg/m4/msvccc
if test -z "$CC" -a -z "$CXX" && $sim_ac_msvccc >/dev/null 2>&1; then
  m4_ifdef([$0_VISITED],
    [AC_FATAL([Macro $0 invoked multiple times])])
  m4_define([$0_VISITED], 1)
  CC=$sim_ac_msvccc
  CXX=$sim_ac_msvccc
  export CC CXX
  BUILD_WITH_MSVC=true
fi
AC_SUBST(BUILD_WITH_MSVC)
]) # SIM_AC_MSVC_SUPPORT

# EOF **********************************************************************


# serial 1

# @defmac AC_PROG_CC_STDC
# @maindex PROG_CC_STDC
# @ovindex CC
# If the C compiler in not in ANSI C mode by default, try to add an option
# to output variable @code{CC} to make it so.  This macro tries various
# options that select ANSI C on some system or another.  It considers the
# compiler to be in ANSI C mode if it handles function prototypes correctly.
#
# If you use this macro, you should check after calling it whether the C
# compiler has been set to accept ANSI C; if not, the shell variable
# @code{am_cv_prog_cc_stdc} is set to @samp{no}.  If you wrote your source
# code in ANSI C, you can make an un-ANSIfied copy of it by using the
# program @code{ansi2knr}, which comes with Ghostscript.
# @end defmac

AC_DEFUN([AM_PROG_CC_STDC],
[AC_REQUIRE([AC_PROG_CC])
AC_BEFORE([$0], [AC_C_INLINE])
AC_BEFORE([$0], [AC_C_CONST])
dnl Force this before AC_PROG_CPP.  Some cpp's, eg on HPUX, require
dnl a magic option to avoid problems with ANSI preprocessor commands
dnl like #elif.
dnl FIXME: can't do this because then AC_AIX won't work due to a
dnl circular dependency.
dnl AC_BEFORE([$0], [AC_PROG_CPP])
AC_MSG_CHECKING([for ${CC-cc} option to accept ANSI C])
AC_CACHE_VAL(am_cv_prog_cc_stdc,
[am_cv_prog_cc_stdc=no
ac_save_CC="$CC"
# Don't try gcc -ansi; that turns off useful extensions and
# breaks some systems' header files.
# AIX			-qlanglvl=ansi
# Ultrix and OSF/1	-std1
# HP-UX 10.20 and later	-Ae
# HP-UX older versions	-Aa -D_HPUX_SOURCE
# SVR4			-Xc -D__EXTENSIONS__
for ac_arg in "" -qlanglvl=ansi -std1 -Ae "-Aa -D_HPUX_SOURCE" "-Xc -D__EXTENSIONS__"
do
  CC="$ac_save_CC $ac_arg"
  AC_TRY_COMPILE(
[#include <stdarg.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
/* Most of the following tests are stolen from RCS 5.7's src/conf.sh.  */
struct buf { int x; };
FILE * (*rcsopen) (struct buf *, struct stat *, int);
static char *e (p, i)
     char **p;
     int i;
{
  return p[i];
}
static char *f (char * (*g) (char **, int), char **p, ...)
{
  char *s;
  va_list v;
  va_start (v,p);
  s = g (p, va_arg (v,int));
  va_end (v);
  return s;
}
int test (int i, double x);
struct s1 {int (*f) (int a);};
struct s2 {int (*f) (double a);};
int pairnames (int, char **, FILE *(*)(struct buf *, struct stat *, int), int, int);
int argc;
char **argv;
], [
return f (e, argv, 0) != argv[0]  ||  f (e, argv, 1) != argv[1];
],
[am_cv_prog_cc_stdc="$ac_arg"; break])
done
CC="$ac_save_CC"
])
if test -z "$am_cv_prog_cc_stdc"; then
  AC_MSG_RESULT([none needed])
else
  AC_MSG_RESULT([$am_cv_prog_cc_stdc])
fi
case "x$am_cv_prog_cc_stdc" in
  x|xno) ;;
  *) CC="$CC $am_cv_prog_cc_stdc" ;;
esac
])

# Do all the work for Automake.  This macro actually does too much --
# some checks are only needed if your package does certain things.
# But this isn't really a big deal.

# serial 5

# There are a few dirty hacks below to avoid letting `AC_PROG_CC' be
# written in clear, in which case automake, when reading aclocal.m4,
# will think it sees a *use*, and therefore will trigger all it's
# C support machinery.  Also note that it means that autoscan, seeing
# CC etc. in the Makefile, will ask for an AC_PROG_CC use...


# We require 2.13 because we rely on SHELL being computed by configure.
AC_PREREQ([2.13])

# AC_PROVIDE_IFELSE(MACRO-NAME, IF-PROVIDED, IF-NOT-PROVIDED)
# -----------------------------------------------------------
# If MACRO-NAME is provided do IF-PROVIDED, else IF-NOT-PROVIDED.
# The purpose of this macro is to provide the user with a means to
# check macros which are provided without letting her know how the
# information is coded.
# If this macro is not defined by Autoconf, define it here.
ifdef([AC_PROVIDE_IFELSE],
      [],
      [define([AC_PROVIDE_IFELSE],
              [ifdef([AC_PROVIDE_$1],
                     [$2], [$3])])])


# AM_INIT_AUTOMAKE(PACKAGE,VERSION, [NO-DEFINE])
# ----------------------------------------------
AC_DEFUN([AM_INIT_AUTOMAKE],
[AC_REQUIRE([AC_PROG_INSTALL])dnl
# test to see if srcdir already configured
if test "`CDPATH=:; cd $srcdir && pwd`" != "`pwd`" &&
   test -f $srcdir/config.status; then
  AC_MSG_ERROR([source directory already configured; run \"make distclean\" there first])
fi

# Define the identity of the package.
PACKAGE=$1
AC_SUBST(PACKAGE)dnl
VERSION=$2
AC_SUBST(VERSION)dnl
ifelse([$3],,
[AC_DEFINE_UNQUOTED(PACKAGE, "$PACKAGE", [Name of package])
AC_DEFINE_UNQUOTED(VERSION, "$VERSION", [Version number of package])])

# Autoconf 2.50 wants to disallow AM_ names.  We explicitly allow
# the ones we care about.
ifdef([m4_pattern_allow],
      [m4_pattern_allow([^AM_[A-Z]+FLAGS])])dnl

# Some tools Automake needs.
AC_REQUIRE([AM_SANITY_CHECK])dnl
AC_REQUIRE([AC_ARG_PROGRAM])dnl
AM_MISSING_PROG(ACLOCAL, aclocal)
AM_MISSING_PROG(AUTOCONF, autoconf)
AM_MISSING_PROG(AUTOMAKE, automake)
AM_MISSING_PROG(AUTOHEADER, autoheader)
AM_MISSING_PROG(MAKEINFO, makeinfo)
AM_MISSING_PROG(AMTAR, tar)
AM_MISSING_INSTALL_SH
AM_PROG_INSTALL_STRIP
# We need awk for the "check" target.  The system "awk" is bad on
# some platforms.
AC_REQUIRE([AC_PROG_AWK])dnl
AC_REQUIRE([AC_PROG_MAKE_SET])dnl
AC_REQUIRE([AM_DEP_TRACK])dnl
AC_REQUIRE([AM_SET_DEPDIR])dnl
AC_PROVIDE_IFELSE([AC_PROG_][CC],
                  [AM_DEPENDENCIES(CC)],
                  [define([AC_PROG_][CC],
                          defn([AC_PROG_][CC])[AM_DEPENDENCIES(CC)])])dnl
AC_PROVIDE_IFELSE([AC_PROG_][CXX],
                  [AM_DEPENDENCIES(CXX)],
                  [define([AC_PROG_][CXX],
                          defn([AC_PROG_][CXX])[AM_DEPENDENCIES(CXX)])])dnl
])

#
# Check to make sure that the build environment is sane.
#

# serial 3

# AM_SANITY_CHECK
# ---------------
AC_DEFUN([AM_SANITY_CHECK],
[AC_MSG_CHECKING([whether build environment is sane])
# Just in case
sleep 1
echo timestamp > conftest.file
# Do `set' in a subshell so we don't clobber the current shell's
# arguments.  Must try -L first in case configure is actually a
# symlink; some systems play weird games with the mod time of symlinks
# (eg FreeBSD returns the mod time of the symlink's containing
# directory).
if (
   set X `ls -Lt $srcdir/configure conftest.file 2> /dev/null`
   if test "$[*]" = "X"; then
      # -L didn't work.
      set X `ls -t $srcdir/configure conftest.file`
   fi
   rm -f conftest.file
   if test "$[*]" != "X $srcdir/configure conftest.file" \
      && test "$[*]" != "X conftest.file $srcdir/configure"; then

      # If neither matched, then we have a broken ls.  This can happen
      # if, for instance, CONFIG_SHELL is bash and it inherits a
      # broken ls alias from the environment.  This has actually
      # happened.  Such a system could not be considered "sane".
      AC_MSG_ERROR([ls -t appears to fail.  Make sure there is not a broken
alias in your environment])
   fi

   test "$[2]" = conftest.file
   )
then
   # Ok.
   :
else
   AC_MSG_ERROR([newly created file is older than distributed files!
Check your system clock])
fi
AC_MSG_RESULT(yes)])


# serial 2

# AM_MISSING_PROG(NAME, PROGRAM)
# ------------------------------
AC_DEFUN([AM_MISSING_PROG],
[AC_REQUIRE([AM_MISSING_HAS_RUN])
$1=${$1-"${am_missing_run}$2"}
AC_SUBST($1)])


# AM_MISSING_INSTALL_SH
# ---------------------
# Like AM_MISSING_PROG, but only looks for install-sh.
AC_DEFUN([AM_MISSING_INSTALL_SH],
[AC_REQUIRE([AM_MISSING_HAS_RUN])
if test -z "$install_sh"; then
   for install_sh in "$ac_aux_dir/install-sh" \
                     "$ac_aux_dir/install.sh" \
                     "${am_missing_run}${ac_auxdir}/install-sh";
   do
     test -f "$install_sh" && break
   done
   # FIXME: an evil hack: we remove the SHELL invocation from
   # install_sh because automake adds it back in.  Sigh.
   install_sh=`echo $install_sh | sed -e 's/\${SHELL}//'`
fi
AC_SUBST(install_sh)])


# AM_MISSING_HAS_RUN
# ------------------
# Define MISSING if not defined so far and test if it supports --run.
# If it does, set am_missing_run to use it, otherwise, to nothing.
AC_DEFUN([AM_MISSING_HAS_RUN],
[test x"${MISSING+set}" = xset ||
  MISSING="\${SHELL} `CDPATH=:; cd $ac_aux_dir && pwd`/missing"
# Use eval to expand $SHELL
if eval "$MISSING --run true"; then
  am_missing_run="$MISSING --run "
else
  am_missing_run=
  am_backtick='`'
  AC_MSG_WARN([${am_backtick}missing' script is too old or missing])
fi
])

# AM_AUX_DIR_EXPAND

# For projects using AC_CONFIG_AUX_DIR([foo]), Autoconf sets
# $ac_aux_dir to ${srcdir}/foo.  In other projects, it is set to `.'.
# Of course, Automake must honor this variable whenever it call a tool
# from the auxiliary directory.  The problem is that $srcdir (hence
# $ac_aux_dir) can be either an absolute path or a path relative to
# $top_srcdir or absolute, this depends on how configure is run.  This
# is pretty anoying since it makes $ac_aux_dir quite unusable in
# subdirectories: on the top source directory, any form will work
# fine, but in subdirectories relative pat needs to be adapted.
# - calling $top_srcidr/$ac_aux_dir/missing would success if $srcdir is
#   relative, but fail if $srcdir is absolute
# - conversly, calling $ax_aux_dir/missing would fail if $srcdir is
#   absolute, and success on relative paths.
#
# Consequently, we define and use $am_aux_dir, the "always absolute"
# version of $ac_aux_dir.

AC_DEFUN([AM_AUX_DIR_EXPAND], [
# expand $ac_aux_dir to an absolute path
am_aux_dir=`CDPATH=:; cd $ac_aux_dir && pwd`
])

# One issue with vendor `install' (even GNU) is that you can't
# specify the program used to strip binaries.  This is especially
# annoying in cross-compiling environments, where the build's strip
# is unlikely to handle the host's binaries.
# Fortunately install-sh will honor a STRIPPROG variable, so we
# always use install-sh in `make install-strip', and initialize
# STRIPPROG with the value of the STRIP variable (set by the user).
AC_DEFUN([AM_PROG_INSTALL_STRIP],
[AC_REQUIRE([AM_MISSING_INSTALL_SH])dnl
_am_dirpart="`echo $install_sh | sed -e 's,//*[[^/]]*$,,'`"
INSTALL_STRIP_PROGRAM="\${SHELL} \`CDPATH=: && cd $_am_dirpart && pwd\`/install-sh -c -s"
AC_SUBST([INSTALL_STRIP_PROGRAM])])

# serial 3

# There are a few dirty hacks below to avoid letting `AC_PROG_CC' be
# written in clear, in which case automake, when reading aclocal.m4,
# will think it sees a *use*, and therefore will trigger all it's
# C support machinery.  Also note that it means that autoscan, seeing
# CC etc. in the Makefile, will ask for an AC_PROG_CC use...

# AM_DEPENDENCIES(NAME)
# ---------------------
# See how the compiler implements dependency checking.
# NAME is "CC", "CXX" or "OBJC".
# We try a few techniques and use that to set a single cache variable.
AC_DEFUN([AM_DEPENDENCIES],
[AC_REQUIRE([AM_SET_DEPDIR])dnl
AC_REQUIRE([AM_OUTPUT_DEPENDENCY_COMMANDS])dnl
am_compiler_list=
ifelse([$1], CC,
       [AC_REQUIRE([AC_PROG_][CC])dnl
AC_REQUIRE([AC_PROG_][CPP])
depcc="$CC"
depcpp="$CPP"],
       [$1], CXX, [AC_REQUIRE([AC_PROG_][CXX])dnl
AC_REQUIRE([AC_PROG_][CXXCPP])
depcc="$CXX"
depcpp="$CXXCPP"],
       [$1], OBJC, [am_compiler_list='gcc3 gcc'
depcc="$OBJC"
depcpp=""],
       [$1], GCJ,  [am_compiler_list='gcc3 gcc'
depcc="$GCJ"
depcpp=""],
       [AC_REQUIRE([AC_PROG_][$1])dnl
depcc="$$1"
depcpp=""])

AC_REQUIRE([AM_MAKE_INCLUDE])
AC_REQUIRE([AM_DEP_TRACK])

AC_CACHE_CHECK([dependency style of $depcc],
               [am_cv_$1_dependencies_compiler_type],
[if test -z "$AMDEP_TRUE" && test -f "$am_depcomp"; then
  # We make a subdir and do the tests there.  Otherwise we can end up
  # making bogus files that we don't know about and never remove.  For
  # instance it was reported that on HP-UX the gcc test will end up
  # making a dummy file named `D' -- because `-MD' means `put the output
  # in D'.
  mkdir confdir
  # Copy depcomp to subdir because otherwise we won't find it if we're
  # using a relative directory.
  cp "$am_depcomp" confdir
  cd confdir

  am_cv_$1_dependencies_compiler_type=none
  if test "$am_compiler_list" = ""; then
     am_compiler_list="`sed -n ['s/^#*\([a-zA-Z0-9]*\))$/\1/p'] < ./depcomp`"
  fi
  for depmode in $am_compiler_list; do
    # We need to recreate these files for each test, as the compiler may
    # overwrite some of them when testing with obscure command lines.
    # This happens at least with the AIX C compiler.
    echo '#include "conftest.h"' > conftest.c
    echo 'int i;' > conftest.h

    case "$depmode" in
    nosideeffect)
      # after this tag, mechanisms are not by side-effect, so they'll
      # only be used when explicitly requested
      if test "x$enable_dependency_tracking" = xyes; then
	continue
      else
	break
      fi
      ;;
    none) break ;;
    esac
    # We check with `-c' and `-o' for the sake of the "dashmstdout"
    # mode.  It turns out that the SunPro C++ compiler does not properly
    # handle `-M -o', and we need to detect this.
    if depmode="$depmode" \
       source=conftest.c object=conftest.o \
       depfile=conftest.Po tmpdepfile=conftest.TPo \
       $SHELL ./depcomp $depcc -c conftest.c -o conftest.o >/dev/null 2>&1 &&
       grep conftest.h conftest.Po > /dev/null 2>&1; then
      am_cv_$1_dependencies_compiler_type="$depmode"
      break
    fi
  done

  cd ..
  rm -rf confdir
else
  am_cv_$1_dependencies_compiler_type=none
fi
])
$1DEPMODE="depmode=$am_cv_$1_dependencies_compiler_type"
AC_SUBST([$1DEPMODE])
])


# AM_SET_DEPDIR
# -------------
# Choose a directory name for dependency files.
# This macro is AC_REQUIREd in AM_DEPENDENCIES
AC_DEFUN([AM_SET_DEPDIR],
[if test -d .deps || mkdir .deps 2> /dev/null || test -d .deps; then
  DEPDIR=.deps
  # We redirect because .deps might already exist and be populated.
  # In this situation we don't want to see an error.
  rmdir .deps > /dev/null 2>&1
else
  DEPDIR=_deps
fi
AC_SUBST(DEPDIR)
])


# AM_DEP_TRACK
# ------------
AC_DEFUN([AM_DEP_TRACK],
[AC_ARG_ENABLE(dependency-tracking,
[  --disable-dependency-tracking Speeds up one-time builds
  --enable-dependency-tracking  Do not reject slow dependency extractors])
if test "x$enable_dependency_tracking" != xno; then
  am_depcomp="$ac_aux_dir/depcomp"
  AMDEPBACKSLASH='\'
fi
AM_CONDITIONAL([AMDEP], [test "x$enable_dependency_tracking" != xno])
pushdef([subst], defn([AC_SUBST]))
subst(AMDEPBACKSLASH)
popdef([subst])
])

# Generate code to set up dependency tracking.
# This macro should only be invoked once -- use via AC_REQUIRE.
# Usage:
# AM_OUTPUT_DEPENDENCY_COMMANDS

#
# This code is only required when automatic dependency tracking
# is enabled.  FIXME.  This creates each `.P' file that we will
# need in order to bootstrap the dependency handling code.
AC_DEFUN([AM_OUTPUT_DEPENDENCY_COMMANDS],[
AC_OUTPUT_COMMANDS([
test x"$AMDEP_TRUE" != x"" ||
for mf in $CONFIG_FILES; do
  case "$mf" in
  Makefile) dirpart=.;;
  */Makefile) dirpart=`echo "$mf" | sed -e 's|/[^/]*$||'`;;
  *) continue;;
  esac
  grep '^DEP_FILES *= *[^ #]' < "$mf" > /dev/null || continue
  # Extract the definition of DEP_FILES from the Makefile without
  # running `make'.
  DEPDIR=`sed -n -e '/^DEPDIR = / s///p' < "$mf"`
  test -z "$DEPDIR" && continue
  # When using ansi2knr, U may be empty or an underscore; expand it
  U=`sed -n -e '/^U = / s///p' < "$mf"`
  test -d "$dirpart/$DEPDIR" || mkdir "$dirpart/$DEPDIR"
  # We invoke sed twice because it is the simplest approach to
  # changing $(DEPDIR) to its actual value in the expansion.
  for file in `sed -n -e '
    /^DEP_FILES = .*\\\\$/ {
      s/^DEP_FILES = //
      :loop
	s/\\\\$//
	p
	n
	/\\\\$/ b loop
      p
    }
    /^DEP_FILES = / s/^DEP_FILES = //p' < "$mf" | \
       sed -e 's/\$(DEPDIR)/'"$DEPDIR"'/g' -e 's/\$U/'"$U"'/g'`; do
    # Make sure the directory exists.
    test -f "$dirpart/$file" && continue
    fdir=`echo "$file" | sed -e 's|/[^/]*$||'`
    $ac_aux_dir/mkinstalldirs "$dirpart/$fdir" > /dev/null 2>&1
    # echo "creating $dirpart/$file"
    echo '# dummy' > "$dirpart/$file"
  done
done
], [AMDEP_TRUE="$AMDEP_TRUE"
ac_aux_dir="$ac_aux_dir"])])

# AM_MAKE_INCLUDE()
# -----------------
# Check to see how make treats includes.
AC_DEFUN([AM_MAKE_INCLUDE],
[am_make=${MAKE-make}
cat > confinc << 'END'
doit:
	@echo done
END
# If we don't find an include directive, just comment out the code.
AC_MSG_CHECKING([for style of include used by $am_make])
_am_include='#'
_am_quote=
_am_result=none
# First try GNU make style include.
echo "include confinc" > confmf
# We grep out `Entering directory' and `Leaving directory'
# messages which can occur if `w' ends up in MAKEFLAGS.
# In particular we don't look at `^make:' because GNU make might
# be invoked under some other name (usually "gmake"), in which
# case it prints its new name instead of `make'.
if test "`$am_make -s -f confmf 2> /dev/null | fgrep -v 'ing directory'`" = "done"; then
   _am_include=include
   _am_quote=
   _am_result=GNU
fi
# Now try BSD make style include.
if test "$_am_include" = "#"; then
   echo '.include "confinc"' > confmf
   if test "`$am_make -s -f confmf 2> /dev/null`" = "done"; then
      _am_include=.include
      _am_quote='"'
      _am_result=BSD
   fi
fi
AC_SUBST(_am_include)
AC_SUBST(_am_quote)
AC_MSG_RESULT($_am_result)
rm -f confinc confmf
])

# serial 3

# AM_CONDITIONAL(NAME, SHELL-CONDITION)
# -------------------------------------
# Define a conditional.
#
# FIXME: Once using 2.50, use this:
# m4_match([$1], [^TRUE\|FALSE$], [AC_FATAL([$0: invalid condition: $1])])dnl
AC_DEFUN([AM_CONDITIONAL],
[ifelse([$1], [TRUE],
        [errprint(__file__:__line__: [$0: invalid condition: $1
])dnl
m4exit(1)])dnl
ifelse([$1], [FALSE],
       [errprint(__file__:__line__: [$0: invalid condition: $1
])dnl
m4exit(1)])dnl
AC_SUBST([$1_TRUE])
AC_SUBST([$1_FALSE])
if $2; then
  $1_TRUE=
  $1_FALSE='#'
else
  $1_TRUE='#'
  $1_FALSE=
fi])


# serial 40 AC_PROG_LIBTOOL
AC_DEFUN(AC_PROG_LIBTOOL,
[AC_REQUIRE([AC_LIBTOOL_SETUP])dnl

# Save cache, so that ltconfig can load it
AC_CACHE_SAVE

# Actually configure libtool.  ac_aux_dir is where install-sh is found.
CC="$CC" CFLAGS="$CFLAGS" CPPFLAGS="$CPPFLAGS" \
LD="$LD" LDFLAGS="$LDFLAGS" LIBS="$LIBS" \
LN_S="$LN_S" NM="$NM" RANLIB="$RANLIB" \
DLLTOOL="$DLLTOOL" AS="$AS" OBJDUMP="$OBJDUMP" \
${CONFIG_SHELL-/bin/sh} $ac_aux_dir/ltconfig --no-reexec \
$libtool_flags --no-verify $ac_aux_dir/ltmain.sh $lt_target \
|| AC_MSG_ERROR([libtool configure failed])

# Reload cache, that may have been modified by ltconfig
AC_CACHE_LOAD

# This can be used to rebuild libtool when needed
LIBTOOL_DEPS="$ac_aux_dir/ltconfig $ac_aux_dir/ltmain.sh"

# Always use our own libtool.
LIBTOOL='$(SHELL) $(top_builddir)/libtool'
AC_SUBST(LIBTOOL)dnl

# Redirect the config.log output again, so that the ltconfig log is not
# clobbered by the next message.
exec 5>>./config.log
])

AC_DEFUN(AC_LIBTOOL_SETUP,
[AC_PREREQ(2.13)dnl
AC_REQUIRE([AC_ENABLE_SHARED])dnl
AC_REQUIRE([AC_ENABLE_STATIC])dnl
AC_REQUIRE([AC_ENABLE_FAST_INSTALL])dnl
AC_REQUIRE([AC_CANONICAL_HOST])dnl
AC_REQUIRE([AC_CANONICAL_BUILD])dnl
AC_REQUIRE([AC_PROG_RANLIB])dnl
AC_REQUIRE([AC_PROG_CC])dnl
AC_REQUIRE([AC_PROG_LD])dnl
AC_REQUIRE([AC_PROG_NM])dnl
AC_REQUIRE([AC_PROG_LN_S])dnl
dnl

case "$target" in
NONE) lt_target="$host" ;;
*) lt_target="$target" ;;
esac

# Check for any special flags to pass to ltconfig.
libtool_flags="--cache-file=$cache_file"
test "$enable_shared" = no && libtool_flags="$libtool_flags --disable-shared"
test "$enable_static" = no && libtool_flags="$libtool_flags --disable-static"
test "$enable_fast_install" = no && libtool_flags="$libtool_flags --disable-fast-install"
test "$ac_cv_prog_gcc" = yes && libtool_flags="$libtool_flags --with-gcc"
test "$ac_cv_prog_gnu_ld" = yes && libtool_flags="$libtool_flags --with-gnu-ld"
ifdef([AC_PROVIDE_AC_LIBTOOL_DLOPEN],
[libtool_flags="$libtool_flags --enable-dlopen"])
ifdef([AC_PROVIDE_AC_LIBTOOL_WIN32_DLL],
[libtool_flags="$libtool_flags --enable-win32-dll"])
AC_ARG_ENABLE(libtool-lock,
  [  --disable-libtool-lock  avoid locking (might break parallel builds)])
test "x$enable_libtool_lock" = xno && libtool_flags="$libtool_flags --disable-lock"
test x"$silent" = xyes && libtool_flags="$libtool_flags --silent"

# Some flags need to be propagated to the compiler or linker for good
# libtool support.
case "$lt_target" in
*-*-irix6*)
  # Find out which ABI we are using.
  echo '[#]line __oline__ "configure"' > conftest.$ac_ext
  if AC_TRY_EVAL(ac_compile); then
    case "`/usr/bin/file conftest.o`" in
    *32-bit*)
      LD="${LD-ld} -32"
      ;;
    *N32*)
      LD="${LD-ld} -n32"
      ;;
    *64-bit*)
      LD="${LD-ld} -64"
      ;;
    esac
  fi
  rm -rf conftest*
  ;;

*-*-sco3.2v5*)
  # On SCO OpenServer 5, we need -belf to get full-featured binaries.
  SAVE_CFLAGS="$CFLAGS"
  CFLAGS="$CFLAGS -belf"
  AC_CACHE_CHECK([whether the C compiler needs -belf], lt_cv_cc_needs_belf,
    [AC_TRY_LINK([],[],[lt_cv_cc_needs_belf=yes],[lt_cv_cc_needs_belf=no])])
  if test x"$lt_cv_cc_needs_belf" != x"yes"; then
    # this is probably gcc 2.8.0, egcs 1.0 or newer; no need for -belf
    CFLAGS="$SAVE_CFLAGS"
  fi
  ;;

ifdef([AC_PROVIDE_AC_LIBTOOL_WIN32_DLL],
[*-*-cygwin* | *-*-mingw*)
  AC_CHECK_TOOL(DLLTOOL, dlltool, false)
  AC_CHECK_TOOL(AS, as, false)
  AC_CHECK_TOOL(OBJDUMP, objdump, false)
  ;;
])
esac
])

# AC_LIBTOOL_DLOPEN - enable checks for dlopen support
AC_DEFUN(AC_LIBTOOL_DLOPEN, [AC_BEFORE([$0],[AC_LIBTOOL_SETUP])])

# AC_LIBTOOL_WIN32_DLL - declare package support for building win32 dll's
AC_DEFUN(AC_LIBTOOL_WIN32_DLL, [AC_BEFORE([$0], [AC_LIBTOOL_SETUP])])

# AC_ENABLE_SHARED - implement the --enable-shared flag
# Usage: AC_ENABLE_SHARED[(DEFAULT)]
#   Where DEFAULT is either `yes' or `no'.  If omitted, it defaults to
#   `yes'.
AC_DEFUN(AC_ENABLE_SHARED, [dnl
define([AC_ENABLE_SHARED_DEFAULT], ifelse($1, no, no, yes))dnl
AC_ARG_ENABLE(shared,
changequote(<<, >>)dnl
<<  --enable-shared[=PKGS]  build shared libraries [default=>>AC_ENABLE_SHARED_DEFAULT],
changequote([, ])dnl
[p=${PACKAGE-default}
case "$enableval" in
yes) enable_shared=yes ;;
no) enable_shared=no ;;
*)
  enable_shared=no
  # Look at the argument we got.  We use all the common list separators.
  IFS="${IFS= 	}"; ac_save_ifs="$IFS"; IFS="${IFS}:,"
  for pkg in $enableval; do
    if test "X$pkg" = "X$p"; then
      enable_shared=yes
    fi
  done
  IFS="$ac_save_ifs"
  ;;
esac],
enable_shared=AC_ENABLE_SHARED_DEFAULT)dnl
])

# AC_DISABLE_SHARED - set the default shared flag to --disable-shared
AC_DEFUN(AC_DISABLE_SHARED, [AC_BEFORE([$0],[AC_LIBTOOL_SETUP])dnl
AC_ENABLE_SHARED(no)])

# AC_ENABLE_STATIC - implement the --enable-static flag
# Usage: AC_ENABLE_STATIC[(DEFAULT)]
#   Where DEFAULT is either `yes' or `no'.  If omitted, it defaults to
#   `yes'.
AC_DEFUN(AC_ENABLE_STATIC, [dnl
define([AC_ENABLE_STATIC_DEFAULT], ifelse($1, no, no, yes))dnl
AC_ARG_ENABLE(static,
changequote(<<, >>)dnl
<<  --enable-static[=PKGS]  build static libraries [default=>>AC_ENABLE_STATIC_DEFAULT],
changequote([, ])dnl
[p=${PACKAGE-default}
case "$enableval" in
yes) enable_static=yes ;;
no) enable_static=no ;;
*)
  enable_static=no
  # Look at the argument we got.  We use all the common list separators.
  IFS="${IFS= 	}"; ac_save_ifs="$IFS"; IFS="${IFS}:,"
  for pkg in $enableval; do
    if test "X$pkg" = "X$p"; then
      enable_static=yes
    fi
  done
  IFS="$ac_save_ifs"
  ;;
esac],
enable_static=AC_ENABLE_STATIC_DEFAULT)dnl
])

# AC_DISABLE_STATIC - set the default static flag to --disable-static
AC_DEFUN(AC_DISABLE_STATIC, [AC_BEFORE([$0],[AC_LIBTOOL_SETUP])dnl
AC_ENABLE_STATIC(no)])


# AC_ENABLE_FAST_INSTALL - implement the --enable-fast-install flag
# Usage: AC_ENABLE_FAST_INSTALL[(DEFAULT)]
#   Where DEFAULT is either `yes' or `no'.  If omitted, it defaults to
#   `yes'.
AC_DEFUN(AC_ENABLE_FAST_INSTALL, [dnl
define([AC_ENABLE_FAST_INSTALL_DEFAULT], ifelse($1, no, no, yes))dnl
AC_ARG_ENABLE(fast-install,
changequote(<<, >>)dnl
<<  --enable-fast-install[=PKGS]  optimize for fast installation [default=>>AC_ENABLE_FAST_INSTALL_DEFAULT],
changequote([, ])dnl
[p=${PACKAGE-default}
case "$enableval" in
yes) enable_fast_install=yes ;;
no) enable_fast_install=no ;;
*)
  enable_fast_install=no
  # Look at the argument we got.  We use all the common list separators.
  IFS="${IFS= 	}"; ac_save_ifs="$IFS"; IFS="${IFS}:,"
  for pkg in $enableval; do
    if test "X$pkg" = "X$p"; then
      enable_fast_install=yes
    fi
  done
  IFS="$ac_save_ifs"
  ;;
esac],
enable_fast_install=AC_ENABLE_FAST_INSTALL_DEFAULT)dnl
])

# AC_ENABLE_FAST_INSTALL - set the default to --disable-fast-install
AC_DEFUN(AC_DISABLE_FAST_INSTALL, [AC_BEFORE([$0],[AC_LIBTOOL_SETUP])dnl
AC_ENABLE_FAST_INSTALL(no)])

# AC_PROG_LD - find the path to the GNU or non-GNU linker
AC_DEFUN(AC_PROG_LD,
[AC_ARG_WITH(gnu-ld,
[  --with-gnu-ld           assume the C compiler uses GNU ld [default=no]],
test "$withval" = no || with_gnu_ld=yes, with_gnu_ld=no)
AC_REQUIRE([AC_PROG_CC])dnl
AC_REQUIRE([AC_CANONICAL_HOST])dnl
AC_REQUIRE([AC_CANONICAL_BUILD])dnl
ac_prog=ld
if test "$ac_cv_prog_gcc" = yes; then
  # Check if gcc -print-prog-name=ld gives a path.
  AC_MSG_CHECKING([for ld used by GCC])
  ac_prog=`($CC -print-prog-name=ld) 2>&5`
  case "$ac_prog" in
    # Accept absolute paths.
changequote(,)dnl
    [\\/]* | [A-Za-z]:[\\/]*)
      re_direlt='/[^/][^/]*/\.\./'
changequote([,])dnl
      # Canonicalize the path of ld
      ac_prog=`echo $ac_prog| sed 's%\\\\%/%g'`
      while echo $ac_prog | grep "$re_direlt" > /dev/null 2>&1; do
	ac_prog=`echo $ac_prog| sed "s%$re_direlt%/%"`
      done
      test -z "$LD" && LD="$ac_prog"
      ;;
  "")
    # If it fails, then pretend we aren't using GCC.
    ac_prog=ld
    ;;
  *)
    # If it is relative, then search for the first ld in PATH.
    with_gnu_ld=unknown
    ;;
  esac
elif test "$with_gnu_ld" = yes; then
  AC_MSG_CHECKING([for GNU ld])
else
  AC_MSG_CHECKING([for non-GNU ld])
fi
AC_CACHE_VAL(ac_cv_path_LD,
[if test -z "$LD"; then
  IFS="${IFS= 	}"; ac_save_ifs="$IFS"; IFS="${IFS}${PATH_SEPARATOR-:}"
  for ac_dir in $PATH; do
    test -z "$ac_dir" && ac_dir=.
    if test -f "$ac_dir/$ac_prog" || test -f "$ac_dir/$ac_prog$ac_exeext"; then
      ac_cv_path_LD="$ac_dir/$ac_prog"
      # Check to see if the program is GNU ld.  I'd rather use --version,
      # but apparently some GNU ld's only accept -v.
      # Break only if it was the GNU/non-GNU ld that we prefer.
      if "$ac_cv_path_LD" -v 2>&1 < /dev/null | egrep '(GNU|with BFD)' > /dev/null; then
	test "$with_gnu_ld" != no && break
      else
	test "$with_gnu_ld" != yes && break
      fi
    fi
  done
  IFS="$ac_save_ifs"
else
  ac_cv_path_LD="$LD" # Let the user override the test with a path.
fi])
LD="$ac_cv_path_LD"
if test -n "$LD"; then
  AC_MSG_RESULT($LD)
else
  AC_MSG_RESULT(no)
fi
test -z "$LD" && AC_MSG_ERROR([no acceptable ld found in \$PATH])
AC_PROG_LD_GNU
])

AC_DEFUN(AC_PROG_LD_GNU,
[AC_CACHE_CHECK([if the linker ($LD) is GNU ld], ac_cv_prog_gnu_ld,
[# I'd rather use --version here, but apparently some GNU ld's only accept -v.
if $LD -v 2>&1 </dev/null | egrep '(GNU|with BFD)' 1>&5; then
  ac_cv_prog_gnu_ld=yes
else
  ac_cv_prog_gnu_ld=no
fi])
])

# AC_PROG_NM - find the path to a BSD-compatible name lister
AC_DEFUN(AC_PROG_NM,
[AC_MSG_CHECKING([for BSD-compatible nm])
AC_CACHE_VAL(ac_cv_path_NM,
[if test -n "$NM"; then
  # Let the user override the test.
  ac_cv_path_NM="$NM"
else
  IFS="${IFS= 	}"; ac_save_ifs="$IFS"; IFS="${IFS}${PATH_SEPARATOR-:}"
  for ac_dir in $PATH /usr/ccs/bin /usr/ucb /bin; do
    test -z "$ac_dir" && ac_dir=.
    if test -f $ac_dir/nm || test -f $ac_dir/nm$ac_exeext ; then
      # Check to see if the nm accepts a BSD-compat flag.
      # Adding the `sed 1q' prevents false positives on HP-UX, which says:
      #   nm: unknown option "B" ignored
      if ($ac_dir/nm -B /dev/null 2>&1 | sed '1q'; exit 0) | egrep /dev/null >/dev/null; then
	ac_cv_path_NM="$ac_dir/nm -B"
	break
      elif ($ac_dir/nm -p /dev/null 2>&1 | sed '1q'; exit 0) | egrep /dev/null >/dev/null; then
	ac_cv_path_NM="$ac_dir/nm -p"
	break
      else
	ac_cv_path_NM=${ac_cv_path_NM="$ac_dir/nm"} # keep the first match, but
	continue # so that we can try to find one that supports BSD flags
      fi
    fi
  done
  IFS="$ac_save_ifs"
  test -z "$ac_cv_path_NM" && ac_cv_path_NM=nm
fi])
NM="$ac_cv_path_NM"
AC_MSG_RESULT([$NM])
])

# AC_CHECK_LIBM - check for math library
AC_DEFUN(AC_CHECK_LIBM,
[AC_REQUIRE([AC_CANONICAL_HOST])dnl
LIBM=
case "$lt_target" in
*-*-beos* | *-*-cygwin*)
  # These system don't have libm
  ;;
*-ncr-sysv4.3*)
  AC_CHECK_LIB(mw, _mwvalidcheckl, LIBM="-lmw")
  AC_CHECK_LIB(m, main, LIBM="$LIBM -lm")
  ;;
*)
  AC_CHECK_LIB(m, main, LIBM="-lm")
  ;;
esac
])

# AC_LIBLTDL_CONVENIENCE[(dir)] - sets LIBLTDL to the link flags for
# the libltdl convenience library and INCLTDL to the include flags for
# the libltdl header and adds --enable-ltdl-convenience to the
# configure arguments.  Note that LIBLTDL and INCLTDL are not
# AC_SUBSTed, nor is AC_CONFIG_SUBDIRS called.  If DIR is not
# provided, it is assumed to be `libltdl'.  LIBLTDL will be prefixed
# with '${top_builddir}/' and INCLTDL will be prefixed with
# '${top_srcdir}/' (note the single quotes!).  If your package is not
# flat and you're not using automake, define top_builddir and
# top_srcdir appropriately in the Makefiles.
AC_DEFUN(AC_LIBLTDL_CONVENIENCE, [AC_BEFORE([$0],[AC_LIBTOOL_SETUP])dnl
  case "$enable_ltdl_convenience" in
  no) AC_MSG_ERROR([this package needs a convenience libltdl]) ;;
  "") enable_ltdl_convenience=yes
      ac_configure_args="$ac_configure_args --enable-ltdl-convenience" ;;
  esac
  LIBLTDL='${top_builddir}/'ifelse($#,1,[$1],['libltdl'])/libltdlc.la
  INCLTDL='-I${top_srcdir}/'ifelse($#,1,[$1],['libltdl'])
])

# AC_LIBLTDL_INSTALLABLE[(dir)] - sets LIBLTDL to the link flags for
# the libltdl installable library and INCLTDL to the include flags for
# the libltdl header and adds --enable-ltdl-install to the configure
# arguments.  Note that LIBLTDL and INCLTDL are not AC_SUBSTed, nor is
# AC_CONFIG_SUBDIRS called.  If DIR is not provided and an installed
# libltdl is not found, it is assumed to be `libltdl'.  LIBLTDL will
# be prefixed with '${top_builddir}/' and INCLTDL will be prefixed
# with '${top_srcdir}/' (note the single quotes!).  If your package is
# not flat and you're not using automake, define top_builddir and
# top_srcdir appropriately in the Makefiles.
# In the future, this macro may have to be called after AC_PROG_LIBTOOL.
AC_DEFUN(AC_LIBLTDL_INSTALLABLE, [AC_BEFORE([$0],[AC_LIBTOOL_SETUP])dnl
  AC_CHECK_LIB(ltdl, main,
  [test x"$enable_ltdl_install" != xyes && enable_ltdl_install=no],
  [if test x"$enable_ltdl_install" = xno; then
     AC_MSG_WARN([libltdl not installed, but installation disabled])
   else
     enable_ltdl_install=yes
   fi
  ])
  if test x"$enable_ltdl_install" = x"yes"; then
    ac_configure_args="$ac_configure_args --enable-ltdl-install"
    LIBLTDL='${top_builddir}/'ifelse($#,1,[$1],['libltdl'])/libltdl.la
    INCLTDL='-I${top_srcdir}/'ifelse($#,1,[$1],['libltdl'])
  else
    ac_configure_args="$ac_configure_args --enable-ltdl-install=no"
    LIBLTDL="-lltdl"
    INCLTDL=
  fi
])

dnl old names
AC_DEFUN(AM_PROG_LIBTOOL, [indir([AC_PROG_LIBTOOL])])dnl
AC_DEFUN(AM_ENABLE_SHARED, [indir([AC_ENABLE_SHARED], $@)])dnl
AC_DEFUN(AM_ENABLE_STATIC, [indir([AC_ENABLE_STATIC], $@)])dnl
AC_DEFUN(AM_DISABLE_SHARED, [indir([AC_DISABLE_SHARED], $@)])dnl
AC_DEFUN(AM_DISABLE_STATIC, [indir([AC_DISABLE_STATIC], $@)])dnl
AC_DEFUN(AM_PROG_LD, [indir([AC_PROG_LD])])dnl
AC_DEFUN(AM_PROG_NM, [indir([AC_PROG_NM])])dnl

dnl This is just to silence aclocal about the macro not being used
ifelse([AC_DISABLE_FAST_INSTALL])dnl

# Add --enable-maintainer-mode option to configure.
# From Jim Meyering

# serial 1

AC_DEFUN([AM_MAINTAINER_MODE],
[AC_MSG_CHECKING([whether to enable maintainer-specific portions of Makefiles])
  dnl maintainer-mode is disabled by default
  AC_ARG_ENABLE(maintainer-mode,
[  --enable-maintainer-mode enable make rules and dependencies not useful
                          (and sometimes confusing) to the casual installer],
      USE_MAINTAINER_MODE=$enableval,
      USE_MAINTAINER_MODE=no)
  AC_MSG_RESULT([$USE_MAINTAINER_MODE])
  AM_CONDITIONAL(MAINTAINER_MODE, [test $USE_MAINTAINER_MODE = yes])
  MAINT=$MAINTAINER_MODE_TRUE
  AC_SUBST(MAINT)dnl
]
)

# Usage:
#   SIM_AC_COMPILE_DEBUG([ACTION-IF-DEBUG[, ACTION-IF-NOT-DEBUG]])
#
# Description:
#   Let the user decide if compilation should be done in "debug mode".
#   If compilation is not done in debug mode, all assert()'s in the code
#   will be disabled.
#
#   Also sets enable_debug variable to either "yes" or "no", so the
#   configure.in writer can add package-specific actions. Default is "yes".
#   This was also extended to enable the developer to set up the two first
#   macro arguments following the well-known ACTION-IF / ACTION-IF-NOT
#   concept.
#
# Authors:
#   Morten Eriksen, <mortene@sim.no>
#   Lars J. Aas, <larsa@sim.no>
#

AC_DEFUN([SIM_AC_COMPILE_DEBUG], [
AC_ARG_ENABLE(
  [debug],
  AC_HELP_STRING([--enable-debug], [compile in debug mode [[default=yes]]]),
  [case "${enableval}" in
    yes) enable_debug=true ;;
    no)  enable_debug=false ;;
    true | false) enable_debug=${enableval} ;;
    *) AC_MSG_ERROR(bad value "${enableval}" for --enable-debug) ;;
  esac],
  [enable_debug=true])

if $enable_debug; then
  DSUFFIX=d
  ifelse([$1], , :, [$1])
else
  DSUFFIX=
  CPPFLAGS="$CPPFLAGS -DNDEBUG"
  ifelse([$2], , :, [$2])
fi
AC_SUBST(DSUFFIX)
])


# Usage:
#   SIM_AC_DEBUGSYMBOLS
#
# Description:
#   Let the user decide if debug symbol information should be compiled
#   in. The compiled libraries/executables will use a lot less space
#   if stripped for their symbol information.
# 
#   Note: this macro must be placed after either AC_PROG_CC or AC_PROG_CXX
#   in the configure.in script.
# 
# Author: Morten Eriksen, <mortene@sim.no>.
# 

AC_DEFUN([SIM_AC_DEBUGSYMBOLS], [
AC_ARG_ENABLE(
  [symbols],
  AC_HELP_STRING([--enable-symbols],
                 [include symbol debug information [[default=yes]]]),
  [case "${enableval}" in
    yes) enable_symbols=yes ;;
    no)  enable_symbols=no ;;
    *) AC_MSG_ERROR(bad value "${enableval}" for --enable-symbols) ;;
  esac],
  [enable_symbols=yes])

if test x"$enable_symbols" = x"no"; then
  CFLAGS="`echo $CFLAGS | sed 's/-g//'`"
  CPPFLAGS="`echo $CPPFLAGS | sed 's/-g//'`"
  CXXFLAGS="`echo $CXXFLAGS | sed 's/-g//'`"
fi
])

# Usage:
#   SIM_AC_CHECK_MATHLIB([ACTION-IF-OK[, ACTION-IF-NOT-OK]])
#
# Description:
#   Check if linker needs to explicitly link with the library with
#   math functions. Sets environment variable $sim_ac_libm to the
#   necessary linklibrary, plus includes this library in the LIBS
#   env variable.
#
# Notes:
#   There is a macro AC_CHECK_LIBM in the libtool distribution, but it
#   does at least not work with SGI MIPSpro CC v7.30.
#
# Authors:
#   Lars J�rgen Aas, <larsa@sim.no>
#   Morten Eriksen, <mortene@sim.no>
#   Rupert Kittinger, <kittinger@mechanik.tu-graz.ac.at>
#

AC_DEFUN([SIM_AC_CHECK_MATHLIB],
[sim_ac_libm=

AC_CACHE_CHECK(
  [for math functions library],
  [sim_cv_lib_math],
  [sim_cv_lib_math=UNDEFINED
  # BeOS and MSWin platforms has implicit math library linking,
  # and ncr-sysv4.3 might use -lmw (according to AC_CHECK_LIBM in
  # libtool.m4).
  for sim_ac_math_chk in "" -lm -lmw; do
    if test x"$sim_cv_lib_math" = xUNDEFINED; then
      sim_ac_store_libs=$LIBS
      LIBS="$sim_ac_store_libs $sim_ac_math_chk"
      AC_TRY_LINK([#include <math.h>
                  #include <stdlib.h>
                  #include <stdio.h>],
                  [char s[16];
                   /*
                      SGI IRIX MIPSpro compilers may "fold" math
                      functions with constant arguments already
                      at compile time.

                      It is also theoretically possible to do this
                      for atof(), so to be _absolutely_ sure the
                      math functions aren't replaced by constants at
                      compile time, we get the arguments from a guaranteed
                      non-constant source (stdin).
                   */
                  fmod(atof(fgets(s,15,stdin)), atof(fgets(s,15,stdin)));
                  pow(atof(fgets(s,15,stdin)), atof(fgets(s,15,stdin)));
                  exp(atof(fgets(s,15,stdin)));
                  sin(atof(fgets(s,15,stdin)))],
                  [sim_cv_lib_math=$sim_ac_math_chk])
      LIBS=$sim_ac_store_libs
    fi
  done
  ])

if test x"$sim_cv_lib_math" != xUNDEFINED; then
  sim_ac_libm=$sim_cv_lib_math
  LIBS="$sim_ac_libm $LIBS"
  $1
else
  ifelse([$2], , :, [$2])
fi
])# SIM_AC_CHECK_MATHLIB

# **************************************************************************
# SIM_AC_MATHLIB_READY_IFELSE( [ACTION-IF-TRUE], [ACTION-IF-FALSE] )

AC_DEFUN([SIM_AC_MATHLIB_READY_IFELSE],
[AC_CACHE_CHECK(
  [if mathlib linkage is ready],
  [sim_cv_mathlib_ready],
  [AC_TRY_LINK(
    [#include <math.h>
    #include <stdlib.h>
    #include <stdio.h>],
    [char s[16];
    /*
    SGI IRIX MIPSpro compilers may "fold" math
    functions with constant arguments already
    at compile time.

    It is also theoretically possible to do this
    for atof(), so to be _absolutely_ sure the
    math functions aren't replaced by constants at
    compile time, we get the arguments from a guaranteed
    non-constant source (stdin).
    */
    printf("> %g\n",fmod(atof(fgets(s,15,stdin)), atof(fgets(s,15,stdin))));
    printf("> %g\n",pow(atof(fgets(s,15,stdin)), atof(fgets(s,15,stdin))));
    printf("> %g\n",exp(atof(fgets(s,15,stdin))));
    printf("> %g\n",sin(atof(fgets(s,15,stdin))))],
    [sim_cv_mathlib_ready=true],
    [sim_cv_mathlib_ready=false])])
if ${sim_cv_mathlib_ready}; then
  ifelse([$1], , :, [$1])
else
  ifelse([$2], , :, [$2])
fi
]) # SIM_AC_MATHLIB_READY_IFELSE()


# **************************************************************************
# SIM_AC_HAVE_LIBUNGIF_IFELSE( IF-FOUND, IF-NOT-FOUND )
#
# Variables:
#   sim_ac_have_libungif
#   sim_ac_libungif_cppflags
#   sim_ac_libungif_ldflags
#   sim_ac_libungif_libs
#
# Authors:
#   Lars J. Aas <larsa@coin3d.org>
#   Morten Eriksen <mortene@coin3d.org>
#
# Todo:
# - use AS_UNSET to unset internal variables to avoid polluting the environment
#

# **************************************************************************

AC_DEFUN([SIM_AC_HAVE_LIBUNGIF_IFELSE],
[AC_REQUIRE([AC_PATH_X])
: ${sim_ac_have_libungif=false}
AC_MSG_CHECKING([for libungif])
AC_ARG_WITH(
  [ungif],
  [AC_HELP_STRING([--with-ungif=PATH], [enable/disable libungif support])],
  [case $withval in
  yes | "") sim_ac_want_libungif=true ;;
  no)       sim_ac_want_libungif=false ;;
  *)        sim_ac_want_libungif=true
            sim_ac_libungif_path=$withval ;;
  esac],
  [sim_ac_want_libungif=true])
case $sim_ac_want_libungif in
true)
  $sim_ac_have_libungif && break
  sim_ac_libungif_save_CPPFLAGS=$CPPFLAGS
  sim_ac_libungif_save_LDFLAGS=$LDFLAGS
  sim_ac_libungif_save_LIBS=$LIBS
  sim_ac_libungif_debug=false
  test -n "`echo -- $CPPFLAGS $CFLAGS $CXXFLAGS | grep -- '-g\\>'`" &&
    sim_ac_libungif_debug=true
  test -z "$sim_ac_libungif_path" -a x"$prefix" != xNONE &&
    sim_ac_libungif_path=$prefix
  sim_ac_libungif_name=ungif
  if test -n "$sim_ac_libungif_path"; then
    for sim_ac_libungif_candidate in \
      `( ls $sim_ac_libungif_path/lib/ungif*.lib;
         ls $sim_ac_libungif_path/lib/ungif*d.lib ) 2>/dev/null`
    do
      case $sim_ac_libungif_candidate in
      *d.lib)
        $sim_ac_libungif_debug &&
          sim_ac_libungif_name=`basename $sim_ac_libungif_candidate .lib` ;;
      *.lib)
        sim_ac_libungif_name=`basename $sim_ac_libungif_candidate .lib` ;;
      esac
    done
    sim_ac_libungif_cppflags="-I$sim_ac_libungif_path/include"
    CPPFLAGS="$CPPFLAGS $sim_ac_libungif_cppflags"
    sim_ac_libungif_ldflags="-L$sim_ac_libungif_path/lib"
    LDFLAGS="$LDFLAGS $sim_ac_libungif_ldflags"
    # unset sim_ac_libungif_candidate
    # unset sim_ac_libungif_path
  fi
  sim_ac_libungif_libs="-l$sim_ac_libungif_name"
  LIBS="$sim_ac_libungif_libs $LIBS"
  AC_TRY_LINK(
    [#include <gif_lib.h>],
    [(void)EGifOpenFileName(0L, 0);],
    [sim_ac_have_libungif=true])
  # libungif has become dependent on Xlib :(
  if test x"$sim_ac_have_libungif" = xfalse; then
    if test x"$x_includes" != x""; then
      sim_ac_libungif_cppflags="$sim_ac_libungif_cppflags -I$x_includes"
      CPPFLAGS="$sim_ac_libungif_cppflags $sim_ac_libungif_save_CPPFLAGS"
    fi
    if test x"$x_libraries" != x""; then
      sim_ac_libungif_ldflags="$sim_ac_libungif_ldflags -L$x_libraries"
      LDFLAGS="$sim_ac_libungif_ldflags $sim_ac_libungif_save_LDFLAGS"
    fi
    sim_ac_libungif_libs="-l$sim_ac_libungif_name -lX11"
    LIBS="$sim_ac_libungif_libs $sim_ac_libungif_save_LIBS"
    AC_TRY_LINK(
      [#include <gif_lib.h>],
      [(void)EGifOpenFileName(0L, 0);],
      [sim_ac_have_libungif=true])
  fi
  CPPFLAGS=$sim_ac_libungif_save_CPPFLAGS
  LDFLAGS=$sim_ac_libungif_save_LDFLAGS
  LIBS=$sim_ac_libungif_save_LIBS
  # unset sim_ac_libungif_debug
  # unset sim_ac_libungif_name
  # unset sim_ac_libungif_save_CPPFLAGS
  # unset sim_ac_libungif_save_LDFLAGS
  # unset sim_ac_libungif_save_LIBS
  ;;
esac

if $sim_ac_want_libungif; then
  if $sim_ac_have_libungif; then
    AC_MSG_RESULT([success ($sim_ac_libungif_libs)])
    $1
  else
    AC_MSG_RESULT([failure])
    $2
  fi
else
  AC_MSG_RESULT([disabled])
  $2
fi
# unset sim_ac_want_libungif
])

# EOF **********************************************************************

# **************************************************************************
# configuration_summary.m4
#
# This file contains some utility macros for making it easy to have a short
# summary of the important configuration settings printed at the end of the
# configure run.
#
# Authors:
#   Lars J. Aas <larsa@sim.no>
#

# **************************************************************************
# SIM_AC_CONFIGURATION_SETTING( DESCRIPTION, SETTING )
#
# This macro registers a configuration setting to be dumped by the
# SIM_AC_CONFIGURATION_SUMMARY macro.

AC_DEFUN([SIM_AC_CONFIGURATION_SETTING],
[if test x${sim_ac_configuration_settings+set} != xset; then
  sim_ac_configuration_settings="$1:$2"
else
  sim_ac_configuration_settings="$sim_ac_configuration_settings|$1:$2"
fi
]) # SIM_AC_CONFIGURATION_SETTING

# **************************************************************************
# SIM_AC_CONFIGURATION_WARNING( WARNING )
#
# This macro registers a configuration warning to be dumped by the
# SIM_AC_CONFIGURATION_SUMMARY macro.

AC_DEFUN([SIM_AC_CONFIGURATION_WARNING],
[if test x${sim_ac_configuration_warnings+set} != xset; then
  sim_ac_configuration_warnings="$1"
else
  sim_ac_configuration_warnings="$sim_ac_configuration_warnings|$1"
fi
]) # SIM_AC_CONFIGURATION_WARNING

# **************************************************************************
# SIM_AC_CONFIGURATION_SUMMARY
#
# This macro dumps the settings and warnings summary.

AC_DEFUN([SIM_AC_CONFIGURATION_SUMMARY],
[sim_ac_settings=$sim_ac_configuration_settings
sim_ac_num_settings=`echo "$sim_ac_settings" | tr -d -c "|" | wc -c`
sim_ac_maxlength=0
while test $sim_ac_num_settings -ge 0; do
  sim_ac_description=`echo "$sim_ac_settings" | cut -d: -f1`
  sim_ac_length=`echo "$sim_ac_description" | wc -c`
  if test $sim_ac_length -gt $sim_ac_maxlength; then
    sim_ac_maxlength=`expr $sim_ac_length + 0`
  fi
  sim_ac_settings=`echo $sim_ac_settings | cut -d"|" -f2-`
  sim_ac_num_settings=`expr $sim_ac_num_settings - 1`
done

sim_ac_maxlength=`expr $sim_ac_maxlength + 3`
sim_ac_padding=`echo "                                             " |
  cut -c1-$sim_ac_maxlength`

sim_ac_num_settings=`echo "$sim_ac_configuration_settings" | tr -d -c "|" | wc -c`
echo ""
echo "$PACKAGE configuration settings:"
while test $sim_ac_num_settings -ge 0; do
  sim_ac_setting=`echo $sim_ac_configuration_settings | cut -d"|" -f1`
  sim_ac_description=`echo "$sim_ac_setting" | cut -d: -f1`
  sim_ac_status=`echo "$sim_ac_setting" | cut -d: -f2-`
  # hopefully not too many terminals are too dumb for this
  echo -e "$sim_ac_padding $sim_ac_status\r  $sim_ac_description:"
  sim_ac_configuration_settings=`echo $sim_ac_configuration_settings | cut -d"|" -f2-`
  sim_ac_num_settings=`expr $sim_ac_num_settings - 1`
done

if test x${sim_ac_configuration_warnings+set} = xset; then
sim_ac_num_warnings=`echo "$sim_ac_configuration_warnings" | tr -d -c "|" | wc -c`
echo ""
echo "$PACKAGE configuration warnings:"
while test $sim_ac_num_warnings -ge 0; do
  sim_ac_warning=`echo "$sim_ac_configuration_warnings" | cut -d"|" -f1`
  echo "  * $sim_ac_warning"
  sim_ac_configuration_warnings=`echo $sim_ac_configuration_warnings | cut -d"|" -f2-`
  sim_ac_num_warnings=`expr $sim_ac_num_warnings - 1`
done
fi
]) # SIM_AC_CONFIGURATION_SUMMARY


# **************************************************************************
# SIM_AC_HAVE_LIBJPEG_IFELSE( IF-FOUND, IF-NOT-FOUND )
#
# Variables:
#   sim_ac_have_libjpeg
#   sim_ac_libjpeg_cppflags
#   sim_ac_libjpeg_ldflags
#   sim_ac_libjpeg_libs
#
# Authors:
#   Lars J. Aas <larsa@coin3d.org>
#   Morten Eriksen <mortene@coin3d.org>
#
# Todo:
# - use AS_UNSET to unset internal variables to avoid polluting the environment
#

# **************************************************************************

AC_DEFUN([SIM_AC_HAVE_LIBJPEG_IFELSE],
[: ${sim_ac_have_libjpeg=false}
AC_MSG_CHECKING([for libjpeg])
AC_ARG_WITH(
  [jpeg],
  [AC_HELP_STRING([--with-jpeg=PATH], [enable/disable libjpeg support])],
  [case $withval in
  yes | "") sim_ac_want_libjpeg=true ;;
  no)       sim_ac_want_libjpeg=false ;;
  *)        sim_ac_want_libjpeg=true
            sim_ac_libjpeg_path=$withval ;;
  esac],
  [sim_ac_want_libjpeg=true])
case $sim_ac_want_libjpeg in
true)
  $sim_ac_have_libjpeg && break
  sim_ac_libjpeg_save_CPPFLAGS=$CPPFLAGS
  sim_ac_libjpeg_save_LDFLAGS=$LDFLAGS
  sim_ac_libjpeg_save_LIBS=$LIBS
  sim_ac_libjpeg_debug=false
  test -n "`echo -- $CPPFLAGS $CFLAGS $CXXFLAGS | grep -- '-g\\>'`" &&
    sim_ac_libjpeg_debug=true
  test -z "$sim_ac_libjpeg_path" -a x"$prefix" != xNONE &&
    sim_ac_libjpeg_path=$prefix
  sim_ac_libjpeg_name=jpeg
  if test -n "$sim_ac_libjpeg_path"; then
    for sim_ac_libjpeg_candidate in \
      `( ls $sim_ac_libjpeg_path/lib/jpeg*.lib;
         ls $sim_ac_libjpeg_path/lib/jpeg*d.lib ) 2>/dev/null`
    do
      case $sim_ac_libjpeg_candidate in
      *d.lib)
        $sim_ac_libjpeg_debug &&
          sim_ac_libjpeg_name=`basename $sim_ac_libjpeg_candidate .lib` ;;
      *.lib)
        sim_ac_libjpeg_name=`basename $sim_ac_libjpeg_candidate .lib` ;;
      esac
    done
    sim_ac_libjpeg_cppflags="-I$sim_ac_libjpeg_path/include"
    CPPFLAGS="$CPPFLAGS $sim_ac_libjpeg_cppflags"
    sim_ac_libjpeg_ldflags="-L$sim_ac_libjpeg_path/lib"
    LDFLAGS="$LDFLAGS $sim_ac_libjpeg_ldflags"
    # unset sim_ac_libjpeg_candidate
    # unset sim_ac_libjpeg_path
  fi
  sim_ac_libjpeg_libs="-l$sim_ac_libjpeg_name"
  LIBS="$sim_ac_libjpeg_libs $LIBS"
  AC_TRY_LINK(
    [#include <stdio.h>
#ifdef __cplusplus
extern "C" { // libjpeg header is missing the C++ wrapper
#endif
#include <jpeglib.h>
#ifdef __cplusplus
}
#endif],
  [(void)jpeg_read_header(0L, 0);],
  [sim_ac_have_libjpeg=true])
  CPPFLAGS=$sim_ac_libjpeg_save_CPPFLAGS
  LDFLAGS=$sim_ac_libjpeg_save_LDFLAGS
  LIBS=$sim_ac_libjpeg_save_LIBS
  # unset sim_ac_libjpeg_debug
  # unset sim_ac_libjpeg_name
  # unset sim_ac_libjpeg_save_CPPFLAGS
  # unset sim_ac_libjpeg_save_LDFLAGS
  # unset sim_ac_libjpeg_save_LIBS
  ;;
esac
if $sim_ac_want_libjpeg; then
  if $sim_ac_have_libjpeg; then
    AC_MSG_RESULT([success ($sim_ac_libjpeg_libs)])
    $1
  else
    AC_MSG_RESULT([failure])
    $2
  fi
else
  AC_MSG_RESULT([disabled])
  $2
fi
# unset sim_ac_want_libjpeg
])

# EOF **********************************************************************

# **************************************************************************
# SIM_AC_HAVE_LIBZLIB_IFELSE( IF-FOUND, IF-NOT-FOUND )
#
# Variables:
#   sim_ac_have_libzlib
#   sim_ac_zlib_cppflags
#   sim_ac_zlib_ldflags
#   sim_ac_zlib_libs
#
# Authors:
#   Lars J. Aas <larsa@coin3d.org>
#   Morten Eriksen <mortene@coin3d.org>
#
# Todo:
# - use AS_UNSET to unset internal variables to avoid polluting the environment
#

# **************************************************************************

AC_DEFUN([SIM_AC_HAVE_LIBZLIB_IFELSE],
[: ${sim_ac_have_libzlib=false}
AC_MSG_CHECKING([for zlib])
AC_ARG_WITH(
  [zlib],
  [AC_HELP_STRING([--with-zlib=PATH], [enable/disable zlib support])],
  [case $withval in
  yes | "") sim_ac_want_libzlib=true ;;
  no)       sim_ac_want_libzlib=false ;;
  *)        sim_ac_want_libzlib=true
            sim_ac_libzlib_path=$withval ;;
  esac],
  [sim_ac_want_libzlib=true])
case $sim_ac_want_libzlib in
true)
  $sim_ac_have_libzlib && break
  sim_ac_libzlib_save_CPPFLAGS=$CPPFLAGS
  sim_ac_libzlib_save_LDFLAGS=$LDFLAGS
  sim_ac_libzlib_save_LIBS=$LIBS
  sim_ac_libzlib_debug=false
  test -n "`echo -- $CPPFLAGS $CFLAGS $CXXFLAGS | grep -- '-g\\>'`" &&
    sim_ac_libzlib_debug=true
  test -z "$sim_ac_libzlib_path" -a x"$prefix" != xNONE &&
    sim_ac_libzlib_path=$prefix
  sim_ac_libzlib_name=z
  if test -n "$sim_ac_libzlib_path"; then
    for sim_ac_libzlib_candidate in \
      `( ls $sim_ac_libzlib_path/lib/zlib*.lib;
         ls $sim_ac_libzlib_path/lib/zlib*d.lib ) 2>/dev/null`
    do
      case $sim_ac_libzlib_candidate in
      *d.lib)
        $sim_ac_libzlib_debug &&
          sim_ac_libzlib_name=`basename $sim_ac_libzlib_candidate .lib` ;;
      *.lib)
        sim_ac_libzlib_name=`basename $sim_ac_libzlib_candidate .lib` ;;
      esac
    done
    sim_ac_libzlib_cppflags="-I$sim_ac_libzlib_path/include"
    CPPFLAGS="$CPPFLAGS $sim_ac_libzlib_cppflags"
    sim_ac_libzlib_ldflags="-L$sim_ac_libzlib_path/lib"
    LDFLAGS="$LDFLAGS $sim_ac_libzlib_ldflags"
    # unset sim_ac_libzlib_candidate
    # unset sim_ac_libzlib_path
  fi
  sim_ac_libzlib_libs="-l$sim_ac_libzlib_name"
  LIBS="$sim_ac_libzlib_libs $LIBS"
  AC_TRY_LINK(
    [#include <zlib.h>],
    [(void)zlibVersion();],
    [sim_ac_have_libzlib=true])
  CPPFLAGS=$sim_ac_libzlib_save_CPPFLAGS
  LDFLAGS=$sim_ac_libzlib_save_LDFLAGS
  LIBS=$sim_ac_libzlib_save_LIBS
  # unset sim_ac_libzlib_debug
  # unset sim_ac_libzlib_name
  # unset sim_ac_libzlib_save_CPPFLAGS
  # unset sim_ac_libzlib_save_LDFLAGS
  # unset sim_ac_libzlib_save_LIBS
  ;;
esac
if $sim_ac_want_libzlib; then
  if $sim_ac_have_libzlib; then
    AC_MSG_RESULT([success ($sim_ac_libzlib_libs)])
    $1
  else
    AC_MSG_RESULT([failure])
    $2
  fi
else
  AC_MSG_RESULT([disabled])
  $2
fi
# unset sim_ac_want_libzlib
])

# Usage:
#  SIM_AC_CHECK_ZLIB_READY([ACTION-IF-READY[, ACTION-IF-NOT-READY]])
#
#  Try to link code which needs the ZLIB development system.
#
# Author: Morten Eriksen, <mortene@sim.no>.

AC_DEFUN([SIM_AC_CHECK_ZLIB_READY], [
AC_MSG_CHECKING([if we can use zlib without explicit linkage])
sim_ac_zlib_ready=false
AC_TRY_LINK(
  [#include <zlib.h>],
  [(void)zlibVersion();],
  [sim_ac_zlib_ready=true])
if $sim_ac_zlib_ready; then
  AC_MSG_RESULT([yes])
  $1
else
  AC_MSG_RESULT([no])
  $2
fi
# unset sim_ac_zlib_ready
])

# EOF **********************************************************************

# **************************************************************************
# SIM_AC_HAVE_LIBPNG_IFELSE( IF-FOUND, IF-NOT-FOUND )
#
# Variables:
#   sim_ac_have_libpng
#   sim_ac_libpng_cppflags
#   sim_ac_libpng_ldflags
#   sim_ac_libpng_libs
#
# Authors:
#   Lars J. Aas <larsa@coin3d.org>
#   Morten Eriksen <mortene@coin3d.org>
#
# Todo:
# - use AS_UNSET to unset internal variables to avoid polluting the environment
#

# **************************************************************************

AC_DEFUN([SIM_AC_HAVE_LIBPNG_IFELSE],
[: ${sim_ac_have_libpng=false}
AC_MSG_CHECKING([for libpng])
AC_ARG_WITH(
  [png],
  [AC_HELP_STRING([--with-png=PATH], [enable/disable libpng support])],
  [case $withval in
  yes | "") sim_ac_want_libpng=true ;;
  no)       sim_ac_want_libpng=false ;;
  *)        sim_ac_want_libpng=true
            sim_ac_libpng_path=$withval ;;
  esac],
  [sim_ac_want_libpng=true])
case $sim_ac_want_libpng in
true)
  $sim_ac_have_libpng && break
  sim_ac_libpng_save_CPPFLAGS=$CPPFLAGS
  sim_ac_libpng_save_LDFLAGS=$LDFLAGS
  sim_ac_libpng_save_LIBS=$LIBS
  sim_ac_libpng_debug=false
  test -n "`echo -- $CPPFLAGS $CFLAGS $CXXFLAGS | grep -- '-g\\>'`" &&
    sim_ac_libpng_debug=true
  test -z "$sim_ac_libpng_path" -a x"$prefix" != xNONE &&
    sim_ac_libpng_path=$prefix
  sim_ac_libpng_name=png
  if test -n "$sim_ac_libpng_path"; then
    for sim_ac_libpng_candidate in \
      `( ls $sim_ac_libpng_path/lib/png*.lib;
         ls $sim_ac_libpng_path/lib/png*d.lib ) 2>/dev/null`
    do
      case $sim_ac_libpng_candidate in
      *d.lib)
        $sim_ac_libpng_debug &&
          sim_ac_libpng_name=`basename $sim_ac_libpng_candidate .lib` ;;
      *.lib)
        sim_ac_libpng_name=`basename $sim_ac_libpng_candidate .lib` ;;
      esac
    done
    sim_ac_libpng_cppflags="-I$sim_ac_libpng_path/include"
    CPPFLAGS="$sim_ac_libpng_cppflags $CPPFLAGS"
    sim_ac_libpng_ldflags="-L$sim_ac_libpng_path/lib"
    LDFLAGS="$sim_ac_libpng_ldflags $LDFLAGS"
    # unset sim_ac_libpng_candidate
    # unset sim_ac_libpng_path
  fi
  sim_ac_libpng_libs="-l$sim_ac_libpng_name"
  LIBS="$sim_ac_libpng_libs $LIBS"
  AC_TRY_LINK(
    [#include <png.h>],
    [(void)png_read_info(0L, 0L);],
    [sim_ac_have_libpng=true])
  CPPFLAGS=$sim_ac_libpng_save_CPPFLAGS
  LDFLAGS=$sim_ac_libpng_save_LDFLAGS
  LIBS=$sim_ac_libpng_save_LIBS
  # unset sim_ac_libpng_debug
  # unset sim_ac_libpng_name
  # unset sim_ac_libpng_save_CPPFLAGS
  # unset sim_ac_libpng_save_LDFLAGS
  # unset sim_ac_libpng_save_LIBS
  ;;
esac
if $sim_ac_want_libpng; then
  if $sim_ac_have_libpng; then
    AC_MSG_RESULT([success ($sim_ac_libpng_libs)])
    $1
  else
    AC_MSG_RESULT([failure])
    $2
  fi
else
  AC_MSG_RESULT([disabled])
  $2
fi
# unset sim_ac_want_libpng
])

# **************************************************************************
# Usage:
#  SIM_AC_CHECK_PNG_READY([ACTION-IF-READY[, ACTION-IF-NOT-READY]])
#
#  Try to link code which needs the PNG development system.
#
# Author: Morten Eriksen, <mortene@sim.no>.

AC_DEFUN([SIM_AC_CHECK_PNG_READY],
[AC_MSG_CHECKING([if we can use libpng without explicit linkage])
AC_TRY_LINK(
  [#include <png.h>],
  [(void)png_read_info(0L, 0L);],
  sim_ac_png_ready=true,
  sim_ac_png_ready=false)
if $sim_ac_png_ready; then
  AC_MSG_RESULT([yes])
  $1
else
  AC_MSG_RESULT([no])
  $2
fi
])

# EOF **********************************************************************

# **************************************************************************
# SIM_AC_HAVE_LIBTIFF_IFELSE( IF-FOUND, IF-NOT-FOUND )
#
# Variables:
#   sim_ac_have_libtiff
#   sim_ac_libtiff_cppflags
#   sim_ac_libtiff_ldflags
#   sim_ac_libtiff_libs
#
# Authors:
#   Lars J. Aas <larsa@coin3d.org>
#   Morten Eriksen <mortene@coin3d.org>
#
# Todo:
# - use AS_UNSET to unset internal variables to avoid polluting the environment
#

AC_DEFUN([SIM_AC_HAVE_LIBTIFF_IFELSE],
[: ${sim_ac_have_libtiff=false}
AC_MSG_CHECKING([for libtiff])
AC_ARG_WITH(
  [tiff],
  [AC_HELP_STRING([--with-tiff=PATH], [enable/disable libtiff support])],
  [case $withval in
  yes | "") sim_ac_want_libtiff=true ;;
  no)       sim_ac_want_libtiff=false ;;
  *)        sim_ac_want_libtiff=true
            sim_ac_libtiff_path=$withval ;;
  esac],
  [sim_ac_want_libtiff=true])
case $sim_ac_want_libtiff in
true)
  $sim_ac_have_libtiff && break
  sim_ac_libtiff_save_CPPFLAGS=$CPPFLAGS
  sim_ac_libtiff_save_LDFLAGS=$LDFLAGS
  sim_ac_libtiff_save_LIBS=$LIBS
  sim_ac_libtiff_debug=false
  test -n "`echo -- $CPPFLAGS $CFLAGS $CXXFLAGS | grep -- '-g\\>'`" &&
    sim_ac_libtiff_debug=true
  test -z "$sim_ac_libtiff_path" -a x"$prefix" != xNONE &&
    sim_ac_libtiff_path=$prefix
  sim_ac_libtiff_name=tiff
  if test -n "$sim_ac_libtiff_path"; then
    for sim_ac_libtiff_candidate in \
      `( ls $sim_ac_libtiff_path/lib/tiff*.lib;
         ls $sim_ac_libtiff_path/lib/tiff*d.lib ) 2>/dev/null`
    do
      case $sim_ac_libtiff_candidate in
      *d.lib)
        $sim_ac_libtiff_debug &&
          sim_ac_libtiff_name=`basename $sim_ac_libtiff_candidate .lib` ;;
      *.lib)
        sim_ac_libtiff_name=`basename $sim_ac_libtiff_candidate .lib` ;;
      esac
    done
    sim_ac_libtiff_cppflags="-I$sim_ac_libtiff_path/include"
    CPPFLAGS="$CPPFLAGS $sim_ac_libtiff_cppflags"
    sim_ac_libtiff_ldflags="-L$sim_ac_libtiff_path/lib"
    LDFLAGS="$LDFLAGS $sim_ac_libtiff_ldflags"
    # unset sim_ac_libtiff_candidate
    # unset sim_ac_libtiff_path
  fi
  sim_ac_libtiff_libs="-l$sim_ac_libtiff_name"
  LIBS="$sim_ac_libtiff_libs $LIBS"
  AC_TRY_LINK(
    [#include <tiffio.h>],
    [(void)TIFFOpen(0L, 0L);],
    [sim_ac_have_libtiff=true])
  CPPFLAGS=$sim_ac_libtiff_save_CPPFLAGS
  LDFLAGS=$sim_ac_libtiff_save_LDFLAGS
  LIBS=$sim_ac_libtiff_save_LIBS
  # unset sim_ac_libtiff_debug
  # unset sim_ac_libtiff_name
  # unset sim_ac_libtiff_save_CPPFLAGS
  # unset sim_ac_libtiff_save_LDFLAGS
  # unset sim_ac_libtiff_save_LIBS
  ;;
esac
if $sim_ac_want_libtiff; then
  if $sim_ac_have_libtiff; then
    AC_MSG_RESULT([success ($sim_ac_libtiff_libs)])
    $1
  else
    AC_MSG_RESULT([failure])
    $2
  fi
else
  AC_MSG_RESULT([disabled])
  $2
fi
# unset sim_ac_want_libtiff
])

# EOF **********************************************************************

# **************************************************************************
# SIM_AC_UNIQIFY_LIST( VARIABLE, LIST )
#
# This macro filters out redundant items from a list.  This macro was made
# to avoid having multiple equivalent -I and -L options for the compiler on
# the command-line, which made compilation quite messy to watch.
#
# BUGS:
#   Items with spaces are probably not supported.
#
# Authors:
#   Lars J. Aas <larsa@sim.no>
#

AC_DEFUN([SIM_AC_UNIQIFY_LIST], [
sim_ac_save_prefix=$prefix
sim_ac_save_exec_prefix=$exec_prefix
test x"$prefix" = xNONE && prefix=/usr/local
test x"$exec_prefix" = xNONE && exec_prefix='${prefix}'
sim_ac_uniqued_list=
for sim_ac_item in $2; do
  eval sim_ac_eval_item="$sim_ac_item"
  eval sim_ac_eval_item="$sim_ac_eval_item"
  if test x"$sim_ac_uniqued_list" = x; then
    sim_ac_uniqued_list="$sim_ac_item"
  else
    sim_ac_unique=true
    for sim_ac_uniq in $sim_ac_uniqued_list; do
      eval sim_ac_eval_uniq="$sim_ac_uniq"
      eval sim_ac_eval_uniq="$sim_ac_eval_uniq"
      test x"$sim_ac_eval_item" = x"$sim_ac_eval_uniq" && sim_ac_unique=false
    done
    $sim_ac_unique && sim_ac_uniqued_list="$sim_ac_uniqued_list $sim_ac_item"
  fi
done
$1=$sim_ac_uniqued_list
prefix=$sim_ac_save_prefix
exec_prefix=$sim_ac_save_exec_prefix
# unset sim_ac_save_prefix
# unset sim_ac_save_exec_prefix
# unset sim_ac_eval_item
# unset sim_ac_eval_uniq
]) # SIM_AC_UNIQIFY_LIST


# Usage:
#  SIM_AC_ISO8601_DATE(variable)
#
# Description:
#   This macro sets the given variable to a strings representing
#   the current date in the ISO8601-compliant format YYYYMMDD.
#
# Author: Morten Eriksen, <mortene@sim.no>.

AC_DEFUN(SIM_AC_ISO8601_DATE, [
  eval "$1=\"`date +%Y%m%d`\""
])

# Like AC_CONFIG_HEADER, but automatically create stamp file.

# serial 3

# When config.status generates a header, we must update the stamp-h file.
# This file resides in the same directory as the config header
# that is generated.  We must strip everything past the first ":",
# and everything past the last "/".

AC_PREREQ([2.12])

AC_DEFUN([AM_CONFIG_HEADER],
[AC_CONFIG_HEADER([$1])
  AC_OUTPUT_COMMANDS(
   ifelse(patsubst([$1], [[^ ]], []),
	  [],
	  [test -z "$CONFIG_HEADERS" || echo timestamp >dnl
	   patsubst([$1], [^\([^:]*/\)?.*], [\1])stamp-h]),
  [am_indx=1
  for am_file in $1; do
    case " $CONFIG_HEADERS " in
    *" $am_file "*)
      echo timestamp > `echo $am_file | sed 's%:.*%%;s%[^/]*$%%'`stamp-h$am_indx
      ;;
    esac
    am_indx=\`expr \$am_indx + 1\`
  done])
])

