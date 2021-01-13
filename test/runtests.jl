using compost
using SafeTestsets
using DataFrames
using Test


# Test functions that calculate comparative advantage: ==============
@safetestset "Comparative advantage tests" begin include("comparative-advantage-tests.jl") end

# Test complexity algorithms: =======================================
@safetestset "Complexity algorithm tests" begin include("complexity-algorithm-tests.jl") end

# Test forecasting functions: =======================================
