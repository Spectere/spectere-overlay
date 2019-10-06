# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit eutils

DESCRIPTION=".NET Core SDK - side-by-side SDK deployment"
HOMEPAGE="https://www.microsoft.com/net/core"
LICENSE="MIT"

SRC_URI="
	amd64? ( https://download.visualstudio.microsoft.com/download/pr/8029a774-0cc8-4c62-945e-169a473b51d3/2c3f6a18aed152e5e498035695ed816f/dotnet-sdk-${PV}-linux-x64.tar.gz -> dotnet-sdk-${PV}-linux-x64.tar.gz )
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
