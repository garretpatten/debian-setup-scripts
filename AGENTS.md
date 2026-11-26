<!-- markdownlint-disable MD013 -->

# Agent guide — debian-setup-scripts

Bash automation for Debian (12+) development machines: modular install scripts,
shared helpers, and a `src/dotfiles` git submodule. Changes should stay **idempotent**,
**safe to re-run**, and compatible with **headless CI** (no GNOME session).

## Repository standards

[garretpatten/github-standards](https://github.com/garretpatten/github-standards) is the
**canonical source of truth** for how every `garretpatten` repository must be structured
and maintained: license, security policy, contributing, community files, README
branding, CODEOWNERS, branch protection, pull requests, signed commits, Dependabot,
dependency hygiene, secret hygiene, workflow permissions, action pinning, repository
metadata, CI and quality, and exceptions.

- **Before starting any task**, read the current standards from the source of truth
  rather than from memory or a cached copy — they change over time. The standards index
  is at <https://github.com/garretpatten/github-standards#standards-files>; fetch raw
  files from
  `https://raw.githubusercontent.com/garretpatten/github-standards/master/<standard>.md`
  (via web fetch, `curl`, or `gh api`) and read every standard relevant to the task.
- **While working**, apply the standards to every change: workflows, dependency files,
  community files, repository metadata, and commit practices must conform to the
  standards as they exist at the time of the change.
- **When you detect drift** — this repository lagging behind a standard that changed —
  bring the repository back in line as part of normal work and call it out in your
  summary. If an update would be large or ambiguous, propose it instead of applying it
  silently.
- **Before finishing**, confirm the work satisfies the
  [verification](https://github.com/garretpatten/github-standards/blob/master/verification.md)
  standard and that local checks pass.
- For a full compliance review, use the `github-audit` skill, which audits a repository
  against these standards and reports numbered findings.

## Repository layout

| Path                                      | Purpose                                                                                                              |
| ----------------------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| `src/scripts/`                            | `master.sh`, `run-install.sh`, `run-config.sh`                                                                       |
| `src/scripts/install/`                    | APT, third-party installers, repo clones (no `gsettings`/dotfiles)                                                   |
| `src/scripts/install/all.sh`              | Full install orchestrator (pass `cli` or `--cli` for CLI-only mode)                                                  |
| `src/scripts/install/cli.sh`              | Thin wrapper that runs `install/all.sh --cli`                                                                        |
| `src/scripts/install/packages/*.packages` | Apt package lists (one per line)                                                                                     |
| `src/scripts/install/apps/`               | Chrome, Etcher, Proton Pass/VPN, Signal, snaps, hacking repos, ufw-docker                                            |
| `src/scripts/install/dev/`                | Languages, runtimes, LSPs, cursor, ollama, rustup, nvm, etc.                                                         |
| `src/scripts/install/shell/`              | Ghostty, Meslo Nerd Font, Oh My Posh                                                                                 |
| `src/scripts/install/preflight/`          | apt update, essential tools, timezone                                                                                |
| `src/scripts/install/post-install/`       | apt cleanup, docker service, tldr cache, banner                                                                      |
| `src/scripts/install/repos/`              | APT repository manifest + parallel setup                                                                             |
| `src/scripts/lib/`                        | Shared helpers: env, run, apt packages/repos, parallel, dotfiles, snap install, zsh login, git submodules            |
| `src/scripts/config/`                     | GNOME defaults, home layout, UFW policy after packages, targeted dotfile copies into `~`, `~/.dotfiles_path`, `chsh` |
| `src/dotfiles/`                           | Submodule — [garretpatten/dotfiles](https://github.com/garretpatten/dotfiles)                                        |
| `src/assets/`                             | Completion banner ASCII (`debian.txt`; Fastfetch-derived)                                                            |
| `scripts/`                                | Validation scripts for installs, config, and full master runs                                                        |
| `.github/workflows/`                      | CI: four test jobs + quality workflows                                                                               |

## Dotfiles submodule

`src/dotfiles/` is a **Git submodule** pinned to a commit of
[garretpatten/dotfiles](https://github.com/garretpatten/dotfiles).
Never edit files inside `src/dotfiles/` directly in this repository.

If a dotfiles change is needed:

1. Make the change in the `dotfiles` repository and push it.
2. In this repository, update the submodule:
   `cd src/dotfiles && git pull origin master && cd ../..`
3. Commit the submodule pointer change:
   `git add src/dotfiles && git commit -m "Bump dotfiles submodule"`

### Orchestration

- **`master.sh`**: `install/preflight/all.sh` → `config/system/all.sh` → `config/home/all.sh`
  → `install/all.sh` → `config/dev/all.sh` → `config/security/all.sh` → `config/shell/all.sh`.
  Initializes/updates the `src/dotfiles` submodule before running config.
- **`run-install.sh [cli|all]`**: `install/` only. `cli` runs `install/cli.sh`; `all` (default) runs `install/all.sh`.
- **`run-config.sh`**: `config/` only. Initializes/updates the `src/dotfiles` submodule before running config.
- **`npm run all`** / **`npm run install:cli`** / **`npm run install:all`** / **`npm run installs`** /
  **`npm run config`** delegate to those scripts (**`npm install`** at repo root first).

## Script conventions

Scripts in **`install/`** and **`config/`** leaf directories:

1. `#!/bin/bash`.
2. Orchestrators (`master.sh`, `*/all.sh`) source `lib/env.sh`, `lib/run.sh`, and `# shellcheck source=...`
   for any other `lib/*.sh` they use.
3. Leaf scripts should be plain commands; avoid sourcing helpers directly when the orchestrator already sourced them.
4. Non-fatal style: `|| true`, best-effort downloads, `apt-get install` with `--no-install-recommends`.
5. **Headless-safe**: **`gsettings`** only behind **`gnome_session_active`** and D-Bus checks;
   **`config/security/ufw-rules.sh`** exits quietly if **`ufw`** is not installed.

Paths:

- **`PROJECT_ROOT`** is the repo root (two levels above **`src/scripts/`**).
- Dotfiles checkout: **`$PROJECT_ROOT/src/dotfiles`**. **`config/dotfiles.sh`** copies
  **`config/<app>/`** trees into **`~/.config/`** (skipped when the destination already exists).
  **`home/.tmux.conf`** in the submodule expects **`config/tmux/`** under **`~/.config`**;
  see **`src/dotfiles/README.md`**.

**Submodule workflow**: **`git submodule update --init --recursive src/dotfiles/`**. Content edits
belong upstream in **dotfiles**; bump copies here when a new subtree is mandatory for provisioning.

## Product and safety constraints

- **Night Light** (`config/system/gnome-gsettings.sh`) conflicts with **Redshift** (`install/packages/productivity.packages`); pick one policy.
- **Security**: Verified downloads/keyrings, least-privilege dirs, **`config/security/ufw-rules.sh`** **`ufw`** defaults.
- **User impact**: Logout/login for **`docker`** group / default shell / GNOME tweaks.
- No secrets or machine-local paths committed.
- **Debian packaging**: prefer official Debian repos, backports, or documented third-party APT sources over PPAs and snaps.

## Testing and CI

`.github/workflows/test-runner.yaml` runs four jobs in a **`debian:bookworm`** container:

- `test-cli`: `run-install.sh cli` → `scripts/validate-installs-cli.sh`
- `test-config`: `run-config.sh` → `scripts/validate-config-only.sh`
- `test-full`: `run-install.sh all` → `scripts/validate-installs.sh`
- `test-master`: `master.sh` → `scripts/validate.sh` (full installs + config)

GNOME gsettings scripts no-op without an active GNOME session.

## Making changes

| Task                          | Edit                                                                                          |
| ----------------------------- | --------------------------------------------------------------------------------------------- |
| Packages/installers/clones    | Matching **`install/*/`** scripts or **`install/packages/*.packages`**                        |
| GNOME/apt/session/user layout | **`config/system/`**, **`config/home/`**, **`install/preflight/`** as appropriate             |
| Firewall                      | `config/security/ufw-rules.sh` (policy) plus `install/packages/base.packages` (install `ufw`) |
| Dotfile deploy                | **`config/dotfiles.sh`**, **`config/dotfiles.manifest`**                                      |
| Shared logic                  | **`src/scripts/lib/*.sh`**                                                                    |

## Commits and PRs

Do not commit unless asked. PRs that touch **`gsettings`** or Dock: note manual Debian Desktop QA.

## Verify before you finish

Run the checks that match what you changed—**all of the following** still need to pass before work is done:

```bash
npm install

npx prettier --check .
shellcheck -x src/scripts/**/*.sh scripts/**/*.sh
shfmt -d src/scripts/**/*.sh scripts/**/*.sh
npx markdownlint-cli2 README.md AGENTS.md
yamllint .github .yamllint
```

Shell style comes from **`.editorconfig`** (4-space indent), which **`shfmt`** reads
automatically—format with **`shfmt -w`**, never by hand. Install **`shfmt`** at the
version CI pins (3.10.0) if missing:

```bash
go install mvdan.cc/sh/v3/cmd/shfmt@v3.10.0
```

CI's **Quality Checks** lint **changed files only**: any file you touch gets the
full treatment (**`prettier`**, **`shellcheck`**, **`shfmt`**, **`yamllint`**, and
the **OpenGrep SAST** scan). A formatting-only touch to an old file can surface
pre-existing findings in it—make sure the file passes **every** changed-file
gate, not just the one you were aiming for, before you finalize.

When install or validation logic changes, run the matching validation script locally
(for example `./scripts/validate-installs-cli.sh` after `bash src/scripts/run-install.sh cli`).

| If you edited                                                                                     | Run (in addition to **`prettier`** / **`shellcheck`** when applicable) |
| ------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------- |
| Any **`*.md`** at repo root (not submodule)                                                       | **`markdownlint-cli2`** on those paths or the glob above               |
| Workflows, **`ISSUE_TEMPLATE`**, **`dependabot.yaml`**, **`.yamllint`**, **`.markdownlint.yaml`** | **`yamllint`** on the same paths                                       |

Install **`yamllint`** locally if missing (for example `pip install yamllint`). CI’s **Quality Checks** workflow already runs **`yamllint`** on YAML and **`markdownlint`** on Markdown in PRs—local runs should pass before you finalize.

If you change **`src/dotfiles/`**, run the submodule’s tooling as well.

## GitHub Actions

Whenever a GitHub workflow is added, all GitHub Action pins in that workflow
should be updated to point to the full-length commit SHA of the most recent
release.

Never pass **`secrets: inherit`** to a reusable workflow—**OpenGrep's SAST scan
fails the PR on it** (least privilege). Pass only the specific secrets the
called workflow needs, or drop the **`secrets:`** line entirely when it needs
none (verify by grepping the reusable workflow for **`secrets.`**).

## License

MIT — see [LICENSE](./LICENSE).
