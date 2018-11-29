# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop
inherit eutils

DESCRIPTION="A cross-platform JavaScript IDE."
HOMEPAGE="https://www.jetbrains.com/webstorm/"
SRC_URI="https://download.jetbrains.com/webstorm/WebStorm-${PV}.tar.gz"

LICENSE="IDEA || ( IDEA_Academic IDEA_Classroom IDEA_OpenSource IDEA_Personal )"
SLOT="2018.3"
KEYWORDS="~amd64"
IUSE="-bundled-jre"

RDEPEND="!bundled-jre? ( >=virtual/jre-1.7 )"

QA_PREBUILT="opt/${PN}-${SLOT}/*"

BASENAME="webstorm"

S="${WORKDIR}/WebStorm-183.4284.130"

src_prepare() {
	default

	# WebStorm only supports x86_64. Remove files that don't meet the criteria.
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
	fperms 755 "${dir}"/bin/{{format,inspect,webstorm}.sh,fsnotifier64,{printenv,restart}.py}
	use bundled-jre && fperms 755 "${dir}"/jre64/bin/{java,jjs,keytool,orbd,pack200,policytool,rmid,rmiregistry,servertool,tnameserv,unpack200}

	make_wrapper "${PN}-${SLOT}" "${dir}/bin/${BASENAME}.sh"
	newicon "bin/${BASENAME}.png" "${PN}-${SLOT}.png"
	make_desktop_entry "${PN}-${SLOT}" "WebStorm ${SLOT}" "${PN}-${SLOT}" "Development;IDE;"
}
