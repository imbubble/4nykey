# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MAKEOPTS+=" INTERPOLATE="
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ossobuffo/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="8524a55"
	SRC_URI="
		mirror://githubcl/ossobuffo/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake

DESCRIPTION="A family of sans-serif fonts in the Eurostile vein"
HOMEPAGE="https://github.com/ossobuffo/${PN}"

LICENSE="GPL-3 OFL-1.1"
SLOT="0"
