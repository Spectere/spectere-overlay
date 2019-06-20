# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop
inherit eutils

DESCRIPTION="A capable and ergonomic IDE for JVM."
HOMEPAGE="https://www.jetbrains.com/idea/"
SRC_URI="https://download.jetbrains.com/idea/ideaIU-${PV}.tar.gz"

LICENSE="IDEA || ( IDEA_Academic IDEA_Classroom IDEA_OpenSource IDEA_Personal )"
SLOT="2019.1"
IDEAVERSION="191.7479.19"
KEYWORDS="~amd64"
IUSE="-bundled-jre"

RDEPEND="!bundled-jre? ( >=virtual/jre-1.7 )
		>=virtual/jdk-1.7:*"

QA_PREBUILT="opt/${PN}-${SLOT}/*"

BASENAME="idea"

S="${WORKDIR}/idea-IU-${IDEAVERSION}"

src_prepare() {
	default

	# IDEA only supports x86_64. Remove files that don't meet the criteria.
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
	fperms 755 "${dir}"/bin/{{format,idea,inspect}.sh,fsnotifier64,{printenv,restart}.py}
	use bundled-jre && fperms 755 "${dir}"/jre64/bin/{clhsdb,hsdb,java,jjs,keytool,orbd,pack200,policytool,rmid,rmiregistry,servertool,tnameserv,unpack200}

	make_wrapper "${PN}-${SLOT}" "${dir}/bin/${BASENAME}.sh"
	newicon "bin/${BASENAME}.png" "${PN}-${SLOT}.png"
	make_desktop_entry "${PN}-${SLOT}" "IDEA Ultimate ${SLOT}" "${PN}-${SLOT}" "Development;IDE;"
}
