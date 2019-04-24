# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="irserver"
PKG_VERSION="6.09.04"
PKG_REV="100"
PKG_SHA256="0ce8baa3216d0c45bec0fb8384363c5a4ae93b384654d758373f912648ffb930"
PKG_ARCH="x86_64 arm"
PKG_LICENSE="BSD_3_Clause"
PKG_SITE="http://www.irtrans.de/en/"
PKG_URL="http://www.irtrans.de/download/Server/Linux/irserver-src.tar.gz"
PKG_DEPENDS_TARGET="toolchain lirc"
PKG_SECTION="service"
PKG_SHORTDESC="IRTrans server: transforms your PC into a programmable remote control."
PKG_LONGDESC="IRTrans server ($PKG_VERSION): transforms your PC into a programmable remote control: It learns the codes of your remote control, stores them in a database and sends them controlled by your applications."

#PKG_SOURCE_DIR="irserver-$PKG_VERSION*"
PKG_TOOLCHAIN="make"
#PKG_BUILD_FLAGS="-parallel"

#PKG_MAKE_OPTS=
#PKG_MAKE_OPTS_BOOTSTRP=
#PKG_MAKE_OPTS_HOST=
#PKG_MAKE_OPTS_INIT=
#PKG_MAKE_OPTS_TARGET=
#PKG_MAKEINSTALL_OPTS_HOST=
#PKG_MAKEINSTALL_OPTS_TARGET=

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="IRTrans Server"
PKG_ADDON_TYPE="xbmc.service"
#PKG_ADDON_VERSION=
#PKG_ADDON_PROVIDES=
#PKG_ADDON_REQUIRES=
#PKG_ADDON_PROJECTS=
#PKG_ADDON_IS_STANDALONE=
#PKG_ADDON_BROKEN=

if [ "$TARGET_ARCH" = "x86_64" ]; then
  IRSERVER_BIN="irserver64"
elif [ "$TARGET_ARCH" = "arm" ]; then
  IRSERVER_BIN="irserver_arm"
fi

unpack() {

  # TODO: I am not sure why this is required honestly....
  mkdir -p $PKG_BUILD
  tar -xzf $SOURCES/$PKG_NAME/$PKG_NAME-$PKG_VERSION.tar.gz -C $PKG_BUILD/
}

make_target() {
  # -Wno-unused-variable -Wno-pointer-sign -Wno-unused-but-set-variable -Wno-parentheses -Wno-format-overflow
  # Old project with tons of build warning - silence them all!
  make CC=$CC CFLAGS="$CFLAGS -Wno-unused-variable -Wno-pointer-sign -Wno-unused-but-set-variable -Wno-parentheses -Wno-format-overflow -Wno-implicit-function-declaration -Wno-maybe-uninitialized -Wno-format -Wno-misleading-indentation -Wno-implicit-int -Wno-sizeof-pointer-memaccess -Wno-int-conversion" LDFLAGS="$LDFLAGS" $IRSERVER_BIN
  $STRIP $IRSERVER_BIN
}

makeinstall_target() {

  # We don't need this anymore since we can co-exist with lircd
  #mkdir -p $INSTALL/usr/config
  #  cp $PKG_DIR/config/*.conf $INSTALL/usr/config

  # Regardless of arch, always name the binary "irserver"
  mkdir -p $INSTALL/usr/sbin
  cp -P $IRSERVER_BIN $INSTALL/usr/sbin/irserver

  # Install these 2 remotes for now
  # TODO: need to rename the key to linux uinput standard keys here
  mkdir -p $INSTALL/usr/share/irtrans/remotes
    cp remotes/irtrans.rem $INSTALL/usr/share/irtrans/remotes
    cp remotes/mediacenter.rem $INSTALL/usr/share/irtrans/remotes
}

addon() {

  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID

  cp -PR $PKG_BUILD/.install_pkg/usr/sbin                  $ADDON_BUILD/$PKG_ADDON_ID/bin/
  cp -PR $PKG_BUILD/.install_pkg/usr/share/irtrans/remotes $ADDON_BUILD/$PKG_ADDON_ID/bin/remotes/

}
