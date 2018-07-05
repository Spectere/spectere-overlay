# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: enhbuild.eclass
# @MAINTAINER:
# spectere@gmail.com
# @AUTHOR:
# Ian Burgmyer
# @BLURB: modified/enhanced versions of Gentoo's standard ebuild functions
# @DESCRIPTION:
# The sutils class contains modified functions from Gentoo's standard utility
# classes. These functions were most likely changed because they didn't suit
# the needs of a particular ebuild.

if [[ -z ${_ENHBUILD_ECLASS} ]]; then
_ENHBUILD_ECLASS=1

inherit eutils

# @FUNCTION: make_wrapper_env
# @USAGE: <wrapper> <target> [chdir] [envvars] [installpath]
# @DESCRIPTION:
# Create a shell wrapper script named wrapper in installpath
# (defaults to the bindir) to execute target (default of wrapper)
# followed by optionally changing directory to chdir.
# Environment variables can be set upon execution by specifying them
# in envvars. Individual variables must be separated by a space.
make_wrapper_env() {
	local wrapper=$1 bin=$2 chdir=$3 envvars=$4 path=$5
	local tmpwrapper=$(emktemp)
	has "${EAPI:-0}" 0 1 2 && local EPREFIX=""

	(
	echo '#!/bin/sh'
	[[ -n ${chdir} ]] && printf 'cd "%s"\n' "${EPREFIX}${chdir}"
	[[ -n ${envvars} ]] && printf "${envvars} "
	# We don't want to quote ${bin} so that people can pass complex
	# things as ${bin} ... "./someprog --args"
    printf 'exec %s "$@"\n' "${bin/#\//${EPREFIX}/}"
    ) > "${tmpwrapper}"
    chmod go+rx "${tmpwrapper}"

    if [[ -n ${path} ]] ; then
        (
        exeopts -m 0755
        exeinto "${path}"
        newexe "${tmpwrapper}" "${wrapper}"
        ) || die
    else
        newbin "${tmpwrapper}" "${wrapper}" || die
    fi
}

fi
