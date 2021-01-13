using DataFrames

@testset "Basic comparative advantage tests" begin

	# Create toy data ---------------------------------
	# const COUNTRIES = ["CZE", "DEU", "HUN", "IDN"]
	# const PRODUCTS = ["1602", "1604", "1605", "1701", "1702", "1704", "1805", "1806", "1901", "1902"]

	POP = [10474410;
	       81776930;
	       10000023;
	       241834215]
	POP = convert(Array{Float64, 1}, POP) # Some pop-models might have "half people"

	EXP =  [5.66868e7 1.40287e7 1.76446e6 1.24263e8 4.21838e6 1.54845e8 3.0603e6 1.56225e8 3.14846e7 2.60488e7; # CZE
		1.231e9 6.55645e8 7.13669e7 8.70726e8 3.60293e8 8.40892e8 2.75906e8 3.22708e9 1.16899e9 1.82894e8; # DEU
		1.2379e8 1.00424e6 6.27152e6 1.3462e8 7.32589e7 7.9118e7 1.37126e6 7.98984e7 3.50975e7 3.30034e7; # HUN
		5.3835e5 2.63427e8 3.20992e8 1.91463e6 1.57506e7 9.4886e7 1.10084e8 4.17582e7 5.15586e7 1.32186e8] # IDN

	# Test RCA ----------------------------------------
	# Check inputs:
	@test_throws MethodError get_rca(DataFrame(EXP))
	@test_throws MethodError get_rca(EXP[1, :])
	@test_throws MethodError get_rca(["1" "2";
					  "3" "4"])

	# Check output types:
	@test typeof(get_rca(EXP, binary=true)) == Array{Int64, 2}
	@test typeof(get_rca(EXP, binary=false)) == Array{Float64, 2}

	# Check output result:
	@test get_rca(EXP, binary=false)[4, 3] == (EXP[4, 3] / sum(EXP[4,:])) / (sum(EXP[:,3]) / sum(EXP))
	@test get_rca(EXP, binary=false)[3, 2] == (EXP[3, 2] / sum(EXP[3,:])) / (sum(EXP[:,2]) / sum(EXP))

	@test get_rca(EXP, binary=true)[4, 3] == 1 
	@test get_rca(EXP, binary=true)[3, 2] == 0 

	# Test RpcA ---------------------------------------
	# Check inputs:
	@test_throws MethodError get_rpca(EXP, convert(Array{Int64, 1}, POP))
	@test_throws MethodError get_rpca(DataFrame(EXP), POP)
	@test_throws MethodError get_rpca(EXP[1, :], POP)
	@test_throws MethodError get_rpca(["1" "2"
					   "3" "4"], POP)

	# Check output types:
	@test typeof(get_rpca(EXP, POP, binary=true)) == Array{Int64, 2}
	@test typeof(get_rpca(EXP, POP, binary=false)) == Array{Float64, 2}

	# Check output result:
	@test get_rpca(EXP, POP, binary=false)[4, 3] == (EXP[4, 3] / POP[4]) / (sum(EXP[:, 3]) / sum(POP))
	@test get_rpca(EXP, POP, binary=false)[3, 2] == (EXP[3, 2] / POP[3]) / (sum(EXP[:, 2]) / sum(POP))

	@test get_rpca(EXP, POP, binary=true)[4, 3] == 1
	@test get_rpca(EXP, POP, binary=true)[3, 2] == 0
end
