#!/bin/sh
# Apply optional RTL9617C LuCI feed patches after "scripts/feeds update luci".
set -e
here="$(cd "$(dirname "$0")" && pwd)"
if [ -n "$1" ]; then
	top="$1"
elif [ -d "$here/../../feeds/luci" ]; then
	top="$(cd "$here/../.." && pwd)"
else
	top="$(git rev-parse --show-toplevel)"
fi
luci="$top/feeds/luci"

[ -d "$luci" ] || {
	echo "missing $luci; run scripts/feeds update luci first" >&2
	exit 1
}

for p in "$here"/luci-app-rtl9617c-pon/feed-patches/*.patch; do
	[ -f "$p" ] || continue
	printf "%-45s " "$(basename "$p")"
	if git -C "$luci" apply --reverse --check "$p" 2>/dev/null; then
		echo "already applied"
		continue
	fi
	git -C "$luci" apply --check "$p" || {
		echo "does not apply" >&2
		exit 1
	}
	git -C "$luci" apply "$p"
	echo applied
done
