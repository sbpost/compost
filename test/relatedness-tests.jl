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

	# Define 
	JACCARD_SIM = similarity(INCIDENCE_MAT, orientation="colwise", method = "jaccard")
	# Check inputs:
	@test_throws MethodError density(M = DataFrame(INCIDENCE_MAT), SIM = JACCARD_SIM) # INCIDENCE_MAT should be a matrix
	@test_throws MethodError density(M = INCIDENCE_MAT, SIM = DataFrame(JACCARD_SIM)) # SIM should be a matrix
	@test_throws AssertionError density(M = INCIDENCE_MAT, SIM = vcat(JACCARD_SIM, JACCARD_SIM)) # SIM should be square
	@test_throws AssertionError density(M = INCIDENCE_MAT, SIM = hcat(JACCARD_SIM, JACCARD_SIM[:, 1])) # number of cols in M should be == number of cols and rows in SIM

	# Check output:
	# Check that output is a matrix
	@test typeof(density(M = INCIDENCE_MAT, SIM = JACCARD_SIM)) == Array{Float64, 2}
	# Check that output is symmetrical
	@test size(density(M = INCIDENCE_MAT, SIM = JACCARD_SIM), 1) == size(density(M = INCIDENCE_MAT, SIM = JACCARD_SIM), 2)

	# Check output result:
	@test density(
		      M = INCIDENCE_MAT,
		      SIM = JACCARD_SIM
		      )[2, 5] == sum(INCIDENCE_MAT[2, :] .* JACCARD_SIM[5, :]) / sum(JACCARD_SIM[5,:])

	@test density(
		      M = INCIDENCE_MAT,
		      SIM = JACCARD_SIM
		      )[5, 9] == sum(INCIDENCE_MAT[5, :] .* JACCARD_SIM[9, :]) / sum(JACCARD_SIM[9, :])

end
