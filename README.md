# rtl9617c-packages

OpenWrt / ImmortalWrt package feed aggregating the decoupled Realtek RTL9617C (Taurus) packages (including out-of-tree PE kernel driver, bare-metal firmware, and LuCI apps). Each package directory is a Git submodule pointing directly to its standalone source repository:

| Package | Upstream Repository | Notes |
| --- | --- | --- |
| `rtl9617c-pon-control` | https://github.com/crysister/rtl9617c-pon-control | PON control daemon & CLI |
| `luci-app-rtl9617c-pon` | https://github.com/crysister/luci-app-rtl9617c-pon | LuCI PON management UI |
| `luci-app-rtl9617c-qos` | https://github.com/crysister/luci-app-rtl9617c-qos | LuCI QoS / Offload / DoS / Mirror UI |
| `rtl9617c-pe-offload` | https://github.com/crysister/rtl9617c-pe-offload | Out-of-tree `kmod-rtl9617c-pe` + Taroko MIPS-I PE bare-metal firmware & `ubus` backend |
| `luci-app-rtl9617c-pe` | https://github.com/crysister/luci-app-rtl9617c-pe | LuCI PE0/PE1 dashboard & one-click controls |

> Core SoC kernel drivers, DTS, patches, and driver host unit tests stay in the OpenWrt / ImmortalWrt target tree (`target/linux/rtl9617c/`). PE driver (`kmod-rtl9617c-pe`) builds fully out-of-tree with zero main-tree patches or DTS edits.

## Usage

Add the feed to your `feeds.conf.default`:

```
src-git rtl9617c https://github.com/crysister/rtl9617c-packages.git
```

Update and install (OpenWrt `scripts/feeds` automatically initializes Git submodules):

```sh
./scripts/feeds update rtl9617c
./scripts/feeds install -a -p rtl9617c
```

Optional LuCI Overview status patch (adds SoC temperature & TRNG status):

```sh
./feeds/rtl9617c/apply-luci-patches.sh
```
