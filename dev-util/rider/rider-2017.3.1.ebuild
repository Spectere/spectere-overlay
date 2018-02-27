# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop
inherit eutils

DESCRIPTION="A cross-platform .NET IDE based on the IntelliJ platform and ReSharper."
HOMEPAGE="https://www.jetbrains.com/rider/"
SRC_URI="https://download.jetbrains.com/resharper/JetBrains.Rider-${PV}.tar.gz"

LICENSE="IDEA || ( IDEA_Academic IDEA_Classroom IDEA_OpenSource IDEA_Personal )"
SLOT="0"
KEYWORDS="~amd64"
IUSE="-custom-jre"

RDEPEND="!custom-jre? ( >=virtual/jre-1.7 )"

QA_PREBUILT="opt/${PN}/*"

S="${WORKDIR}/JetBrains Rider-${PV}"

src_prepare() {
	default

	# Rider only supports x86_64. Remove files that don't meet the criteria.
	local remove_files=(
		bin/fsnotifier
		bin/fsnotifier-arm
	)

	use custom-jre || remove_files+=( jre64 )

	rm -rv "${remove_files[@]}" || die
}

src_install() {
	local dir="/opt/${PN}"

	insinto "${dir}"
	doins -r *
	fperms 755 "${dir}"/bin/{rider.sh,fsnotifier64}
	fperms 755 "${dir}"/lib/ReSharperHost/{runtime.sh,linux-x64/mono/bin/mono-sgen{,-gdb.py}}

	make_wrapper "${PN}" "${dir}/bin/${PN}.sh"
	newicon "bin/${PN}.png" "${PN}.png"
	make_desktop_entry "${PN}" "Rider" "${PN}" "Development;IDE;"
}
