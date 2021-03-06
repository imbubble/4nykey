# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
if [[ -z ${PV%%*9999} ]]; then
	REQUIRED_USE="!binary"
	MY_PV="1.0.3"
	S="${WORKDIR}/${PN}-${MY_PV}"
else
	SRC_URI="
	binary? (
		mirror://sourceforge/${PN}/${PN}-ttf-${PV}.tar.xz
		latex? ( mirror://sourceforge/${PN}/${PN}-tex-${PV}.tar.xz )
	)
	"
	KEYWORDS="~amd64 ~x86"
	MY_PV="${PV}"
fi
inherit python-any-r1 latex-package font-r1

DESCRIPTION="Istok is a sans serif typeface"
HOMEPAGE="https://sourceforge.net/projects/${PN}"
SRC_URI+="
	!binary? ( mirror://sourceforge/${PN}/${PN}-src-${MY_PV}.tar.xz )
"

LICENSE="GPL-3"
SLOT="0"
IUSE="+binary latex"

DEPEND="
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			media-gfx/fontforge[python,${PYTHON_USEDEP}]
			media-gfx/xgridfit[${PYTHON_USEDEP}]
		')
		dev-python/fonttools
		dev-util/font-helpers
	)
"
RESTRICT="primaryuri"

pkg_setup() {
	use binary || python-any-r1_pkg_setup
	font-r1_pkg_setup
}

src_prepare() {
	default
	use binary && return
	sed \
		-e 's:\<rm\>:& -f:' \
		-e '/_acc\.xgf:/ s:_\.sfd:.gen.ttf:' \
		-i Makefile
	cp "${EPREFIX}"/usr/share/font-helpers/*.{ff,py} "${S}"/
}

src_compile() {
	# fontforge fails with EMFILE otherwise
	use binary || ulimit -n 4096
	default
}

src_install() {
	if use latex; then
		if use binary; then
			insinto "${TEXMF}"
			doins -r "${WORKDIR}"/{dvips,fonts,tex}
		else
			emake TEXPREFIX="${ED}/${TEXMF}" tex-support
			rm -rf "${ED}"/${TEXMF}/doc
		fi
		echo "Map ${PN}.map" > "${T}"/${PN}.cfg
		insinto /etc/texmf/updmap.d
		doins "${T}"/${PN}.cfg
	fi
	rm -f *.gen.ttf
	font-r1_src_install
}

pkg_postinst() {
	font-r1_pkg_postinst
	use latex && latex-package_pkg_postinst
}

pkg_postrm() {
	font-r1_pkg_postrm
	use latex && latex-package_pkg_postrm
}
