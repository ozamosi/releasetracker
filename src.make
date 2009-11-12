bin_PROGRAMS = releasetracker

releasetracker_SOURCES = src/releasetracker.vala

releasetracker_VALAFLAGS = \
	--pkg libsoup-2.4 --pkg libxml-2.0 --thread

releasetracker_CFLAGS = \
	$(RELEASETRACKER_CFLAGS) \
	$(GLIB_CFLAGS)

releasetracker_LDADD = \
	$(RELEASETRACKER_LIBS) \
	$(GLIB_LIBS)
