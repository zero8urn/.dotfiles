# chezmoi Windows Source Root

## Summary

The Windows install scripts (`windows/install/`) already call `chezmoi apply`, but the repo has
no chezmoi source state — there is nothing for chezmoi to manage yet.

This plan establishes `windows/chezmoi/` as the chezmoi source root via a `.chezmoiroot` file,
migrates existing Windows home files there using chezmoi naming conventions, simplifies
`60-bootstrap-profile.ps1` (chezmoi will own file placement), and moves the Windows install
docs out of the main `README.md` into `windows/README.md`.

### File mapping after migration

| Source file in repo | chezmoi source name | Target on Windows |
|---|---|---|
| `windows/home/psmux/.psmux.conf` | `windows/chezmoi/dot_psmux.conf` | `~/.psmux.conf` |
| `windows/home/posh/dev.profile.ps1` | `windows/chezmoi/dev.profile.ps1` | `~/dev.profile.ps1` |

---

## Todo

- [x] [Create `.chezmoiroot`](#create-chezmoiroot)
- [x] [Create `windows/chezmoi/` source directory](#create-windowschezmoi-source-directory)
- [x] [Delete superseded `windows/home/` tree](#delete-superseded-windowshome-tree)
- [x] [Simplify `60-bootstrap-profile.ps1`](#simplify-60-bootstrap-profileps1)
- [x] [Update `windows/install/README.md`](#update-windowsinstallreadmemd)
- [x] [Create `windows/README.md`](#create-windowsreadmemd)
- [x] [Trim root `README.md`](#trim-root-readmemd)

---

## Create `.chezmoiroot`

Create the file `.chezmoiroot` at the repo root with a single line:

```
windows/chezmoi
```

This tells chezmoi to read all source state from `windows/chezmoi/` rather than the repo
root. All chezmoi special files (`.chezmoi.toml.tmpl`, `.chezmoiscripts/`, etc.) must also
live inside that directory.

---

## Create `windows/chezmoi/` source directory

Create three files inside this new directory.

### `dot_psmux.conf`

Copy from `windows/home/psmux/.psmux.conf`. chezmoi strips the `dot_` prefix and places
the file at `~/.psmux.conf` (`%USERPROFILE%\.psmux.conf`).

### `dev.profile.ps1`

Move from `windows/home/posh/dev.profile.ps1`. No `dot_` prefix — chezmoi places it at
`~/dev.profile.ps1`. This is the file that `60-bootstrap-profile.ps1` previously copied
manually.

### `.chezmoi.toml.tmpl`

Minimal bootstrap config template. Executed once on `chezmoi init` to generate the local
`chezmoi.toml`. Extend this file when machine-specific data variables are needed.

```toml
# chezmoi config template — executed once on `chezmoi init`.
# Add per-machine [data] variables here as the setup grows.

[data]
```

Test with:

```powershell
chezmoi execute-template < windows/chezmoi/.chezmoi.toml.tmpl
```

---

## Delete superseded `windows/home/` tree

Once the files above are in place:

1. Delete `windows/home/psmux/` — replaced by `windows/chezmoi/dot_psmux.conf`
2. Delete `windows/home/posh/` — replaced by `windows/chezmoi/dev.profile.ps1`
3. Delete `windows/home/` if empty after the above

---

## Simplify `60-bootstrap-profile.ps1`

`chezmoi apply` (step 50) now places `~/dev.profile.ps1`. Step 60 only needs to inject the
loader block into `$PROFILE`.

**Remove:**
- `$managedProfile` variable and the path resolution block that references `windows\home\posh\dev.profile.ps1`
- The entire copy/symlink block (the `if ($UseSymlink)` … `else` section)
- The `$UseSymlink` param (no longer needed)

**Keep:**
- `$PROFILE` existence check and creation
- The broken loader line repair block
- The `$loaderBlock` heredoc and conditional `Add-Content` append

**Add a comment** above the loader block:

```powershell
# dev.profile.ps1 is placed by chezmoi apply (50-chezmoi-apply.ps1).
# This script only wires the loader block into $PROFILE.
```

---

## Update `windows/install/README.md`

Update the Notes section to reflect the new split of responsibilities:

| Step | Responsibility |
|---|---|
| `50-chezmoi-apply.ps1` | Places `~/.psmux.conf` and `~/dev.profile.ps1` via `chezmoi apply` |
| `60-bootstrap-profile.ps1` | Injects the dotfiles dev profile loader block into `$PROFILE` only |

---

## Create `windows/README.md`

Extract the Windows-specific content from the root `README.md` into this new file:

- Run-order command block (the `pwsh -File` sequence)
- Post-install section (`gh auth login` + `40-gh-extensions.ps1`)
- PowerShell profile UTF-8 setup (code page, encoding, verification commands)
- Execution policy note
- Native PowerShell tab note (not Git Bash)

Link back to `docs/plan/windows-dotfiles-setup.md` for the detailed planning reference.

---

## Trim root `README.md`

- Remove the "Windows setup" section (everything extracted above)
- Keep the "WezTerm on Windows" section — it describes the WSL `link-home.sh` / `sync-wezterm.sh` integration and belongs with the WSL quickstart context
- Add a brief pointer after the WSL quickstart block:

> For Windows-native setup, see [windows/README.md](../../windows/README.md).

---

## Verification

| Check | Command / method |
|---|---|
| Config template is valid TOML | `chezmoi execute-template < windows/chezmoi/.chezmoi.toml.tmpl` |
| chezmoi sees both targets | `chezmoi diff` after `chezmoi init --source ./` — should show `~/.psmux.conf` and `~/dev.profile.ps1` |
| Profile script no longer errors without `dev.profile.ps1` pre-existing | Run `60-bootstrap-profile.ps1` before `chezmoi apply` on a clean machine |
| Root README has no Windows setup commands | Visual review |
| `windows/README.md` contains full install flow | Visual review |

---

## Future considerations

| Idea | Notes |
|---|---|
| WezTerm `.wezterm.lua` into chezmoi | chezmoi copies by default (no symlinks), same as `sync-wezterm.sh --to-windows`. Drop the two-way sync helper and chezmoi becomes the single source of truth. |
| Replace step 60 with a chezmoi `run_once_` script | A `run_once_bootstrap-profile.ps1` in `.chezmoiscripts/` auto-injects the loader on first `chezmoi apply`, eliminating `60-bootstrap-profile.ps1` entirely. |
| Per-machine data variables | Use `.chezmoi.toml.tmpl` prompts (`promptStringOnce`) to capture machine name, work vs personal profile, etc. |
