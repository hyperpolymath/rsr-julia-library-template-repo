# SPDX-License-Identifier: MPL-2.0
# SPDX-FileCopyrightText: 2026 {{AUTHOR}} <{{AUTHOR_EMAIL}}>

using Test
using Widget

@testset "Widget.jl" begin
    @testset "greet" begin
        @test greet("World") == "Hello, World!"
        @test greet("Julia") == "Hello, Julia!"
        @test greet("") == "Hello, !"
    end

    include("aqua.jl")
    include("jet.jl")
end
