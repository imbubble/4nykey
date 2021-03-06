# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
FONT_TYPES=( otf +ttf )
MY_PN="${PN%*ard}"
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/akryukov/${MY_PN}.git"
	REQUIRED_USE="!binary"
else
	inherit vcs-snapshot
	MY_PV="v${PV}"
	SRC_URI="
	binary? (
		font_types_otf? (
		https://github.com/akryukov/${MY_PN}/releases/download/${MY_PV}/${P}.otf.zip
		)
		font_types_ttf? (
		https://github.com/akryukov/${MY_PN}/releases/download/${MY_PV}/${P}.ttf.zip
		)
	)
	!binary? (
		mirror://githubcl/akryukov/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font-r1

DESCRIPTION="A font with wide range of Latin, Greek and Cyrillic characters"
HOMEPAGE="https://github.com/akryukov/oldstand"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary"

DEPEND="
	binary? ( app-arch/unzip )
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			media-gfx/fontforge[${PYTHON_USEDEP}]
		')
		font_types_ttf? ( dev-util/grcompiler )
	)
"

pkg_setup() {
	if use binary; then
		S="${WORKDIR}"
	else
		python-any-r1_pkg_setup
	fi
	font-r1_pkg_setup
}

src_compile() {
	use binary && return
	fontforge -lang=py -script ost-generate.py || die
	use font_types_ttf || return
	local _t
	for _t in *.ttf; do
		grcompiler "${_t%.*}.gdl" "${_t}" "${T}/${_t}" || die
		mv -f "${T}/${_t}" "${_t}"
	done
}
