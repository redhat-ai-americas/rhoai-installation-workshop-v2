# Contributing Guide

Thank you for contributing to the RHOAI Installation Workshop repository. This guide explains repository conventions, helper scripts, and the checks enforced by GitHub Actions so you can validate changes locally before opening a pull request.

## Repository layout

Workshop content lives under `configs/`, organized into numbered sections (`00-cluster-setup` through `07-ai-pipelines`). Each section has its own README with step-by-step `oc apply -k` instructions. See the [project README](README.md) for an overview and suggested order.

| Path | Purpose |
|------|---------|
| `configs/` | Kustomize overlays, manifests, and section READMEs |
| `scripts/` | Linting and formatting helpers used locally and in CI |
| `.github/workflows/` | GitHub Actions validation jobs |
| `.yamllint` | YAML lint configuration |
| `.spellcheck.yaml` | Markdown spellcheck configuration |
| `.wordlist-txt` | Custom dictionary for spellcheck |

## Prerequisites

Install the tools used by CI and the helper scripts before contributing:

| Tool | Used by |
|------|---------|
| [Kustomize](https://kubectl.docs.kubernetes.io/installation/kustomize/) (`kustomize` or `oc kustomize`) | `validate_manifests.sh`, `lint-kustomize` job |
| [yq](https://github.com/mikefarah/yq) | `check-kustomization-format.sh`, `sort-kustomization-resources.sh` |
| `jq` | `check-kustomization-format.sh` |
| [yamllint](https://yamllint.readthedocs.io/) | `lint-yaml` job |
| [Helm](https://helm.sh/) | `lint-helm` job (when charts are present) |
| `htpasswd` (from `httpd-tools`) | `configs/00-cluster-setup/01-generate-htpasswd.sh` |

Python 3.14 is used in CI for `yamllint`; any recent Python 3 release should work locally.

## Scripts (`scripts/`)

These scripts support manifest validation and formatting. Run them from the repository root.

### `validate_manifests.sh`

Builds every `kustomization.yaml` overlay in the repository to confirm Kustomize can render manifests without errors.

```bash
touch configs/00-cluster-setup/02-user-auth/.htpasswd
./scripts/validate_manifests.sh
```

**What it does:**

- Finds all directories containing a `kustomization.yaml` file
- Runs `kustomize build` (or `oc kustomize`) with `--enable-helm` on each overlay
- Skips paths matching `./bootstrap`
- Exits with an error if any overlay fails to build

**Options:**

| Flag | Description |
|------|-------------|
| `-d`, `--directory=DIRECTORY` | Base directory to search (default: repository root) |
| `-e`, `--enforce-all-schemas` | Disable `--ignore-missing-schemas` for kubeval (kubeval validation is currently commented out in the script) |
| `-sl`, `--schema-location=PATH` | Schema location for kubeval (default: `openshift-json-schema/`) |
| `-h`, `--help` | Show help text |

**Note:** CI creates an empty `.htpasswd` file before running this script because the cluster-setup `secretGenerator` references that file. Create or touch it locally when validating manifests.

### `check-kustomization-format.sh`

Checks that all `kustomization.yaml` files follow formatting standards enforced in CI.

**What it checks:**

- `resources`, `components`, and `bases` lists are sorted alphabetically (ASCII / C locale)
- Blank line after `kind: Kustomization`
- Blank line before major sections (`resources`, `components`, `bases`, `patches`, `replacements`, `configMapGenerator`, `secretGenerator`, and others)
- Exception: a `components` entry containing `anythingllm-image` may appear at the end of the list even if it would sort elsewhere

```bash
./scripts/check-kustomization-format.sh
```

On failure, the script suggests running `sort-kustomization-resources.sh` to fix sorting and spacing issues.

### `sort-kustomization-resources.sh`

Automatically fixes common `kustomization.yaml` formatting issues.

**What it does:**

- Sorts `resources`, `components`, and `bases` lists alphabetically using `yq`
- Adds blank lines before major Kustomization sections for consistent spacing

```bash
./scripts/sort-kustomization-resources.sh
git diff
```

Review the diff before committing. This script modifies files in place.

### `sort-wordlist.sh`

Sorts and deduplicates the spellcheck custom dictionary.

```bash
./scripts/sort-wordlist.sh
```

Run this after adding entries to `.wordlist-txt` so the wordlist stays sorted and duplicate-free.

## GitHub Actions

The workflow [`.github/workflows/validate-manifests.yaml`](.github/workflows/validate-manifests.yaml) runs on **pull requests** (all branches) and **pushes to `main`**. All jobs must pass before merging.

### `lint-kustomize`

Validates that every Kustomize overlay builds successfully.

```bash
touch configs/00-cluster-setup/02-user-auth/.htpasswd
./scripts/validate_manifests.sh
```

### `lint-yaml`

Runs `yamllint` against the repository using [.yamllint](.yamllint).

```bash
pip install yamllint
yamllint . -f github
```

Key `.yamllint` settings:

- `document-start` is disabled (YAML files do not require a `---` header)
- `line-length` is disabled
- `truthy` rule ignores `.github/workflows/` (allows `on: pull_request` without quoting)
- `*/charts/` directories are ignored

### `lint-helm`

Runs `helm lint` on every Helm chart found under `HELM_DIRS`. The repository currently has no `Chart.yaml` files; this job is in place for future charts.

```bash
# When charts exist:
find . -name Chart.yaml -exec dirname {} \; | while read chart; do helm lint "$chart"; done
```

### `check-spelling`

Spellchecks all Markdown files using [rojopolis/spellcheck-github-actions](https://github.com/rojopolis/spellcheck-github-actions) with [.spellcheck.yaml](.spellcheck.yaml).

- Scans `**/*.md`
- Uses `.wordlist-txt` as a custom dictionary
- Ignores content inside code blocks and `<pre>` elements

When spellcheck fails on a valid technical term, add the word to `.wordlist-txt` and run:

```bash
./scripts/sort-wordlist.sh
```

### `check-kustomization-format`

Validates `kustomization.yaml` formatting standards.

```bash
./scripts/check-kustomization-format.sh
```

Requires `yq` and `jq`.

## Run all checks locally

From the repository root:

```bash
touch configs/00-cluster-setup/02-user-auth/.htpasswd

./scripts/validate_manifests.sh
./scripts/check-kustomization-format.sh
yamllint . -f github
```

For spellcheck locally, install [pyspelling](https://github.com/facelessuser/pyspelling) and run it with `.spellcheck.yaml`, or rely on the `check-spelling` CI job.

## Contribution guidelines

### Manifests and Kustomize

- Place new workshop steps under the appropriate `configs/<section>/` directory with a numbered subdirectory (for example, `03-rhoai-operator-dependencies/02-jobset-operator/`).
- Each step should include a `kustomization.yaml` and a README entry in the section README with the `oc apply -k` command.
- Keep `kustomization.yaml` lists sorted and spaced according to the formatting rules above.
- Apply manifests from the repository root unless a section README specifies otherwise.

### Markdown and documentation

- Update the section README when adding or changing steps.
- Use clear, workshop-oriented language consistent with existing READMEs.
- Run spellcheck considerations: add workshop-specific terms to `.wordlist-txt` when needed.

### Shell scripts in `configs/`

Some workshop steps use scripts outside `scripts/` (for example, `01-generate-htpasswd.sh`, `06-scale-workers.sh`, and `10-connectivity-link-tls-setup.sh`). These are operational scripts for cluster setup, not CI helpers. Document them in the relevant section README. Use `set -e` and a shebang for new scripts.

### Pull requests

1. Run local validation (`validate_manifests.sh`, `check-kustomization-format.sh`, `yamllint`) before pushing.
2. Ensure GitHub Actions pass on your pull request.
3. Describe what workshop capability the change adds or fixes.
4. Note any manual cluster steps required beyond `oc apply -k`.

## Questions

Open an issue or discuss changes in your pull request if you are unsure which section a manifest belongs in or how to structure a new workshop step.
