# immunity.org
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.

include $(TOPDIR)/rules.mk

PKG_NAME:=immunity-config
PKG_VERSION:=$(shell cat ../VERSION)
PKG_RELEASE:=1
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)/$(PKG_SOURCE_SUBDIR)
PKG_LICENSE:=GPL-3.0
PKG_MAINTAINER:=Federico Capoano <f.capoano@immunity.io>

include $(INCLUDE_DIR)/package.mk

define Package/immunity-config
	TITLE:=Remote configuration management agent
	CATEGORY:=Administration
	SECTION:=admin
	SUBMENU:=immunity
	DEPENDS:=+curl +lua +libuci-lua +luafilesystem +luci-lib-nixio +ca-certificates
	PKGARCH:=all
	URL:=http://immunity.org
endef

define Build/Compile
endef

define Package/immunity-config/conffiles
/etc/config/immunity
/etc/immunity/
endef

define Package/immunity-config/install
	$(INSTALL_DIR) \
		$(1)/usr/sbin \
		$(1)/etc/init.d \
		$(1)/etc/config \
		$(1)/usr/lib/immunity-config \
		$(1)/usr/lib/lua/immunity

	$(INSTALL_BIN) \
		files/immunity.agent \
		$(1)/usr/sbin/immunity_config

	$(INSTALL_BIN) \
		files/immunity.init \
		$(1)/etc/init.d/immunity_config

	$(INSTALL_CONF) files/immunity.config \
		$(1)/etc/config/immunity

	$(INSTALL_BIN) \
		files/sbin/immunity-reload-config \
		$(1)/usr/sbin/immunity-reload-config

	$(INSTALL_BIN) \
		files/lib/immunity/utils.lua \
		$(1)/usr/lib/lua/immunity/utils.lua

	$(INSTALL_BIN) \
		files/lib/immunity/net.lua \
		$(1)/usr/lib/lua/immunity/net.lua

	$(INSTALL_BIN) \
		files/sbin/immunity-store-unmanaged.lua \
		$(1)/usr/sbin/immunity-store-unmanaged

	$(INSTALL_BIN) \
		files/sbin/immunity-restore-unmanaged.lua \
		$(1)/usr/sbin/immunity-restore-unmanaged

	$(INSTALL_BIN) \
		files/sbin/immunity-remove-default-wifi.lua \
		$(1)/usr/sbin/immunity-remove-default-wifi

	$(INSTALL_BIN) \
		files/sbin/immunity-uci-autoname.lua \
		$(1)/usr/sbin/immunity-uci-autoname

	$(INSTALL_BIN) \
		files/sbin/immunity-update-config.lua \
		$(1)/usr/sbin/immunity-update-config

	$(INSTALL_BIN) \
		files/sbin/immunity-get-address.lua \
		$(1)/usr/sbin/immunity-get-address

	$(INSTALL_BIN) \
		files/sbin/immunity-get-random-number.lua \
		$(1)/usr/sbin/immunity-get-random-number

	$(CP) ../VERSION $(1)/usr/lib/immunity-config/
endef

$(eval $(call BuildPackage,immunity-config))
