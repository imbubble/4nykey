# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gmpc-plugin

DESCRIPTION="WikiPedia plugin for GMPC"

KEYWORDS="~x86"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="
	${RDEPEND}
	www-client/mozilla-firefox
"
