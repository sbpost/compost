using compost
using SafeTestsets
using DataFrames
using Test

# Test functions that calculate comparative advantage: ==============
@safetestset "Comparative advantage tests" begin include(normpath(@__DIR__, "test/comparative-advantage-tests.jl")) end

# Test functions the calculate similarity and distance measures: ====
@safetestset "Relatedness tests" begin include(normpath(@__DIR__, "test/relatedness-tests.jl")) end

# Test complexity algorithms: =======================================
@safetestset "Complexity algorithm tests" begin include(normpath(@__DIR__, "test/similarity-distance-tests.jl")) end

# Test forecasting functions: =======================================
# TODO:


