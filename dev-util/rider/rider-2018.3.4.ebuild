# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop
inherit enhbuild

DESCRIPTION="A cross-platform .NET IDE based on the IntelliJ platform and ReSharper."
HOMEPAGE="https://www.jetbrains.com/rider/"
SRC_URI="https://download.jetbrains.com/rider/JetBrains.Rider-${PV}.tar.gz"

LICENSE="IDEA || ( IDEA_Academic IDEA_Classroom IDEA_OpenSource IDEA_Personal )"
SLOT="2018.3"
KEYWORDS="~amd64"
IUSE="-bundled-jre"

RDEPEND="!bundled-jre? ( >=virtual/jre-1.7 )"

QA_PREBUILT="opt/${PN}-${SLOT}/*"

S="${WORKDIR}/JetBrains Rider-${PV}"

src_prepare() {
	default

	# Rider only supports x86_64. Remove files that don't meet the criteria.
	local remove_files=(
		bin/fsnotifier
		bin/fsnotifier-arm
	)

	use bundled-jre || remove_files+=( jre64 )

	rm -rv "${remove_files[@]}" || die
}

src_install() {
	local dir="/opt/${PN}-${SLOT}"

	insinto "${dir}"
	doins -r *
	fperms 755 "${dir}"/bin/{{format,inspect,rider}.sh,fsnotifier64,{printenv,restart}.py}
	fperms 755 "${dir}"/lib/ReSharperHost/{{JetBrains.ReSharper.Host,runtime}.sh,linux-x64/mono/bin/mono-sgen{,-gdb.py}}
	use bundled-jre && fperms 755 "${dir}"/jre64/bin/{java,jjs,keytool,orbd,pack200,policytool,rmid,rmiregistry,servertool,tnameserv,unpack200}

	make_wrapper_env "${PN}-${SLOT}" "${dir}/bin/${PN}.sh" "" "TERM=\"xterm\""
	newicon "bin/${PN}.png" "${PN}-${SLOT}.png"
	make_desktop_entry "${PN}-${SLOT}" "Rider ${SLOT}" "${PN}-${SLOT}" "Development;IDE;"
}
