#!/bin/bash

# 7-day apt package supply-chain cooldown (issue #15).
# Canonical kit: src/dotfiles/system/apt-cooldown (garretpatten/dotfiles#51).
#
# apt >= 2.7 (Debian 13+, Ubuntu 24.04+): installs the kit script and systemd
# units verbatim and enables its daily timer. The Debian archive Release files
# carry no Snapshots: field, so a static apt.conf drop-in maps the main
# archive onto snapshot.debian.org. The security pocket keeps live updates:
# its Release files expire seven days after publication (Valid-Until), which
# collides with the cooldown lag.
#
# apt < 2.7 (Debian 12): has no snapshot support, so the kit script is inert;
# a sources-rewrite adaptation is installed under the same units instead.

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../../lib/env.sh
source "$DIR/../../lib/env.sh"

KIT="$PROJECT_ROOT/src/dotfiles/system/apt-cooldown"
[[ -d "$KIT" ]] || exit 0

apt_version="$(apt-get --version 2>/dev/null | awk 'NR == 1 {print $2}')"
snapshots_supported() {
    dpkg --compare-versions "${apt_version:-0}" ge 2.7 2>/dev/null
}

# Sources rewritten by the Debian 12 fallback must be restored before the
# snapshot-aware kit takes over, or apt would keep fetching frozen URLs.
if snapshots_supported && [[ -d /var/lib/apt-cooldown-snapshot/original ]]; then
    sudo /usr/local/sbin/apt-cooldown-snapshot restore 2>/dev/null || true
fi

if snapshots_supported; then
    payload="$KIT/apt-cooldown-snapshot"
else
    payload="$DIR/apt-cooldown-rewrite.sh"
fi
sudo install -m 755 "$payload" /usr/local/sbin/apt-cooldown-snapshot || exit 0
sudo install -m 644 "$KIT/apt-cooldown-snapshot.service" /etc/systemd/system/ || true
sudo install -m 644 "$KIT/apt-cooldown-snapshot.timer" /etc/systemd/system/ || true

# Debian only: point apt at the time-based snapshot service for the main
# archive. Ubuntu discovers snapshot servers through the Snapshots: field in
# its own Release files, so the drop-in stays Debian-specific.
if snapshots_supported && grep -qs '^ID=debian' /etc/os-release; then
    sudo tee /etc/apt/apt.conf.d/99-cooldown-snapshot-debian >/dev/null <<'EOF' || true
// Issue #15: 7-day package cooldown. snapshot.debian.org needs an explicit
// URI template because the archive Release files carry no Snapshots: field.
// The security pocket is intentionally left live — see the header of
// config/system/apt-cooldown.sh.
Acquire::Snapshots::URI::Origin::Debian "https://snapshot.debian.org/archive/debian/@SNAPSHOTID@/";
EOF
fi

sudo systemctl daemon-reload 2>/dev/null || true
sudo systemctl enable --now apt-cooldown-snapshot.timer 2>/dev/null || true
