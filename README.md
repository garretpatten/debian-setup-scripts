# Template Repository

A comprehensive template repository for starting new projects with
pre-configured development tools, code quality checks, and security scanning.

## Contents

This template includes the following components:

### Code Formatting

- **Prettier** - Configured with consistent formatting rules (`.prettierrc`)
- **Prettier ignore patterns** (`.prettierignore`) - Excludes build artifacts
  and dependencies

### VS Code Configuration

- **Settings** (`.vscode/settings.json`) - Format on save enabled with Prettier
- **Recommended extensions** (`.vscode/extensions.json`) - Suggests Prettier extension

### GitHub Workflows

- **Quality Checks** (`.github/workflows/quality-checks.yaml`) - Calls
  reusable workflow from `garretpatten/quality-checks` repository to run
  various linters and formatters:
  - Actionlint
  - ESLint
  - Hadolint
  - jq
  - Markdownlint
  - Prettier
  - Ruff
  - Shellcheck
  - Taplo
  - Yamllint

- **Security Checks** (`.github/workflows/security-checks.yaml`) - Calls
  reusable workflow from `garretpatten/security-checks` repository to run
  security scans:
  - Semgrep - Security and code quality scanning
  - Trufflehog - Secret scanning to detect exposed credentials

### GitHub Configuration

- **CODEOWNERS** - Sets repository owner for code review requirements
- **Dependabot** (`.github/dependabot.yaml`) - Automated dependency updates
  for GitHub Actions
- **Issue Template** (`.github/issue_template.md`) - Standardized issue creation
- **Pull Request Template** (`.github/pull_request_template.md`) -
  Standardized PR creation

### Other Files

- **`.gitignore`** - Comprehensive ignore patterns for Node.js, build
  artifacts, and common development files
- **`.truffleignore`** - Patterns to exclude from Trufflehog secret scanning
- **`LICENSE`** - License file for the repository
- **`package.json`** - Node.js package configuration with Prettier as a dev dependency

## Usage

1. Use this repository as a template when creating a new project
2. Customize the configuration files as needed for your specific project
3. Update the CODEOWNERS file with appropriate maintainers
4. Adjust workflow configurations based on your project's requirements

## Requirements

- Node.js (for Prettier)
- GitHub Actions enabled (for workflows)
