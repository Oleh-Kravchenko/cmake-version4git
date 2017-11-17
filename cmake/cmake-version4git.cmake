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
#
# <PROJECT_NAME>_VERSION
# <PROJECT_NAME>_VERSION_MAJOR
# <PROJECT_NAME>_VERSION_MINOR
# <PROJECT_NAME>_VERSION_PATCH
#
FUNCTION(PROJECT_VERSION_FROM_GIT)
	SET(GIT_TAG_MATCH "v([0-9]|[1-9][0-9]*)\\."
		"([0-9]|[1-9][0-9]*)(-([1-9][0-9]*)-g[0-9a-f]+)?")

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

	GIT_EXEC(describe --tags)
	IF(NOT GIT_RES)
		IF(COUT MATCHES "${GIT_TAG_MATCH}")
			SET(major "${CMAKE_MATCH_1}")
			SET(minor "${CMAKE_MATCH_2}")

			IF(CMAKE_MATCH_4)
				SET(patch "${CMAKE_MATCH_4}")
			ELSE()
				SET(patch 0)
			ENDIF()
		ELSE()
			MESSAGE(STATUS
				"Failed to find suitable tag to define"
				" version."
				" Project should be tagged using 'vX.Y'"
				" pattern (e.g. 'v0.1')")

			GIT_EXEC(rev-list --all --count)
			IF(RES)
				MESSAGE(FATAL_ERROR "git error: ${CERR}")
			ENDIF()

			SET(major 0)
			SET(minor 0)
			SET(patch ${COUT})
		ENDIF()
	ELSE()
		MESSAGE(STATUS "There's no Git repository or it's empty!")

		SET(major 0)
		SET(minor 0)
		SET(patch 0)
	ENDIF()

	STRING(CONCAT version ${major} "." ${minor} "." ${patch})

	SET(PROJECT_VERSION "${version}" PARENT_SCOPE)
	SET(PROJECT_VERSION_MAJOR ${major} PARENT_SCOPE)
	SET(PROJECT_VERSION_MINOR ${minor} PARENT_SCOPE)
	SET(PROJECT_VERSION_PATCH ${patch} PARENT_SCOPE)

	SET(${PROJECT_NAME}_VERSION "${version}" PARENT_SCOPE)
	SET(${PROJECT_NAME}_VERSION_MAJOR ${major} PARENT_SCOPE)
	SET(${PROJECT_NAME}_VERSION_MINOR ${minor} PARENT_SCOPE)
	SET(${PROJECT_NAME}_VERSION_PATCH ${patch} PARENT_SCOPE)

	MESSAGE(STATUS "Set version of ${PROJECT_NAME} to ${version}")
ENDFUNCTION()
