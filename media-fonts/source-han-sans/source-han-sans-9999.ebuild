# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adobe-fonts/${PN}"
else
	SRC_URI="
		!afdko? (
			mirror://githubcl/adobe-fonts/${PN}/tar.gz/${PV}R
			-> ${P}R.tar.gz
		)
		afdko? (
			mirror://githubcl/adobe-fonts/${PN}/tar.gz/${PV}
			-> ${P}.tar.gz
		)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
CHECKREQS_DISK_BUILD="1750M"
inherit font check-reqs

DESCRIPTION="Pan-CJK OpenType/CFF font family"
HOMEPAGE="https://github.com/adobe-fonts/source-han-sans/"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="afdko"

DEPEND="
	afdko? ( media-gfx/afdko )
"
RDEPEND=""

FONT_SUFFIX="otf"
DOCS="README.md"

pkg_setup() {
	if [[ ${PV} == *9999* ]]; then
		EGIT_BRANCH="$(usex afdko master release)"
	else
		S="${WORKDIR}/${P}$(usex afdko '' 'R')"
		FONT_S="${S}"
	fi
	font_pkg_setup
}

src_prepare() {
	default
	use afdko && eapply "${FILESDIR}"/${P}*.diff
}

src_compile() {
	if use !afdko; then
		find SubsetOTF -mindepth 2 -name '*.otf' -exec mv -f {} "${S}" \;
	else
		source ${EROOT}etc/afdko
		source "${S}"/COMMANDS.txt
	fi
}
