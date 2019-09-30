# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit eutils

DESCRIPTION=".NET Core SDK - side-by-side SDK deployment"
HOMEPAGE="https://www.microsoft.com/net/core"
LICENSE="MIT"

SRC_URI="
	amd64? ( https://download.visualstudio.microsoft.com/download/pr/886b4a4c-30af-454b-8bec-81c72b7b4e1f/d1a0c8de9abb36d8535363ede4a15de6/dotnet-sdk-${PV}-linux-x64.tar.gz -> dotnet-sdk-${PV}-linux-x64.tar.gz )
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
