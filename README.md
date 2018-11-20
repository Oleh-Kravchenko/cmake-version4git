# Overview

Projects version definition with Git tags and CMake.

# Requirements

Your Git repository must be tagged with the following pattern vX.Y[.Z]

# Continuous Integration

- Travis CI [![build status](https://api.travis-ci.org/Oleh-Kravchenko/cmake-version4git.svg)](https://travis-ci.org/Oleh-Kravchenko/cmake-version4git)
- Coverage [![Coverage Status](https://coveralls.io/repos/github/Oleh-Kravchenko/cmake-version4git/badge.svg?branch=master)](https://coveralls.io/github/Oleh-Kravchenko/cmake-version4git?branch=master)

# Example

In CMakeLists.txt:

	FIND_PACKAGE(cmake-version4git REQUIRED)

	PROJECT_VERSION_FROM_GIT()
	# or if your project sources in another directory
	# PROJECT_VERSION_FROM_GIT(${CMAKE_CURRENT_SOURCE_DIR}/fancylibrary)

The following variables will be available:

- PROJECT_VERSION            - x.y.z[.n]
- PROJECT_VERSION_MAJOR      - x
- PROJECT_VERSION_MINOR      - y
- PROJECT_VERSION_PATCH      - z
- PROJECT_VERSION_TWEAK      - n is defined only, if tag follow pattern vX.Y.Z
- PROJECT_GIT_DIRTY          - TRUE if your git repositry has not commited changes
- PROJECT_GIT_COMMIT         - current commit hash
- PROJECT_GIT_BRANCH         - current branch name
- PROJECT_GIT_URL            - URL of remote repository
- PROJECT_GIT_REMOTE         - name of 'remote'
- PROJECT_GIT_SHORT          - current commit short hash
- PROJECT_VERSION4GIT_CFLAGS - all cmake-version4git's variables in C/C++ definitions
- PROJECT_COMMITTER_DATE     - committer date, UNIX timestamp

Aliases with <PROJECT_NAME>:

- <PROJECT_NAME>_VERSION
- <PROJECT_NAME>_VERSION_MAJOR
- <PROJECT_NAME>_VERSION_MINOR
- <PROJECT_NAME>_VERSION_PATCH
- <PROJECT_NAME>_VERSION_TWEAK
- <PROJECT_NAME>_GIT_DIRTY
- <PROJECT_NAME>_GIT_COMMIT
- <PROJECT_NAME>_GIT_BRANCH
- <PROJECT_NAME>_GIT_URL
- <PROJECT_NAME>_GIT_REMOTE
- <PROJECT_NAME>_GIT_SHORT
- <PROJECT_NAME>_VERSION4GIT_CFLAGS
- <PROJECT_NAME>_COMMITTER_DATE

Example output of CMake generator:

	-- Set version of cmake-version4git to 0.3.5, from tag v0.3-5-g17e6d06
	!! There are not commited changes
	   Commit: 17e6d06 17e6d060058c68490fdeb8dd79fbfcab80d736d3
	   Branch: master
	   Remote: github
	      URL: git@github.com:Oleh-Kravchenko/cmake-version4git.git

# Installation

## Gentoo Linux

	$ layman -S
	$ layman -a kaa
	$ emerge dev-util/cmake-version4git -a

## Use as git submodule

Add submodule

	git submodule add https://github.com/Oleh-Kravchenko/cmake-version4git.git 3rdparty/cmake-version4git

Add into your CMakeLists.txt file

	INCLUDE(3rdparty/cmake-version4git/cmake/cmake-version4git.cmake)

	PROJECT_VERSION_FROM_GIT()

## Install from sources

	$ git clone https://github.com/Oleh-Kravchenko/cmake-version4git.git
	$ cd cmake-version4git
	$ mkdir build
	$ cd build
	$ cmake -Wno-dev -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local ..
	$ sudo make install

## Yocto

Please use recipe contrib/yocto/cmake-version4git_git.bb
