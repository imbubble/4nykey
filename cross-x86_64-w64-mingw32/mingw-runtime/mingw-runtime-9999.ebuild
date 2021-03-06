# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY/cross-} != ${CATEGORY} ]] ; then
		export CTARGET=${CATEGORY/cross-}
	fi
fi

MY_PN="mingw-w64"

inherit flag-o-matic autotools
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://git.code.sf.net/p/${MY_PN}/${MY_PN}"
else
	KEYWORDS="~amd64"
	SRC_URI="mirror://sourceforge/${MY_PN}/${MY_PN}/${MY_PN}-release/${MY_PN}-v${PV}.tar.bz2"
	S="${WORKDIR}/${MY_PN}-v${PV}"
fi

DESCRIPTION="Free Win32 runtime and import library definitions"
HOMEPAGE="http://mingw-w64.sourceforge.net/"

LICENSE="BSD"
SLOT="0"
IUSE="crosscompile_opts_headers-only"
RESTRICT="strip"

DEPEND=""

just_headers() {
	use crosscompile_opts_headers-only && [[ ${CHOST} != ${CTARGET} ]]
}

pkg_setup() {
	if [[ ${CBUILD} == ${CHOST} ]] && [[ ${CHOST} == ${CTARGET} ]] ; then
		die "Invalid configuration"
	fi
	just_headers && return
	CHOST=${CTARGET} strip-unsupported-flags
	filter-flags -m*=*
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--host=${CTARGET}
		--prefix=/usr/${CTARGET}/usr
		--enable-lib64
		--enable-lib32
		--with$(just_headers && echo 'out')-crt
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	env -uRESTRICT CHOST=${CTARGET} prepallstrip
	# gcc is configured to look at specific hard-coded paths for mingw #419601
	dosym usr /usr/${CTARGET}/mingw
	dosym usr/include /usr/${CTARGET}/include
	just_headers && return
	dosym usr/lib /usr/${CTARGET}/lib
	dosym usr/lib32 /usr/${CTARGET}/lib32
}
