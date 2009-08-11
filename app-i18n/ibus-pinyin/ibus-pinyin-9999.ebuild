# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
#EGIT_BOOTSTRAP="autopoint"
EGIT_REPO_URI="git://github.com/phuang/ibus-pinyin.git"

inherit autotools python git

PYDB_TAR="pinyin-database-0.1.10.6.tar.bz2"
DESCRIPTION="Chinese PinYin IMEngine for IBus Framework"
HOMEPAGE="http://ibus.googlecode.com"
SRC_URI="http://ibus.googlecode.com/files/${PYDB_TAR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="nls"

DEPEND=">=dev-lang/python-2.5[sqlite]
	dev-util/cvs
	dev-util/pkgconfig
	sys-devel/gettext"
RDEPEND="app-i18n/ibus
	>=dev-lang/python-2.5[sqlite]"

src_prepare() {
	autopoint || die "failed to run autopoint"
	eautoreconf

	# Disable pyc compiling
	echo "#! /bin/bash" > py-compile
	einfo "Preparing pinyin database"
	cp "${DISTDIR}/${PYDB_TAR}" engine || die
}

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	emake install DESTDIR="${D}" || die "Install failed"
	dodoc AUTHORS ChangeLog NEWS README
}

pkg_postinst() {
	ewarn "This package is very experimental, please report your bugs to"
	ewarn "http://code.google.com/p/ibus/issues"
	echo
	elog "You should run ibus-setup and enable the IMEngines you want to use!"
	echo

	# http://www.gentoo.org/proj/en/Python/developersguide.xml#doc_chap2
	python_mod_optimize /usr/share/${PN}
}

pkg_postrm() {
	python_mod_cleanup /usr/share/${PN}
}