#!/bin/bash
# Semgrep pip install — Debian 12+ marks the system Python as externally managed,
# so use --break-system-packages for a user install when the plain install fails.

pip3 install --user semgrep || pip3 install --user --break-system-packages semgrep || true
