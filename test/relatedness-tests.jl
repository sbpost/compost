using DataFrames

# Create test data
INCIDENCE_MAT = [0 1 0 1 1 0 0 0 0 0;
		 0 1 1 0 0 0 1 0 0 0;
		 1 1 0 1 1 0 0 0 1 1;
		 1 0 0 1 0 1 0 0 1 1;
		 0 0 1 1 0 0 0 1 0 0]

C_MAT = INCIDENCE_MAT'INCIDENCE_MAT

@testset "Similarity methods tests" begin

	# Check inputs:
	@test_throws MethodError similarity(DataFrame(INCIDENCE_MAT), method="jaccard", orientation="colwise") # non-matrix input
	@test_throws MethodError get_rca(INCIDENCE_MAT[:, 1], method="jaccard", orientation="colwise") # One-dim array
	@test_throws MethodError similarity(["1" "2"; "3" "4"], method="jaccard", orientation="colwise") # non-numeric matrix
	@test_throws AssertionError
	similarity(INCIDENCE_MAT, method="abc", orientation="colwise") # wrong method
	@test_throws MethodError 
	similarity(INCIDENCE_MAT, method="jaccard", orientation="abc") # wrong orientation

	# Check output type:
	@test typeof(similarity(INCIDENCE_MAT, method="jaccard", orientation="colwise")) == Array{Float64, 2}
	@test typeof(similarity(INCIDENCE_MAT, method="jaccard", orientation="rowwise")) == Array{Float64, 2}
	@test typeof(similarity(INCIDENCE_MAT, method="association", orientation="colwise")) == Array{Float64, 2}

	# Check output result:
	# Methods
	@test similarity(INCIDENCE_MAT, method="association", orientation="colwise")[2, 4] == C_MAT[2, 4] / (C_MAT[2, 2] * C_MAT[4, 4])
	@test similarity(INCIDENCE_MAT, method="association", orientation="colwise")[9, 10] == C_MAT[9, 10] / (C_MAT[9, 9] * C_MAT[10, 10])
	@test similarity(INCIDENCE_MAT, method="cosine", orientation="colwise")[2, 4] == C_MAT[2, 4] / sqrt(C_MAT[2, 2] * C_MAT[4, 4])
	@test similarity(INCIDENCE_MAT, method="cosine", orientation="colwise")[9, 10] == C_MAT[9, 10] / sqrt(C_MAT[9, 9] * C_MAT[10, 10])
	@test similarity(INCIDENCE_MAT, method="inclusion", orientation="colwise")[2, 4] == C_MAT[2, 4] / min(C_MAT[2, 2], C_MAT[4, 4])
	@test similarity(INCIDENCE_MAT, method="inclusion", orientation="colwise")[9, 10] == C_MAT[9, 10] / min(C_MAT[9, 9], C_MAT[10, 10])
	@test similarity(INCIDENCE_MAT, method="jaccard", orientation="colwise")[2, 4] == C_MAT[2, 4] / (C_MAT[2, 2] + C_MAT[4, 4] - C_MAT[2, 4])
	@test similarity(INCIDENCE_MAT, method="jaccard", orientation="colwise")[9, 10] == C_MAT[9, 10] / (C_MAT[9, 9] + C_MAT[10, 10] - C_MAT[9, 10])
	@test similarity(INCIDENCE_MAT, method="proximity", orientation="colwise")[2, 4] == C_MAT[2, 4] / max(C_MAT[2, 2], C_MAT[4, 4])
	@test similarity(INCIDENCE_MAT, method="proximity", orientation="colwise")[9, 10] == C_MAT[9, 10] / max(C_MAT[9, 9], C_MAT[10, 10])

	# Orientation
	@test similarity(INCIDENCE_MAT, method="association", orientation="rowise") == similarity(INCIDENCE_MAT', method="association", orientation="colwise")
end

@testset "Density tests" begin

	# Check inputs:
	@test_throws MethodError # get_rca(DataFrame(EXP))
	@test_throws MethodError # get_rca(EXP[1, :])
	@test_throws MethodError # get_rca(["1" "2";
					  # "3" "4"])
	# Check output type:
	# @test typeof(get_rca(EXP, binary=true)) == Array{Int64, 2}
	# @test typeof(get_rca(EXP, binary=false)) == Array{Float64, 2}

	# Check output result:
	# @test get_rca(EXP, binary=false)[4, 3] == (EXP[4, 3] / sum(EXP[4,:])) / (sum(EXP[:,3]) / sum(EXP))
	# @test get_rca(EXP, binary=false)[3, 2] == (EXP[3, 2] / sum(EXP[3,:])) / (sum(EXP[:,2]) / sum(EXP))

	# @test get_rca(EXP, binary=true)[4, 3] == 1 
	# @test get_rca(EXP, binary=true)[3, 2] == 0 
	
	# Check inputs:
	# Check output type:
	# Check results:
	
end
