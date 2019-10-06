# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit eutils

DESCRIPTION=".NET Core SDK - side-by-side SDK deployment"
HOMEPAGE="https://www.microsoft.com/net/core"
LICENSE="MIT"

SRC_URI="
	amd64? ( https://download.visualstudio.microsoft.com/download/pr/46411df1-f625-45c8-b5e7-08ab736d3daa/0fbc446088b471b0a483f42eb3cbf7a2/dotnet-sdk-${PV}-linux-x64.tar.gz -> dotnet-sdk-${PV}-linux-x64.tar.gz )
"

SLOT="2.2"
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
