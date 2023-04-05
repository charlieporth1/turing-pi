################################################################################
#
# openpowerlink
#
################################################################################

OPENPOWERLINK_VERSION = 2.7.1
OPENPOWERLINK_SITE = https://downloads.sourceforge.net/project/openpowerlink/openPOWERLINK/V$(OPENPOWERLINK_VERSION)
OPENPOWERLINK_SOURCE = openPOWERLINK_V$(OPENPOWERLINK_VERSION).tar.gz
OPENPOWERLINK_LICENSE = BSD-2-Clause, GPL-2.0
OPENPOWERLINK_LICENSE_FILES = license.md

OPENPOWERLINK_INSTALL_STAGING = YES

# The archive has no leading component.
OPENPOWERLINK_STRIP_COMPONENTS = 0

OPENPOWERLINK_MN_ONOFF = $(if $(BR2_PACKAGE_OPENPOWERLINK_MN),ON,OFF)
OPENPOWERLINK_CN_ONOFF = $(if $(BR2_PACKAGE_OPENPOWERLINK_CN),ON,OFF)

#### OPLK LIBRARY ####

# Always build a oplk stack
# Disable library with simulation interface
# Disable zynq/FPGA (PCIe) interface
OPENPOWERLINK_CONF_OPTS += -DCFG_OPLK_LIB=ON \
	-DCFG_COMPILE_LIB_MN_SIM=OFF \
	-DCFG_COMPILE_LIB_CN_SIM=OFF \
	-DCFG_COMPILE_LIB_MNAPP_ZYNQINTF=OFF

# All option are ON by default
ifeq ($(BR2_PACKAGE_OPENPOWERLINK_STACK_MONOLITHIC_USER_STACK_LIB),y)
OPENPOWERLINK_DEPENDENCIES += libpcap
OPENPOWERLINK_CONF_OPTS += \
	-DCFG_COMPILE_LIB_MN=$(OPENPOWERLINK_MN_ONOFF) \
	-DCFG_COMPILE_LIB_MNAPP_USERINTF=OFF \
	-DCFG_COMPILE_LIB_MNAPP_KERNELINTF=OFF \
	-DCFG_COMPILE_LIB_MNAPP_PCIEINTF=OFF \
	-DCFG_COMPILE_LIB_MNDRV_PCAP=OFF \
	-DCFG_COMPILE_LIB_CN=$(OPENPOWERLINK_CN_ONOFF) \
	-DCFG_COMPILE_LIB_CNAPP_USERINTF=OFF \
	-DCFG_COMPILE_LIB_CNAPP_KERNELINTF=OFF \
	-DCFG_COMPILE_LIB_CNDRV_PCAP=OFF \
	-DPCAP_CONFIG="$(STAGING_DIR)/usr/bin/pcap-config"
else ifeq ($(BR2_PACKAGE_OPENPOWERLINK_STACK_USERSPACE_DAEMON_LIB),y)
OPENPOWERLINK_DEPENDENCIES += libpcap
OPENPOWERLINK_CONF_OPTS += \
	-DCFG_COMPILE_LIB_MN=OFF \
	-DCFG_COMPILE_LIB_MNAPP_USERINTF=$(OPENPOWERLINK_MN_ONOFF) \
	-DCFG_COMPILE_LIB_MNAPP_KERNELINTF=OFF \
	-DCFG_COMPILE_LIB_MNAPP_PCIEINTF=OFF \
	-DCFG_COMPILE_LIB_MNDRV_PCAP=$(OPENPOWERLINK_MN_ONOFF) \
	-DCFG_COMPILE_LIB_CN=OFF \
	-DCFG_COMPILE_LIB_CNAPP_USERINTF=$(OPENPOWERLINK_CN_ONOFF) \
	-DCFG_COMPILE_LIB_CNAPP_KERNELINTF=OFF \
	-DCFG_COMPILE_LIB_CNDRV_PCAP=$(OPENPOWERLINK_CN_ONOFF) \
	-DPCAP_CONFIG="$(STAGING_DIR)/usr/bin/pcap-config"
else ifeq ($(BR2_PACKAGE_OPENPOWERLINK_STACK_KERNEL_STACK_LIB),y)
OPENPOWERLINK_CONF_OPTS += \
	-DCFG_COMPILE_LIB_MN=OFF \
	-DCFG_COMPILE_LIB_MNAPP_USERINTF=OFF \
	-DCFG_COMPILE_LIB_MNAPP_KERNELINTF=$(OPENPOWERLINK_MN_ONOFF) \
	-DCFG_COMPILE_LIB_MNAPP_PCIEINTF=OFF \
	-DCFG_COMPILE_LIB_MNDRV_PCAP=OFF \
	-DCFG_COMPILE_LIB_CN=OFF \
	-DCFG_COMPILE_LIB_CNAPP_USERINTF=OFF \
	-DCFG_COMPILE_LIB_CNAPP_KERNELINTF=$(OPENPOWERLINK_CN_ONOFF) \
	-DCFG_COMPILE_LIB_CNDRV_PCAP=OFF
else ifeq ($(BR2_PACKAGE_OPENPOWERLINK_STACK_KERNEL_PCIE_STACK_LIB),y)
OPENPOWERLINK_CONF_OPTS += \
	-DCFG_COMPILE_LIB_MN=OFF \
	-DCFG_COMPILE_LIB_MNAPP_USERINTF=OFF \
	-DCFG_COMPILE_LIB_MNAPP_KERNELINTF=OFF \
	-DCFG_COMPILE_LIB_MNAPP_PCIEINTF=$(OPENPOWERLINK_MN_ONOFF) \
	-DCFG_COMPILE_LIB_MNDRV_PCAP=OFF \
	-DCFG_COMPILE_LIB_CN=OFF \
	-DCFG_COMPILE_LIB_CNAPP_USERINTF=OFF \
	-DCFG_COMPILE_LIB_CNAPP_KERNELINTF=OFF \
	-DCFG_COMPILE_LIB_CNDRV_PCAP=OFF
endif

OPENPOWERLINK_CONF_OPTS += \
	-DCFG_COMPILE_SHARED_LIBRARY=$(if $(BR2_STATIC_LIBS),OFF,ON)

#### OPLK KERNEL DRIVERS ####

ifeq ($(BR2_PACKAGE_OPENPOWERLINK_STACK_KERNEL_STACK_LIB)$(BR2_PACKAGE_OPENPOWERLINK_KERNEL_PCIE_DRIVER),y)
OPENPOWERLINK_DEPENDENCIES += linux

OPENPOWERLINK_CONF_OPTS += \
	-DCFG_KERNEL_DIR="$(LINUX_DIR)" \
	-DCMAKE_SYSTEM_VERSION="$(LINUX_VERSION)" \
	-DCFG_OPLK_MN="$(OPENPOWERLINK_MN_ONOFF)" \
	-DMAKE_KERNEL_ARCH="$(KERNEL_ARCH)" \
	-DMAKE_KERNEL_CROSS_COMPILE="$(CCACHE) $(TARGET_CROSS)"
endif

ifeq ($(BR2_PACKAGE_OPENPOWERLINK_STACK_KERNEL_STACK_LIB),y)
OPENPOWERLINK_CONF_OPTS += -DCFG_KERNEL_DRIVERS=ON \
	-DCFG_POWERLINK_EDRV_82573=$(if $(BR2_PACKAGE_OPENPOWERLINK_KERNEL_DRIVER_82573),ON,OFF) \
	-DCFG_POWERLINK_EDRV_8255X=$(if $(BR2_PACKAGE_OPENPOWERLINK_KERNEL_DRIVER_8255x),ON,OFF) \
	-DCFG_POWERLINK_EDRV_I210=$(if $(BR2_PACKAGE_OPENPOWERLINK_KERNEL_DRIVER_I210),ON,OFF) \
	-DCFG_POWERLINK_EDRV_8111=$(if $(BR2_PACKAGE_OPENPOWERLINK_KERNEL_DRIVER_RTL8111),ON,OFF) \
	-DCFG_POWERLINK_EDRV_8139=$(if $(BR2_PACKAGE_OPENPOWERLINK_KERNEL_DRIVER_RTL8139),ON,OFF)
else
OPENPOWERLINK_CONF_OPTS += -DCFG_KERNEL_DRIVERS=OFF
endif

ifeq ($(BR2_PACKAGE_OPENPOWERLINK_KERNEL_PCIE_DRIVER),y)
OPENPOWERLINK_CONF_OPTS += -DCFG_KERNEL_PCIE_DRIVERS=ON
else
OPENPOWERLINK_CONF_OPTS += -DCFG_KERNEL_PCIE_DRIVERS=OFF
endif

#### OPLK PCAP DAEMON ####

ifeq ($(BR2_PACKAGE_OPENPOWERLINK_STACK_USERSPACE_DAEMON_LIB),y)
OPENPOWERLINK_CONF_OPTS += \
	-DCFG_PCAP_DAEMON=ON \
	-DCFG_OPLK_MN=$(OPENPOWERLINK_MN_ONOFF)
endif

#### OPLK DEMO APPS ####

# See apps/common/cmake/configure-linux.cmake for available options list.
ifeq ($(BR2_PACKAGE_OPENPOWERLINK_STACK_MONOLITHIC_USER_STACK_LIB),y)
OPENPOWERLINK_CONF_OPTS += \
	-DCFG_BUILD_KERNEL_STACK="Link to Application"
else ifeq ($(BR2_PACKAGE_OPENPOWERLINK_STACK_USERSPACE_DAEMON_LIB),y)
OPENPOWERLINK_CONF_OPTS += \
	-DCFG_BUILD_KERNEL_STACK="Linux Userspace Daemon"
else ifeq ($(BR2_PACKAGE_OPENPOWERLINK_STACK_KERNEL_STACK_LIB),y)
OPENPOWERLINK_CONF_OPTS += \
	-DCFG_BUILD_KERNEL_STACK="Linux Kernel Module"
else ifeq ($(BR2_PACKAGE_OPENPOWERLINK_STACK_KERNEL_PCIE_STACK_LIB),y)
OPENPOWERLINK_CONF_OPTS += \
	-DCFG_BUILD_KERNEL_STACK="Kernel stack on PCIe card"
endif

ifeq ($(BR2_PACKAGE_OPENPOWERLINK_DEMO_MN_CONSOLE),y)
OPENPOWERLINK_CONF_OPTS += -DCFG_DEMO_MN_CONSOLE=ON \
	-DCFG_DEMO_MN_CONSOLE_USE_SYNCTHREAD=ON
else
OPENPOWERLINK_CONF_OPTS += -DCFG_DEMO_MN_CONSOLE=OFF
endif

ifeq ($(BR2_PACKAGE_OPENPOWERLINK_DEMO_CN_CONSOLE),y)
OPENPOWERLINK_CONF_OPTS += -DCFG_DEMO_CN_CONSOLE=ON
else
OPENPOWERLINK_CONF_OPTS += -DCFG_DEMO_CN_CONSOLE=OFF
endif

$(eval $(cmake-package))
