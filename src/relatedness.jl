import LinearAlgebra

# TODO: Orientation: should relatedness be calculated for row or column sets
# TODO: Test if dimensions match the input's: for colwise relatedness, output mat
# should be col x col size.
# TODO: Test result

function similarity(O::Array{Int64, 2}; method::String, orientation="colwise")

	# Prepare inputs --------------------------

	# If the sets that should be related are in rows, flip O
	@assert orientation ∈ ["colwise", "rowwise"] "`orientiation` needs to be either `colwise` or `rowwise`"

	O = orientation == "rowwise" ? O' : O

	# Get co-occurrence matrix + dims
	C = O'O
	n = size(O, 2)

	# No sets are allowed to be completely empty
	@assert minimum(LinearAlgebra.diag(C)) != 0 "Each relevant set must have at least one non-zero value"

	# Define possible similarity methods:
	method_dict = Dict("association" => (Cij, Si, Sj) -> Cij / (Si * Sj),
			   "cosine" => (Cij, Si, Sj) -> Cij / sqrt(Si * Sj), # Cosine index
			   "inclusion" => (Cij, Si, Sj) -> Cij / min(Si, Sj), # Inclusion index
			   "jaccard" => (Cij, Si, Sj) -> Cij / (Si + Sj - Cij), # Jaccard index
			   "proximity" => (Cij, Si, Sj) -> Cij / max(Si, Sj)) # Proximity

	# Make sure that the chosen method is available:
	@assert haskey(method_dict, method) "The chosen method, `$method`, is not specified correctly. Options are: `association` for association strength, `cosine` for cosine similarity, `inclusion` for inclusion index, `jaccard` for jaccard index, and `proximity` for proximity similarity."
	
	# Get similarity matrix: --------------------------
	
	similarity_fun = method_dict[method] # Select method
	SIM = zeros(Float64, n, n) # Initialize collection matrix

	# Calculate similarity:
	for i in 1:n
		for j in 1:n
			SIM[i, j] = similarity_fun(C[i, j], C[i, i], C[j, j])
		end
	end

	# Finish up: ---------------------------------------
	return SIM
end

function density(;M::Array{Int64, 2}, SIM::Array{Float64, 2})

	# Check inputs ------------------------------------
	# Make sure that SIM is symmetrical
	@assert size(SIM, 1) == size(SIM, 2) "`SIM` needs to be a square matrix"
	# Make sure that the number of products in M matches SIM
	@assert size(M, 2) == sizE(SIM, 2) "`M` and `SIM` needs to have the same number of columns"

	# Get local density -------------------------------
	# Set SIM diagonal to 0: a products similarity to itself is not important
	SIM[LinearAlgebra.diagind(SIM)] .= 0

	# Get country density around each product they export. D[c, p] is the 
	# total "internal" similarity between product p to all the other products
	# exported by country c
	DENSITY = M * SIM

	# Get global density ------------------------------
	# Get vector of global similarities
	global_sim = SIM * ones(size(SIM, 2), 1)

	# Normalize each country-density value by global density
	for p in 1:size(global_sim, 1)
		DENSITY[:, p] = DENSITY[:, p] ./ global_sim[p]
	end

	# Finish up ---------------------------------------
	return DENSITY

end


