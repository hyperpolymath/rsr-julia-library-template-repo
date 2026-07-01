# SPDX-License-Identifier: MPL-2.0
# SPDX-FileCopyrightText: 2026 {{AUTHOR}} <{{AUTHOR_EMAIL}}>

# JET.jl static-analysis testset — flagship-rubric dimension 3 (Static
# quality — JET). See docs/flagship-rubric.adoc.
#
# `target_modules` scopes the report to this package's own code (JET's
# native mechanism — not a hand-rolled file-path filter), so transitive-
# dependency noise from `Base`/stdlib/third-party packages doesn't drown
# out real findings. The flagship bar is zero package-origin reports; if
# `report_package` finds something here, that's a real bug to fix, not a
# scoping problem to silence.

using Test
using JET
using Widget

@testset "JET static analysis gate" begin
    JET.test_package(Widget; target_modules = (Widget,), toplevel_logger = nothing)
end
