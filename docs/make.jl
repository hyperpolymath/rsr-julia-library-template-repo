# SPDX-License-Identifier: MPL-2.0
# SPDX-FileCopyrightText: 2026 {{AUTHOR}} <{{AUTHOR_EMAIL}}>

# Documenter build script — flagship-rubric dimension 5 (Documentation).
#
# Run locally with:  julia --project=docs docs/make.jl
#
# `docs/Project.toml` lists Widget itself as a dep so it resolves inside
# the docs environment, but it is not registered — `Pkg.develop` below
# points it at this checkout (the parent of `docs/`) rather than requiring
# a registry entry. This must run before `using Widget`.

using Pkg
Pkg.develop(Pkg.PackageSpec(path = joinpath(@__DIR__, "..")))

using Documenter
using Widget

DocMeta.setdocmeta!(Widget, :DocTestSetup, :(using Widget); recursive = true)

# Deploying to GitHub Pages requires `GITHUB_TOKEN`/`DOCUMENTER_KEY` and a
# real CI environment (git remote, `GITHUB_ACTIONS`, etc.). Guard it so a
# local `julia --project=docs docs/make.jl` build/doctest run always
# succeeds even outside CI: `deploydocs` is skipped unless we can detect
# we're actually running inside GitHub Actions on this repo.
const IS_CI = get(ENV, "GITHUB_ACTIONS", "false") == "true"

makedocs(;
    modules = [Widget],
    sitename = "Widget.jl",
    authors = "{{AUTHOR}} <{{AUTHOR_EMAIL}}>",
    doctest = true,
    checkdocs = :exports,
    # Explicit `repo` (rather than relying on Documenter's git-remote
    # auto-detection): in sandboxed/CI checkouts `origin` may point at a
    # proxy/mirror URL rather than a real `github.com` remote, which makes
    # `interpret_repo_and_remotes` error out before `makedocs` can run at
    # all. A `Remotes.GitHub` object fully specifies the remote (unlike a
    # bare template string, which only silences the *link-construction*
    # error but leaves the navbar-link URL undeterminable), so the local
    # build/doctest run works regardless of what `git remote -v` shows.
    repo = Remotes.GitHub("{{OWNER}}", "{{REPO}}"),
    format = Documenter.HTML(;
        prettyurls = IS_CI,
        edit_link = "main",
    ),
    pages = [
        "Home" => "index.md",
    ],
    warnonly = [:missing_docs, :cross_references],
)

if IS_CI
    deploydocs(;
        repo = "github.com/{{OWNER}}/{{REPO}}.git",
        devbranch = "main",
    )
end
