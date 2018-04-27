SUMMARY = "Projects version definition with Git tags and CMake"
SECTION = "devel"
HOMEPAGE = "https://github.com/Oleh-Kravchenko/cmake-version4git"
BUGTRACKER = "https://github.com/Oleh-Kravchenko/cmake-version4git/issues"

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=f967ca707a6df9d1e6b584c85f4d8779"

PV = "git${SRCPV}"
SRCREV = "${AUTOREV}"
SRC_URI = "git://github.com/Oleh-Kravchenko/cmake-version4git.git;protocol=https"
S = "${WORKDIR}/git"

inherit allarch cmake

DEPENDS += "git-native"
PACKAGES = "${PN}-dev"
RDEPENDS_${PN}-dev = "${PN}-dev"

FILES_${PN}-dev += "${libdir}/cmake"

# by default git-native is provided by host system, please see bitbake.conf
EXTRA_OECMAKE += "${@bb.utils.contains('ASSUME_PROVIDED', 'git-native', '-DGIT_EXECUTABLE=/usr/bin/git', '', d)}"
