#!/bin/sh -e
#
# Example Usage: 
# ESMINI_BUILD_INSTALL_PREFIX=~/pb ESMINI_BUILD_PROTOBUF_VERSION=3.15.2 protobuf-install.sh

ESMINI_INSTALL_PREFIX=${ESMINI_INSTALL_PREFIX:-/usr/local}
ESMINI_BUILD_INSTALL_PREFIX=${ESMINI_BUILD_INSTALL_PREFIX:-${ESMINI_INSTALL_PREFIX}}
ESMINI_BUILD_PROTOBUF_VERSION=${ESMINI_BUILD_PROTOBUF_VERSION:-3.21.12}
ESMINI_BUILD_PROTOBUF_SOURCE_DIR="/tmp/protobuf"
ESMINI_BUILD_PROTOBUF_BUILD_DIR="/tmp/build/protobuf"
ESMINI_BUILD_PROTOBUF_BUILD_SHARED_LIBS="OFF"
ESMINI_BUILD_PROTOBUF_WITH_ZLIB="ON"
ESMINI_BUILD_PROTOBUF_INSTALL="ON"

PROTOBUF_SOURCE_REPOSITORY_URL="https://github.com/protocolbuffers/protobuf"

# CMakeLists.txt moved from the cmake directory to the top-level in v3.21
PROTOBUF_SOURCE_CMAKELISTS_DIR=""
if [ "$(pysemver compare "${ESMINI_BUILD_PROTOBUF_VERSION}" "3.21.0")" -lt 0 ]; then
  PROTOBUF_SOURCE_CMAKELISTS_DIR="cmake"
fi

git clone "${PROTOBUF_SOURCE_REPOSITORY_URL}" ${ESMINI_BUILD_PROTOBUF_SOURCE_DIR} \
  --depth 1 \
  --branch "v${ESMINI_BUILD_PROTOBUF_VERSION}" \
  --recurse-submodules
cmake \
  -S ${ESMINI_BUILD_PROTOBUF_SOURCE_DIR}/${PROTOBUF_SOURCE_CMAKELISTS_DIR} \
  -B ${ESMINI_BUILD_PROTOBUF_BUILD_DIR} \
  -DBUILD_SHARED_LIBS="${ESMINI_BUILD_PROTOBUF_BUILD_SHARED_LIBS}" \
  -Dprotobuf_WITH_ZLIB="${ESMINI_BUILD_PROTOBUF_WITH_ZLIB}" \
  -Dprotobuf_BUILD_TESTS=OFF \
  -Dprotobuf_BUILD_EXAMPLES=OFF \
  -Dprotobuf_INSTALL="${ESMINI_BUILD_PROTOBUF_INSTALL}" \
  -DCMAKE_INSTALL_PREFIX="${ESMINI_BUILD_INSTALL_PREFIX}" \
  -DCMAKE_POSITION_INDEPENDENT_CODE=ON
mkdir -p "${ESMINI_BUILD_INSTALL_PREFIX}"
cmake --build ${ESMINI_BUILD_PROTOBUF_BUILD_DIR} --target install

# Cleanup
rm -rf ${ESMINI_BUILD_PROTOBUF_SOURCE_DIR} ${ESMINI_BUILD_PROTOBUF_BUILD_DIR}