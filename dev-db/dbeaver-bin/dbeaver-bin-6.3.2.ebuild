# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop

DESCRIPTION="Free multi-platform database tool."
HOMEPAGE="https://dbeaver.io/"
SRC_URI="https://github.com/dbeaver/dbeaver/releases/download/${PV}/dbeaver-ce-${PV}-linux.gtk.x86_64.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=virtual/jre-1.8"

PN_STRIP="${PN%-bin}"

S="${WORKDIR}/${PN_STRIP}"

src_install() {
	local dir="/opt/dbeaver"

	insinto "${dir}"
	doins -r *
	fperms a+x "${dir}/${PN_STRIP}"

	dosym "${dir}/${PN_STRIP}" "/usr/bin/${PN_STRIP}"
	newicon "${PN_STRIP}.png" "${PN_STRIP}.png"
	make_desktop_entry "${PN_STRIP}" "DBeaver" "${PN_STRIP}" "Development;Database;IDE;"
}
