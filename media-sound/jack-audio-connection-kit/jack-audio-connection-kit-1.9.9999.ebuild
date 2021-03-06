# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"
inherit eutils python-single-r1 waf-utils multilib-minimal linux-info
if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jackaudio/jack2.git"
else
	inherit vcs-snapshot
	MY_PV="${PV/_/-}"
	MY_PV="v${MY_PV^^}"
	[[ -z ${PV%%*_p*} ]] && MY_PV="2d1d323"
	SRC_URI="mirror://githubcl/jackaudio/jack2/tar.gz/${MY_PV} -> ${P}.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A low-latency audio server"
HOMEPAGE="http://www.jackaudio.org"

LICENSE="GPL-2"
SLOT="0"
IUSE="alsa celt classic dbus debug apidocs +examples libsamplerate opus pam readline sndfile"

REQUIRED_USE="
	|| ( classic dbus )
	${PYTHON_REQUIRED_USE}
"

DEPEND="
	${PYTHON_DEPS}
	celt? ( media-libs/celt:0[${MULTILIB_USEDEP}] )
	opus? ( media-libs/opus[${MULTILIB_USEDEP},custom-modes] )
	alsa? ( media-libs/alsa-lib[${MULTILIB_USEDEP}] )
	dbus? (
		dev-libs/expat[${MULTILIB_USEDEP}]
		sys-apps/dbus[${MULTILIB_USEDEP}]
	)
	examples? (
		sndfile? ( media-libs/libsndfile[${MULTILIB_USEDEP}] )
		libsamplerate? ( media-libs/libsamplerate[${MULTILIB_USEDEP}] )
		readline? ( sys-libs/readline:0[${MULTILIB_USEDEP}] )
	)
"
RDEPEND="
	${DEPEND}
	alsa? ( sys-process/lsof )
	dbus? ( dev-python/dbus-python[${PYTHON_USEDEP}] )
	pam? ( sys-auth/realtime-base )
"
DEPEND="
	${DEPEND}
	virtual/pkgconfig
	apidocs? ( app-doc/doxygen )
"
DOCS=( ChangeLog README README_NETJACK2 TODO )
CONFIG_CHECK="~!GRKERNSEC_HARDEN_IPC"

pkg_setup() {
	python-single-r1_pkg_setup
	linux-info_pkg_setup
}

src_prepare() {
	use examples || sed \
		-e '/example-clients/s:bld\.recurse:print:' \
		-i wscript
	default
	multilib_copy_sources
}

multilib_src_configure() {
	local mywafconfargs=(
		--htmldir="/usr/share/doc/${PF}/html"
		$(usex dbus --dbus "")
		$(usex classic --classic "")
		$(usex debug --debug "")
		--doxygen=$(multilib_native_usex apidocs)
		--alsa=$(usex alsa)
		--celt=$(usex celt)
		--opus=$(usex opus)
		--samplerate=$(usex libsamplerate)
		--sndfile=$(usex sndfile)
		--readline=$(usex readline)
	)

	WAF_BINARY="${BUILD_DIR}/waf" \
		waf-utils_src_configure ${mywafconfargs[@]}
}

multilib_src_compile() {
	WAF_BINARY="${BUILD_DIR}/waf" \
		waf-utils_src_compile
}

multilib_src_install() {
	WAF_BINARY="${BUILD_DIR}"/waf \
		waf-utils_src_install
}

multilib_src_install_all() {
	python_fix_shebang "${ED}"
}
