# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EGIT_REPO_URI="git://github.com/phuang/${PN}.git"
inherit git autotools

DESCRIPTION="Korean input method Hangul IMEngine for IBus Framework"
HOMEPAGE="http://ibus.googlecode.com"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="nls"

# autopoint needs cvs to work. Bug #152872
DEPEND="app-i18n/libhangul
	dev-util/cvs
	sys-devel/gettext"
RDEPEND=">=app-i18n/ibus-1.0
	app-i18n/libhangul"

src_unpack() {
	git_src_unpack
	autopoint || die "failed to run autopoint"
	eautoreconf
}

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	emake install DESTDIR="${D}" || die "Install failed"
	dodoc AUTHORS ChangeLog NEWS README
}

pkg_postinst() {
	ewarn "This package is very experimental, please report your bugs to:"
	ewarn "http://ibus.googlecode.com/issues/list"
	elog "You should run ibus-setup and enable IMEngines you want to use."
}