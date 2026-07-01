# SPDX-License-Identifier: MPL-2.0
# SPDX-FileCopyrightText: 2026 {{AUTHOR}} <{{AUTHOR_EMAIL}}>

# Widget — placeholder module for the rsr-julia-library-template-repo.
#
# Rename this module (and this file, and the `name`/`uuid` in Project.toml)
# to your real package name when instantiating from this template. Generate
# a fresh uuid with `julia -e 'using UUIDs; println(uuid4())'` — do not
# keep this one, it identifies the template itself, not your package.

module Widget

export greet

"""
    greet(name::AbstractString) -> String

Return a friendly greeting for `name`.

# Examples
```jldoctest
julia> greet("World")
"Hello, World!"
```
"""
greet(name::AbstractString) = "Hello, $(name)!"

end
