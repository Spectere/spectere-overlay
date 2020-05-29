# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Derived from the Sublime Text ebuilds.

EAPI=6

inherit eutils gnome2-utils

DESCRIPTION="Three-way merge tool, side-by-side diffs, syntax highlighting, and more."
HOMEPAGE="http://www.sublimemerge.com"
SRC_URI="https://download.sublimetext.com/sublime_merge_build_${PV}_x64.tar.xz"

LICENSE="Sublime"
SLOT="0"
KEYWORDS="~amd64"
IUSE="dbus"
RESTRICT="bindist mirror strip"

RDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:2
	x11-libs/libX11
	dbus? ( sys-apps/dbus )"

QA_PREBUILT="*"
S="${WORKDIR}/sublime_merge"

src_install() {
	insinto /opt/${PN}
	doins -r Packages Icon
	doins changelog.txt

	exeinto /opt/${PN}
	doexe crash_reporter git-credential-sublime ssh-askpass-sublime sublime_merge
	dosym ../../opt/${PN}/sublime_merge /usr/bin/sublime_merge

	local size
	for size in 16 32 48 128 256; do
		dosym ../../../../../../opt/${PN}/Icon/${size}x${size}/sublime-merge.png \
			/usr/share/icons/hicolor/${size}x${size}/apps/sublime-merge.png
	done

	make_desktop_entry "sublime_merge" "Sublime Merge" "sublime-merge" \
		"RevisionControl;Development" "StartupNotify=true"
}

pkg_postrm() {
	gnome2_icon_cache_update
}

pkg_postinst() {
	gnome2_icon_cache_update
}
