# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop
inherit eutils

DESCRIPTION="A cross-platform Python IDE."
HOMEPAGE="https://www.jetbrains.com/pycharm/"
SRC_URI="https://download.jetbrains.com/python/${P}.tar.gz"

LICENSE="IDEA || ( IDEA_Academic IDEA_Classroom IDEA_OpenSource IDEA_Personal )"
SLOT="2018.2"
KEYWORDS="~amd64"
IUSE="-bundled-jre"

RDEPEND="!bundled-jre? ( >=virtual/jre-1.7 )"

QA_PREBUILT="opt/${PN}-${SLOT}/*"

BASENAME="pycharm"

S="${WORKDIR}/${P}"

src_prepare() {
	default

	# PyCharm only supports x86_64. Remove files that don't meet the criteria.
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
	fperms 755 "${dir}"/bin/{{format,inspect,pycharm}.sh,fsnotifier64,{printenv,restart}.py}
	use bundled-jre && fperms 755 "${dir}"/jre64/bin/{java,jjs,keytool,orbd,pack200,policytool,rmid,rmiregistry,servertool,tnameserv,unpack200}

	make_wrapper "${PN}-${SLOT}" "${dir}/bin/${BASENAME}.sh"
	newicon "bin/${BASENAME}.png" "${PN}-${SLOT}.png"
	make_desktop_entry "${PN}-${SLOT}" "PyCharm Community ${SLOT}" "${PN}-${SLOT}" "Development;IDE;"
}
