# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop
inherit eutils

DESCRIPTION="A cross-platform IDE for C and C++."
HOMEPAGE="https://www.jetbrains.com/clion/"
SRC_URI="https://download.jetbrains.com/cpp/CLion-${PV}.tar.gz"

LICENSE="IDEA || ( IDEA_Academic IDEA_Classroom IDEA_OpenSource IDEA_Personal )"
SLOT="2019.1"
KEYWORDS="~amd64"
IUSE="-bundled-jre"

RDEPEND="!bundled-jre? ( >=virtual/jre-1.7 )"

QA_PREBUILT="opt/${PN}-${SLOT}/*"

S="${WORKDIR}/clion-${PV}"

src_prepare() {
	default

	# CLion only supports x86_64. Remove files that don't meet the criteria.
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
	fperms 755 "${dir}"/bin/{{clion,format,inspect}.sh,fsnotifier64,{printenv,restart}.py}
	fperms 755 "${dir}"/bin/clang/linux/{clangd,clang-tidy}
	fperms 755 "${dir}"/bin/cmake/linux/bin/{ccmake,cmake,cpack,ctest}
	fperms 755 "${dir}"/bin/gdb/linux/bin/{gcore,gdb,gdbserver}
	fperms 755 "${dir}"/bin/lldb/linux/bin/{lldb,lldb-argdumper,LLDBFrontend,lldb-server}
	use bundled-jre && fperms 755 "${dir}"/jre64/bin/{java,jjs,keytool,orbd,pack200,policytool,rmid,rmiregistry,servertool,tnameserv,unpack200}

	make_wrapper "${PN}-${SLOT}" "${dir}/bin/${PN}.sh"
	newicon "bin/${PN}.png" "${PN}-${SLOT}.png"
	make_desktop_entry "${PN}-${SLOT}" "CLion ${SLOT}" "${PN}-${SLOT}" "Development;IDE;"
}
