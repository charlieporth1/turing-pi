#!/usr/bin/env bash

RELEASE_VERSION=$(curl --silent "https://api.github.com/repos/tailscale/tailscale/tags" | jq -r '.[0].name' | awk -F'v' '{print $2}')
NAME=tailscale_${RELEASE_VERSION}_${ARCH}

if [[ -f ${NAME}.tgz ]]; then
	rm ${NAME}.tgz
fi

curl https://pkgs.tailscale.com/stable/${NAME}.tgz --output ${NAME}.tgz

tar -xvf ${NAME}.tgz
cp -rf ${NAME}/tailscale br2t113pro/board/100ask/rootfs_overlay/bin/tailscale
cp -rf ${NAME}/tailscaled br2t113pro/board/100ask/rootfs_overlay/bin/tailscaled

cp -rf ${NAME}/tailscale buildroot/system/skeleton/usr/bin/
cp -rf ${NAME}/tailscaled buildroot/system/skeleton/usr/bin/

chmod +x br2t113pro/board/100ask/rootfs_overlay/bin/tailscale
chmod +x br2t113pro/board/100ask/rootfs_overlay/bin/tailscaled

chmod +x buildroot/system/skeleton/usr/bin/
chmod +x buildroot/system/skeleton/usr/bin/

