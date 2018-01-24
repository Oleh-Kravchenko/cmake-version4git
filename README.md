# Overview

Projects version definition with Git tags and CMake.

# Requirements

Your Git repository must be tagged with the following pattern vX.Y

# Continuous Integration

- Travis CI [![build status](https://api.travis-ci.org/Oleh-Kravchenko/cmake-version4git.svg)](https://travis-ci.org/Oleh-Kravchenko/cmake-version4git)
- Coverage [![Coverage Status](https://coveralls.io/repos/github/Oleh-Kravchenko/cmake-version4git/badge.svg?branch=master)](https://coveralls.io/github/Oleh-Kravchenko/cmake-version4git?branch=master)

# Example

In CMakeLists.txt:

	FIND_PACKAGE(cmake-version4git REQUIRED)

	PROJECT_VERSION_FROM_GIT()

The following variables will be available:

- PROJECT_VERSION       - x.y.z
- PROJECT_VERSION_MAJOR - x
- PROJECT_VERSION_MINOR - y
- PROJECT_VERSION_PATCH - z
- PROJECT_GIT_DIRTY     - TRUE if your git repositry has not commited changes
- PROJECT_GIT_COMMIT    - current commit hash
- PROJECT_GIT_BRANCH    - current branch name
- PROJECT_GIT_URL       - URL of remote repository

Aliases with <PROJECT_NAME>:

- <PROJECT_NAME>_VERSION
- <PROJECT_NAME>_VERSION_MAJOR
- <PROJECT_NAME>_VERSION_MINOR
- <PROJECT_NAME>_VERSION_PATCH
- <PROJECT_NAME>_GIT_DIRTY
- <PROJECT_NAME>_GIT_COMMIT
- <PROJECT_NAME>_GIT_BRANCH
- <PROJECT_NAME>_GIT_URL

Example output of CMake generator:

	-- Set version of cmake-version4git to 0.0.10
	-- There are not commited changes!
	Commit: e6129a1a75aa433dc50c01a9dbd2c3e5813ecce8
	Branch: master
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
