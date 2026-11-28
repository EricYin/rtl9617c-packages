# rtl9617c-packages

OpenWrt / ImmortalWrt package feed aggregating the decoupled Realtek RTL9617C (Taurus) packages (including out-of-tree PE kernel driver, bare-metal firmware, and LuCI apps). Each package directory is a Git submodule pointing directly to its standalone source repository:

| Package | Upstream Repository | Notes |
| --- | --- | --- |
| `rtl9617c-pon-control` | https://github.com/crysister/rtl9617c-pon-control | PON control daemon & CLI |
| `luci-app-rtl9617c-pon` | https://github.com/crysister/luci-app-rtl9617c-pon | LuCI PON management UI |
| `luci-app-rtl9617c-qos` | https://github.com/crysister/luci-app-rtl9617c-qos | LuCI QoS / Offload / DoS / Mirror UI (v1; mutually exclusive with `qos-v2`) |
| `luci-app-rtl9617c-qos-v2` | https://github.com/crysister/luci-app-rtl9617c-qos-v2 | Smart Hardware SQM v2 Cockpit + out-of-tree `kmod-rtl9617c-dpi` first-packet L7 DPI & RTT Autorate (mutually exclusive with v1) |
| `rtl9617c-pe-offload` | https://github.com/crysister/rtl9617c-pe-offload | Out-of-tree `kmod-rtl9617c-pe` + Taroko MIPS-I PE bare-metal firmware & `ubus` backend |
| `luci-app-rtl9617c-pe` | https://github.com/crysister/luci-app-rtl9617c-pe | LuCI PE0/PE1 dashboard & one-click controls |

> Core SoC kernel drivers, DTS, patches, and driver host unit tests stay in the OpenWrt / ImmortalWrt target tree (`target/linux/rtl9617c/`). Every package in this feed is decoupled so it builds cleanly on both `https://github.com/lyq1996/rtl9617c-openwrt` and `https://github.com/crysister/rtl9617c-immortalwrt` without requiring main-tree kernel patches, extra `config-6.18` selections, or third-party feeds.

## Main-Tree Decoupling & Compatibility

- **Zero third-party feed lock-in**: `luci-app-rtl9617c-pon` no longer hard-depends on `luci-theme-argon` / `luci-i18n-argon-config-zh-cn` (auto-applies Argon only if installed).
- **Out-of-tree PE driver (`kmod-rtl9617c-pe`)**: `rtl9617c-pe-offload` builds `rtl9617c-pe.ko` completely out-of-tree against stock RTL9617C kernels/DTBs (no DTS edits, no main-tree patches) and installs the prebuilt `firmware/pe-offload.bin` by default (pass `RTL9617C_PE_REBUILD_FW=1` to rebuild firmware with MIPS-capable `clang`/`lld`).
- **Auto-selected QoS kernel modules**: `luci-app-rtl9617c-qos` pulls standard OpenWrt `+tc +kmod-sched-flower +kmod-sched-act-police +kmod-sched-mqprio`, so upstream trees that did not enable those `CONFIG_NET_SCH_*`/`CLS_*`/`ACT_*` options in `config-6.18` build them automatically as modules (and built-in trees like `rtl9617c-immortalwrt` satisfy them via `modules.builtin`). Optional NI/FE/crypto/ETS kernel extensions are probed at runtime and degrade gracefully when absent.
- **Target scoping**: All 6 packages carry `@TARGET_rtl9617c`, so adding this feed will never break non-`rtl9617c` targets or emit Kconfig unmet-dependency warnings. `luci-app-rtl9617c-qos` (v1) and `luci-app-rtl9617c-qos-v2` (v2) declare `CONFLICTS` so only one is installed at a time.

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

> If your main tree already bundles `package/rtl9617c/{rtl9617c-pon-control,luci-app-rtl9617c-pon}` (for example `lyq1996/rtl9617c-openwrt`), the command above installs the additional packages (`luci-app-rtl9617c-qos`, `rtl9617c-pe-offload`, `luci-app-rtl9617c-pe`) alongside them. Pass `-f` (`./scripts/feeds install -a -f -p rtl9617c`) if you also want to override the bundled PON packages with this feed's versions.

Optional LuCI Overview status patch (adds SoC temperature & TRNG status):

```sh
./feeds/rtl9617c/apply-luci-patches.sh
```
