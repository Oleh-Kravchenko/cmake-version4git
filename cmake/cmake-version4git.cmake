FIND_PACKAGE(Git REQUIRED)

#
# PROJECT_VERSION_FROM_GIT()
#
# Sets project version from git tags.
# This function exports the following variables to parent scope:
#
# PROJECT_VERSION
# PROJECT_VERSION_MAJOR
# PROJECT_VERSION_MINOR
# PROJECT_VERSION_PATCH
# PROJECT_VERSION_TWEAK
# PROJECT_GIT_DIRTY
# PROJECT_GIT_SHORT
# PROJECT_GIT_COMMIT
# PROJECT_GIT_BRANCH
# PROJECT_GIT_URL
#
# <PROJECT_NAME>_VERSION
# <PROJECT_NAME>_VERSION_MAJOR
# <PROJECT_NAME>_VERSION_MINOR
# <PROJECT_NAME>_VERSION_PATCH
# <PROJECT_NAME>_VERSION_TWEAK
# <PROJECT_NAME>_GIT_DIRTY
# <PROJECT_NAME>_GIT_SHORT
# <PROJECT_NAME>_GIT_COMMIT
# <PROJECT_NAME>_GIT_BRANCH
# <PROJECT_NAME>_GIT_URL
#
FUNCTION(PROJECT_VERSION_FROM_GIT)
	SET(GIT_TAG_MATCH "v([0-9]|[1-9][0-9]*)")
	SET(GIT_TAG_MATCH "${GIT_TAG_MATCH}\\.([0-9]|[1-9][0-9]*)")
	SET(GIT_TAG_MATCH "${GIT_TAG_MATCH}(\\.([0-9]|[1-9][0-9]*))?")
	SET(GIT_TAG_MATCH "${GIT_TAG_MATCH}(-([1-9][0-9]*)-g[0-9a-f]+)?")

	MACRO(GIT_EXEC)
		EXECUTE_PROCESS(
		COMMAND
			${GIT_EXECUTABLE} ${ARGN}
		WORKING_DIRECTORY
			${PROJECT_SOURCE_DIR}
		RESULT_VARIABLE
			RES
		OUTPUT_VARIABLE
			COUT
		ERROR_VARIABLE
			CERR
		OUTPUT_STRIP_TRAILING_WHITESPACE
		ERROR_STRIP_TRAILING_WHITESPACE)
	ENDMACRO()

	MACRO(SET_RESULT name value)
		SET(PROJECT_${name} ${value} PARENT_SCOPE)
		SET(${PROJECT_NAME}_${name} ${value} PARENT_SCOPE)
	ENDMACRO()

	GIT_EXEC(rev-parse --verify HEAD)
	IF(NOT RES)
		SET(commit "${COUT}")

		GIT_EXEC(describe --tags)
		IF(NOT RES AND COUT MATCHES "^${GIT_TAG_MATCH}$")
			SET(reason "from tag ${COUT}")
			SET(major "${CMAKE_MATCH_1}")
			SET(minor "${CMAKE_MATCH_2}")

			IF(CMAKE_MATCH_4)
				# tag matches to this pattern vX.Y.Z
				SET(patch "${CMAKE_MATCH_4}")

				IF(CMAKE_MATCH_6)
					SET(tweak "${CMAKE_MATCH_6}")
				ENDIF()
			ELSEIF(CMAKE_MATCH_6)
				# tag matches to this pattern vX.Y
				SET(patch "${CMAKE_MATCH_6}")
			ELSE()
				SET(patch 0)
			ENDIF()
		ELSE()
			MESSAGE("!! Failed to find suitable tag to define"
				" version."
				" Project should be tagged using 'vX.Y'"
				" pattern (e.g. 'v0.1')")

			GIT_EXEC(rev-list --all --count)
			IF(RES)
				MESSAGE(FATAL_ERROR "git error: ${CERR}")
			ENDIF()

			SET(reason "because commit counter is '${COUT}'")
			SET(major 0)
			SET(minor 0)
			SET(patch ${COUT})
		ENDIF()

		GIT_EXEC(diff-index --name-only HEAD)
		IF(RES)
			MESSAGE(FATAL_ERROR "git error: ${CERR}")
		ENDIF()
		IF(COUT)
			SET(dirty 1)
		ELSE()
			SET(dirty 0)
		ENDIF()

		GIT_EXEC(symbolic-ref --short HEAD)
		IF(NOT RES)
			SET(branch "${COUT}")

			GIT_EXEC(config --local
					--get branch.${branch}.remote)
			IF(NOT RES)
				SET(remote "${COUT}")

				GIT_EXEC(config --local
						--get remote.${remote}.url)
				IF(NOT RES)
					SET(url "${COUT}")
				ENDIF()
			ENDIF()
		ENDIF()

		GIT_EXEC(rev-parse --absolute-git-dir)
		IF(RES)
			MESSAGE(FATAL_ERROR "git error: ${CERR}")
		ENDIF()

		SET_PROPERTY(DIRECTORY APPEND PROPERTY
				CMAKE_CONFIGURE_DEPENDS "${COUT}/HEAD")

		IF(branch)
			SET_PROPERTY(DIRECTORY APPEND PROPERTY
					CMAKE_CONFIGURE_DEPENDS
					"${COUT}/refs/heads/${branch}")
		ENDIF()
	ELSE()
		SET(reason "because there's no Git repository")
		SET(reason "${reason} in '${PROJECT_SOURCE_DIR}' or it's empty!")

		SET(major 0)
		SET(minor 0)
		SET(patch 0)
		SET(dirty 1)
	ENDIF()

	SET(cflags -DPROJECT_VERSION_MAJOR=${major}
		-DPROJECT_VERSION_MINOR=${minor}
		-DPROJECT_VERSION_PATCH=${patch}
		-DPROJECT_GIT_DIRTY=${dirty})

	SET(version "${major}.${minor}.${patch}")
	IF(tweak)
		SET(version "${version}.${tweak}")
		SET_RESULT(VERSION_TWEAK ${tweak})
		LIST(APPEND cflags -DPROJECT_VERSION_TWEAK=${tweak})
	ENDIF()

	LIST(APPEND cflags -DPROJECT_VERSION="${version}")

	SET_RESULT(VERSION "${version}")
	SET_RESULT(VERSION_MAJOR ${major})
	SET_RESULT(VERSION_MINOR ${minor})
	SET_RESULT(VERSION_PATCH ${patch})

	MESSAGE(STATUS "Set version of ${PROJECT_NAME} to ${version},"
		" ${reason}")

	SET_RESULT(GIT_DIRTY ${dirty})
	IF(dirty)
		MESSAGE("!! There are not commited changes")
	ENDIF()

	IF(commit)
		STRING(SUBSTRING "${commit}" 0 7 short)

		SET_RESULT(GIT_SHORT "${short}")
		SET_RESULT(GIT_COMMIT "${commit}")

		MESSAGE("   Commit: ${short} ${commit}")
		LIST(APPEND cflags -DPROJECT_GIT_SHORT="${short}"
			-DPROJECT_GIT_COMMIT="${commit}")

		IF(branch)
			SET_RESULT(GIT_BRANCH "${branch}")
			MESSAGE("   Branch: ${branch}")
			LIST(APPEND cflags -DPROJECT_GIT_BRANCH="${branch}")

			IF(url)
				SET_RESULT(GIT_URL "${url}")
				MESSAGE("      URL: ${url}")
				LIST(APPEND cflags
					-DPROJECT_GIT_URL="${url}")
			ENDIF()
		ENDIF()
	ENDIF()

	SET_RESULT(VERSION4GIT_CFLAGS "${cflags}")
ENDFUNCTION()
