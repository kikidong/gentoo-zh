# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

NEED_PYTHON="2.5"
EGIT_REPO_URI="git://github.com/acevery/${PN}.git"
inherit autotools git python

DESCRIPTION="General Table Engine for IBus Framework"
HOMEPAGE="http://ibus.googlecode.com"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+additional cangjie5 extra-phrases erbi-qs wubi nls zhengma"

# NOTES:
# 1.autopoint is part of gettext, so here we
#   don't need a conditional USE flag 'nls'.
# 2.ibus seems to work without gettext (tested on my box).
# 3.extra-phrases is suggested by acevery (the upstream)?.
# 4.Autopoint needs cvs to work. Bug #152872
DEPEND="dev-util/cvs
	dev-util/pkgconfig
	sys-devel/gettext"
RDEPEND="app-i18n/ibus"

pkg_setup() {
	# Should I use use dependencies? (eapi-2)
	if ! python_mod_exists sqlite3 ; then
		eerror "We need sqlite module for python to generate table databases!"
		die "Please compile your python with \"sqlite\" USE flag!"
	fi
	if ! use cangjie5 && ! use erbi-qs && ! use wubi && ! use zhengma; then
		echo
		ewarn "To install ${PN}, you should set at least one of following USE flags:"
		ewarn "\"cangjie5 erbi-qs wubi zhengma\""
		ewarn "For more info about them please run \"quse -D use-flag-here\""
		ewarn "or \"eix ibus-table\"."
		ewarn "You can press CTRL+C to abort the installation process."
		echo
		ebeep 10
	fi
}

src_unpack() {
	git_src_unpack
	autopoint || die "failed to run autopoint"
	eautoreconf
}

src_compile() {
	econf $(use_enable additional) \
		$(use_enable cangjie5) \
		$(use_enable erbi-qs) \
		$(use_enable extra-phrases) \
		$(use_enable nls) \
		$(use_enable wubi wubi86) \
		$(use_enable wubi wubi98) \
		$(use_enable zhengma)

	# Parallel make uses a lot of memory to generate databases.
	MAKEOPTS="${MAKEOPTS} -j1" emake || die
}

src_install() {
	emake install DESTDIR="${D}" || die "Install failed"
	dodoc AUTHORS ChangeLog NEWS README
}

pkg_postinst() {
	ewarn "This package is very experimental, please report your bugs to"
	ewarn "http://ibus.googlecode.com/issues/list"
	echo
	elog "Don't forget to run ibus-setup and enable the IM Engines you want to use!"
	echo

	# Really useful? (python_mod_optimize/python_mod_cleanup)
	python_mod_optimize /usr/share/${PN}
}

pkg_postrm() {
	python_mod_cleanup /usr/share/${PN}
}