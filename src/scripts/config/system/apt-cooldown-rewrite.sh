#!/bin/sh
# 7-day apt package cooldown for apt builds without snapshot support
# (Debian 12 ships apt 2.6, older than the 2.7 APT::Snapshot support).
# Replaces the official Debian archive URLs in /etc/apt/sources.list and
# /etc/apt/sources.list.d with snapshot.debian.org URLs frozen at now minus
# 7 days, then refreshes the indexes, so apt and unattended-upgrades only
# ever see packages that were in the archive at least 7 days ago.
#
# The security pocket is intentionally left live: its Release files expire
# seven days after publication (Valid-Until), which collides with the
# cooldown lag, and security fixes should not be delayed regardless.
# Third-party repositories are never touched.
#
# The unrewritten files are kept in /var/lib/apt-cooldown-snapshot/original;
# run `apt-cooldown-snapshot restore` to put them back (disable the
# apt-cooldown-snapshot.timer first, or the next roll rewrites them again).
#
# This is a Debian 12 adaptation of the canonical kit in
# garretpatten/dotfiles system/apt-cooldown: the snapshot-id line matches the
# kit exactly; only the mechanism differs (URL rewrite instead of
# APT::Snapshot, which this apt cannot parse).

set -eu

LAG_DAYS=7
SNAP_ID="$(date -u -d "$LAG_DAYS days ago" '+%Y%m%dT120000Z')"
BACKUP_DIR="/var/lib/apt-cooldown-snapshot/original"
LOCK_TIMEOUT=300

restore() {
    if [ ! -d "$BACKUP_DIR" ]; then
        echo "apt-cooldown-snapshot: no cooldown backup to restore" >&2
        exit 1
    fi
    for src in "$BACKUP_DIR"/sources.list "$BACKUP_DIR"/sources.list.d/*; do
        [ -f "$src" ] || continue
        dest="/etc/apt/${src#"$BACKUP_DIR"}"
        mkdir -p "$(dirname "$dest")"
        cp "$src" "$dest"
    done
    rm -rf "$BACKUP_DIR"
    echo "apt-cooldown-snapshot: originals restored; disable"
    echo "apt-cooldown-snapshot.timer to stay opted out"
}

if [ "${1:-}" = restore ]; then
    restore
    apt-get -o DPkg::Lock::Timeout="$LOCK_TIMEOUT" update || true
    exit 0
fi

changed=0
for f in /etc/apt/sources.list /etc/apt/sources.list.d/*.list \
    /etc/apt/sources.list.d/*.sources; do
    [ -f "$f" ] || continue
    # Keep the pre-cooldown file so the rewrite can be undone with `restore`.
    if [ ! -f "$BACKUP_DIR${f#/etc/apt}" ]; then
        mkdir -p "$BACKUP_DIR$(dirname "${f#/etc/apt}")"
        cp -p "$f" "$BACKUP_DIR${f#/etc/apt}"
    fi
    sed -i -E \
        -e "s#snapshot\.debian\.org/archive/debian/[0-9]{8}T[0-9]{6}Z([/[:space:]]|$)#snapshot.debian.org/archive/debian/$SNAP_ID\1#g" \
        -e "s#https?://(deb\.debian\.org|archive\.debian\.org|ftp\.debian\.org|httpredir\.debian\.org|cdn-aws\.deb\.debian\.org)/debian([/[:space:]]|$)#https://snapshot.debian.org/archive/debian/$SNAP_ID\2#g" \
        "$f" || continue
    changed=1
done

[ "$changed" = 1 ] || exit 0

# Refresh indexes from the lagged snapshot. Tolerate brief lock contention
# from other apt timers.
apt-get -o DPkg::Lock::Timeout="$LOCK_TIMEOUT" update
