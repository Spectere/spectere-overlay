# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop
inherit eutils

DESCRIPTION="A functional testing tool for SOAP and REST testing."
HOMEPAGE="https://www.soapui.org/"
SRC_URI="https://s3.amazonaws.com/downloads.eviware/soapuios/${PV}/SoapUI-${PV}-linux-bin.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="strip"

DEPEND="app-arch/unzip"
RDEPEND=">=virtual/jre-1.7"

QA_PREBUILT="opt/${PN}/*"

INSTDIR="/opt/${PN}"
ICONFILE="SoapUI-OS_256-256.png"

S="${WORKDIR}/SoapUI-${PV}"

src_prepare() {
	default

	# Extract icon from the JAR file.
	unzip -j bin/soapui-5.5.0.jar com/eviware/soapui/resources/images/${ICONFILE}
}

src_install() {
	insinto "${INSTDIR}"
	doins -r bin lib wsi-test-tools soapui-settings.xml

	fperms 755 "${INSTDIR}"/bin/{loadtestrunner,mockservicerunner,securitytestrunner,soapui,testrunner,toolrunner,wargenerator}.sh

	make_wrapper "${PN}" "${INSTDIR}/bin/soapui.sh"
	newicon "${ICONFILE}" "SoapUI.png"
	make_desktop_entry "soapui" "SoapUI" "SoapUI" "Network;WebDevelopment;"
}
