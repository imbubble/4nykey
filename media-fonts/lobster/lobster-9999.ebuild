# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="The-${PN^}-Font"
MAKEOPTS+=" INTERPOLATE="
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/impallari/${MY_PN}"
else
	inherit vcs-snapshot
	MY_PV="e8be3a0"
	SRC_URI="
		mirror://githubcl/impallari/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake

DESCRIPTION="A bold condensed script font with ligatures and alternates"
HOMEPAGE="http://www.impallari.com/lobster"

LICENSE="OFL-1.1"
SLOT="0"
