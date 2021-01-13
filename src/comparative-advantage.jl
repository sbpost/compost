# RCA -----------------------------------------------------
# [ ] Test result against results from groupby approach

function get_rca(M::Array{Float64, 2}; binary::Bool=true) 
	
	# Matrix dimensions
	C = size(M, 1)
	P = size(M, 2)

	# Total country export = row sum
	country_exports = M * ones(P, 1)

	# World product export = col sum
	world_product_exports = M' * ones(C, 1)

	# World total export = mat sum
	total_world_export = sum(M)

	# Calculate:
	RCA = (M ./ country_exports) ./ (world_product_exports ./ total_world_export)'

	# Return:
	if binary == true
		RCA = [i >= 1 ? 1 : 0 for i in RCA]
	end

	return RCA
end

# RpcA ----------------------------------------------------
# TODO: Test

function get_rpca(M::Array{Float64, 2}, POP::Array{Float64, 1}; binary::Bool=true)

	# Check inputs:
	size(M, 1) == size(POP, 1) || return "M and POP must have the same number of rows."

	C = size(M, 1)

	# World export in p
	world_product_exports = M' * ones(C, 1)

	# World pop
	world_pop = sum(POP)

	RPCA = (M ./ POP) ./ (world_product_exports ./ world_pop)'

	if binary == true
		RPCA = [i >= 1 ? 1 : 0 for i in RPCA]
	end

	return RPCA
end
