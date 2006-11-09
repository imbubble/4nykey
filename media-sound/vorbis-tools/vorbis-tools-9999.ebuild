# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/vorbis-tools/vorbis-tools-1.1.1-r2.ebuild,v 1.1 2006/03/08 22:13:02 nattfodd Exp $

inherit flag-o-matic subversion autotools

DESCRIPTION="tools for using the Ogg Vorbis sound file format"
HOMEPAGE="http://www.vorbis.com/"
ESVN_REPO_URI="http://svn.xiph.org/trunk/vorbis-tools"
ESVN_PATCHES="${PN}-*.diff"
ESVN_BOOTSTRAP="eautoreconf"
WANT_AUTOMAKE="1.9"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="nls flac speex encode ogg123 ogg"

RDEPEND="
	>=media-libs/libvorbis-1.1.0
	ogg123? (
		>=media-libs/libao-0.8.2
		>=net-misc/curl-7.9
		speex? ( media-libs/speex )
	)
	encode? ( flac? ( media-libs/flac ) )
"
DEPEND="
	${RDEPEND}
	nls? ( sys-devel/gettext )
"

pkg_setup() {
	if use flac && use ogg && ! built_with_use media-libs/flac ogg; then
		eerror "To be able to play OggFlac files you need to build"
		eerror "media-libs/flac with USE=ogg."
		die "Missing libOggFLAC library."
	fi
}

src_compile() {
	local myconf
	use encode && myconf="${myconf} $(use_with flac)"
	use ogg123 && myconf="${myconf} $(use_with speex)"

	econf \
		$(use_enable encode oggenc) \
		$(use_enable ogg123) \
		${myconf} || die
	emake || die
}

src_install() {
	einstall MKINSTALLDIRS="${S}/mkinstalldirs" || die

	rm -rf ${D}/usr/share/doc
	dodoc AUTHORS README
	docinto ogg123
	dodoc ogg123/ogg123rc-example
}