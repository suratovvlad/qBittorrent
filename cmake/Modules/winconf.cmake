# Settings for compiling qBittorrent on Windows

list(APPEND CMAKE_LIBRARY_PATH "$ENV{LIB}")

set(LibtorrentRasterbar_CUSTOM_DEFINITIONS
    -DBOOST_ASIO_DISABLE_CONNECTEX
    -DBOOST_EXCEPTION_DISABLE
    -DTORRENT_USE_OPENSSL
    -DTORRENT_DISABLE_RESOLVE_COUNTRIES)

set(LibtorrentRasterbar_CUSTOM_BOOST_DEPENDENCIES system)

# If you want to link with static version of libtorrent
#set(LibtorrentRasterbar_USE_STATIC_LIBS True)
#list(APPEND LibtorrentRasterbar_CUSTOM_DEFINITIONS
#    -DBOOST_SYSTEM_STATIC_LINK=1)

# and boost
#set(Boost_USE_STATIC_LIBS True)
#set(Boost_USE_STATIC_RUNTIME True)

add_definitions(
    -DNTDDI_VERSION=0x06010000
    -D_WIN32_WINNT=0x0601
    -D_WIN32_IE=0x0601
    -DUNICODE
    -D_UNICODE
    -DWIN32
    -D_WIN32
    -DWIN32_LEAN_AND_MEAN
    -D_CRT_SECURE_NO_DEPRECATE
    -D_SCL_SECURE_NO_DEPRECATE
    -DNOMINMAX
    -DBOOST_ALL_NO_LIB
)

# Enable if libtorrent was built with this flag defined
#list(APPEND LibtorrentRasterbar_CUSTOM_DEFINITIONS -DTORRENT_NO_DEPRECATE)

if (("${CMAKE_BUILD_TYPE}" STREQUAL "Debug") OR ("${CMAKE_BUILD_TYPE}" STREQUAL "RelWithDebInfo"))
    list(APPEND LibtorrentRasterbar_CUSTOM_DEFINITIONS
    -DTORRENT_DEBUG)
else ()
    add_definitions(-DNDEBUG)
endif ()

# Here we assume that all required libraries are installed into the same prefix
# with usual unix subdirectories (bin, lib, include)
# if so, we just need to set CMAKE_SYSTEM_PREFIX_PATH
# If it is not the case, individual paths need to be specified manually (see below)
set(COMMON_INSTALL_PREFIX "c:/usr" CACHE PATH "Prefix used to install all the required libraries")
list(APPEND CMAKE_SYSTEM_PREFIX_PATH "${COMMON_INSTALL_PREFIX}")

# If two version of Qt are installed, separate prefixes are needed most likely
set(QT5_INSTALL_PREFIX "${COMMON_INSTALL_PREFIX}/lib/qt5" CACHE PATH "Prefix where Qt5 is installed")

# it is safe to set Qt dirs even if their files are directly in the prefix
set(Qt5_DIR "${QT5_INSTALL_PREFIX}/lib/cmake/Qt5")

# And now we can set specific values for the Boost and libtorrent libraries.
# The following values are generated from the paths listed above just for an example
# they have to be set to actual locations

# Boost
# set(BOOST_ROOT "${COMMON_INSTALL_PREFIX}")
# set(Boost_version_suffix "1_59")
# if a link like boost-version/boost -> boost was created or the boost directory was renamed in the same way,
# the following needs adjustment
# set(BOOST_INCLUDEDIR "${COMMON_INSTALL_PREFIX}/include/boost-${Boost_version_suffix}")
# set(BOOST_LIBRARYDIR "${COMMON_INSTALL_PREFIX}/lib/")

# libtorrent

# set(PC_LIBTORRENT_RASTERBAR_INCLUDEDIR "${COMMON_INSTALL_PREFIX}")
# set(PC_LIBTORRENT_RASTERBAR_LIBDIR "${COMMON_INSTALL_PREFIX}/lib")

set(AUTOGEN_TARGETS_FOLDER "generated")

set(CMAKE_INSTALL_BINDIR ".")

# Test 32/64 bits
if("${CMAKE_SIZEOF_VOID_P}" EQUAL "8")
    message(STATUS "Target is 64 bits")
    if (WIN32)
        set(WINXXBITS Win64)
    endif(WIN32)
else("${CMAKE_SIZEOF_VOID_P}" EQUAL "8")
    message(STATUS "Target is 32 bits")
    if (WIN32)
        set(WINXXBITS Win32)
    endif(WIN32)
endif("${CMAKE_SIZEOF_VOID_P}" EQUAL "8")

if (MSVC)
    include(winconf-msvc)
else (MSVC)
    include(winconf-mingw)
endif (MSVC)
