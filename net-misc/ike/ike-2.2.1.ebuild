# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils
inherit desktop

DESCRIPTION="Shrew Soft VPN Client"
HOMEPAGE="https://www.shrew.net/"
SRC_URI="https://www.shrew.net/download/${PN}/${P}-release.tbz2"

LICENSE="shrew"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ldap nat qt5"

RDEPEND="dev-libs/libedit
		dev-libs/openssl:0
		qt5? ( dev-qt/qtgui:5 )
		ldap? ( net-nds/openldap )"

DEPEND="${RDEPEND}
		dev-util/cmake
		>=sys-devel/bison-2.3
		sys-devel/flex"

S="${WORKDIR}/${PN}"
CMAKE_IN_SOURCE_BUILD="1"

src_prepare() {
	base_src_prepare
	epatch "${FILESDIR}"/"${P}-qt5.patch"
	cmake-utils_src_prepare
}

src_configure() {
	mycmakeargs+=( -DLDAP="$(usex ldap)"
	               -DNATT="$(usex nat)"
				   -DQTGUI="$(usex qt5)"
	               "-DMANDIR=/usr/share/man"
	               "-DETCDIR=/etc/ike"
	               "-DLIBDIR=/usr/$(get_libdir)"
				 )

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	newicon "${S}/source/qikea/png/ikea.png" "${PN}.png"
	make_desktop_entry "qikea" "Shrew Soft VPN Client (Ike)" "${PN}" "Network;RemoteAccess;"
}
