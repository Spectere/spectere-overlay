# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit eutils

DESCRIPTION=".NET Core SDK - side-by-side SDK deployment"
HOMEPAGE="https://www.microsoft.com/net/core"
LICENSE="MIT"

SRC_URI="
	amd64? ( https://download.microsoft.com/download/4/0/9/40920432-3302-47a8-b13c-bbc4848ad114/dotnet-sdk-${PV}-linux-x64.tar.gz -> dotnet-sdk-${PV}-linux-x64.tar.gz )
"

SLOT="2.1"
KEYWORDS="~amd64"

RDEPEND=">=dev-dotnet/dotnetcore-sdk-bin-3.0.0"

S=${WORKDIR}

src_prepare() {
	default

	# Remove the parts of the SDK that are already installed.
	local remove_files=(
		dotnet
		LICENSE.txt
		ThirdPartyNotices.txt
	)

	rm -rv "${remove_files[@]}" || die
}

src_install() {
	local dest="opt/dotnet_core"
	dodir "${dest}"

	local ddest="${D}${dest}"
	cp -a "${S}"/* "${ddest}/" || die
}
