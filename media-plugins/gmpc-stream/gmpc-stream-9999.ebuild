# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion autotools
IUSE=""

DESCRIPTION="Online stream browser for gmpc"
HOMEPAGE="http://cms.qballcow.nl/index.php?page=Plugins"
ESVN_REPO_URI="https://svn.qballcow.nl/${PN}/trunk"

KEYWORDS="~x86"
SLOT="0"
LICENSE="GPL-2"

RDEPEND=">=x11-libs/gtk+-2.4
	=gnome-base/libglade-2*
	dev-libs/libxml2
	=gnome-base/gnome-vfs-2*
	|| ( >=media-sound/gmpc-svn-0.12.1
		>=media-sound/gmpc-0.12.1 )"
DEPEND="${RDEPEND}"

src_unpack() {
	subversion_src_unpack
	cd ${S}
	eautoreconf
}

src_install() {
	einstall || die "make install failed"
}
