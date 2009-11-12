AC_INIT(releasetracker, 0.1, ozamosi@flukkost.nu)
AM_INIT_AUTOMAKE()

AC_CONFIG_SRCDIR([Makefile.am])
AM_MAINTAINER_MODE()

AC_PROG_CC
AC_PROG_CC_C_O
AM_PROG_VALAC

PKG_CHECK_MODULES(RELEASETRACKER, [libxml-2.0 libsoup-2.4])
AM_PATH_GLIB_2_0(,,,gobject gthread)

AC_CONFIG_FILES([
	Makefile
])

AC_OUTPUT
