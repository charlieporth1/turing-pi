################################################################################
#
# minizip
#
################################################################################

MINIZIP_VERSION = 3.0.5
MINIZIP_SITE = $(call github,nmoinvaz,minizip,$(MINIZIP_VERSION))
MINIZIP_DEPENDENCIES = host-pkgconf
MINIZIP_INSTALL_STAGING = YES
MINIZIP_CONF_OPTS = \
	$(if $(BR2_PACKAGE_MINIZIP_DEMOS),-DMZ_BUILD_TEST=ON) \
	-DMZ_COMPAT=OFF \
	-DMZ_FETCH_LIBS=OFF
MINIZIP_LICENSE = Zlib
MINIZIP_LICENSE_FILES = LICENSE
MINIZIP_CPE_ID_VENDOR = minizip_project

ifeq ($(BR2_PACKAGE_BZIP2),y)
MINIZIP_DEPENDENCIES += bzip2
MINIZIP_CONF_OPTS += -DMZ_BZIP2=ON
else
MINIZIP_CONF_OPTS += -DMZ_BZIP2=OFF
endif

ifeq ($(BR2_PACKAGE_LIBICONV),y)
MINIZIP_DEPENDENCIES += libiconv
MINIZIP_CONF_OPTS += -DMZ_ICONV=ON
else
MINIZIP_CONF_OPTS += -DMZ_ICONV=OFF
endif

ifeq ($(BR2_PACKAGE_LIBBSD),y)
MINIZIP_DEPENDENCIES += libbsd
MINIZIP_CONF_OPTS += -DMZ_LIBBSD=ON
else
MINIZIP_CONF_OPTS += -DMZ_LIBBSD=OFF
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
MINIZIP_DEPENDENCIES += openssl
MINIZIP_CONF_OPTS += \
	-DMZ_OPENSSL=ON \
	-DMZ_PKCRYPT=ON \
	-DMZ_WZAES=ON
else
MINIZIP_CONF_OPTS += \
	-DMZ_OPENSSL=OFF \
	-DMZ_PKCRYPT=OFF \
	-DMZ_WZAES=OFF
endif

ifeq ($(BR2_PACKAGE_XZ),y)
MINIZIP_DEPENDENCIES += xz
MINIZIP_CONF_OPTS += -DMZ_LZMA=ON
else
MINIZIP_CONF_OPTS += -DMZ_LZMA=OFF
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
MINIZIP_DEPENDENCIES += zlib
MINIZIP_CONF_OPTS += -DMZ_ZLIB=ON
else
MINIZIP_CONF_OPTS += -DMZ_ZLIB=OFF
endif

ifeq ($(BR2_PACKAGE_ZSTD),y)
MINIZIP_DEPENDENCIES += zstd
MINIZIP_CONF_OPTS += -DMZ_ZSTD=ON
else
MINIZIP_CONF_OPTS += -DMZ_ZSTD=OFF
endif

$(eval $(cmake-package))
