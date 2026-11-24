# rtl9617c-packages

OpenWrt / ImmortalWrt package feed aggregating the decoupled Realtek RTL9617C (Taurus) userspace packages. Each package directory is a Git submodule pointing directly to its standalone source repository:

| Package | Upstream Repository |
| --- | --- |
| `rtl9617c-pon-control` | https://github.com/crysister/rtl9617c-pon-control |
| `luci-app-rtl9617c-pon` | https://github.com/crysister/luci-app-rtl9617c-pon |
| `luci-app-rtl9617c-qos` | https://github.com/crysister/luci-app-rtl9617c-qos |

> Core kernel drivers, DTS, patches, and driver host unit tests stay in the OpenWrt / ImmortalWrt target tree (`target/linux/rtl9617c/`).

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
