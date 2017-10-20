# Overview

Projects version definition with Git tags and CMake.

# Example

In CMakeLists.txt:

	FIND_PACKAGE(cmake-version4git REQUIRED)

	PROJECT_VERSION_FROM_GIT()

Output of CMake generator:

	-- Set version of hello_world to 0.0.1

# Installation

## Gentoo Linux

	$ layman -S
	$ layman -a kaa
	$ emerge dev-util/cmake-version4git -a

## Download and install by CMake

Just add in yours CMakeLists.txt

	INCLUDE(ExternalProject)

	EXTERNALPROJECT_ADD(cmake-version4git
	GIT_REPOSITORY
		https://github.com/Oleh-Kravchenko/cmake-version4git.git
	CMAKE_ARGS
		-DCMAKE_TOOLCHAIN_FILE:PATH=${CMAKE_TOOLCHAIN_FILE}
		-DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
		-DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
		-DCMAKE_INSTALL_BINDIR:PATH=${CMAKE_INSTALL_BINDIR}
		-DCMAKE_INSTALL_SBINDIR:PATH=${CMAKE_INSTALL_SBINDIR}
		-DCMAKE_INSTALL_LIBEXECDIR:PATH=${CMAKE_INSTALL_LIBEXECDIR}
		-DCMAKE_INSTALL_SYSCONFDIR:PATH=${CMAKE_INSTALL_SYSCONFDIR}
		-DCMAKE_INSTALL_SHAREDSTATEDIR:PATH=${CMAKE_INSTALL_SHAREDSTATEDIR}
		-DCMAKE_INSTALL_LOCALSTATEDIR:PATH=${CMAKE_INSTALL_LOCALSTATEDIR}
		-DCMAKE_INSTALL_LIBDIR:PATH=${CMAKE_INSTALL_LIBDIR}
		-DCMAKE_INSTALL_INCLUDEDIR:PATH=${CMAKE_INSTALL_INCLUDEDIR}
		-DCMAKE_INSTALL_DATAROOTDIR:PATH=${CMAKE_INSTALL_DATAROOTDIR})

	FIND_PACKAGE(cmake-version4git REQUIRED)

	PROJECT_VERSION_FROM_GIT()

## Install from sources

	$ git clone https://github.com/Oleh-Kravchenko/cmake-version4git.git
	$ cd cmake-version4git
	$ mkdir build
	$ cd build
	$ cmake -Wno-dev -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local ..
	$ sudo make install
