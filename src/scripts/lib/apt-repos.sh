#!/bin/bash

# Debian has no PPAs; keep the helper signature for parity with the Ubuntu orchestrator
# but make it a no-op. Third-party repos are configured via install/repos/setup.sh.

add_ppas_parallel() {
    return 0
}
