import Statistics
import DataFrames


# TODO: Fitness algorithm
function get_fitness(M::Array{Float64, 2}; iterations::Int, product_codes::Array{String, 1}, country_codes::Array{String, 1})
	
	# Check inputs:
	@assert size(product_codes, 1) == size(M, 2) "`product_codes` needs to be same length as width of `M`."
	@assert size(country_codes, 1) == size(M, 1) "`country_codes` needs to be same length as the height of `M`."

	# Define initial conditions:
	F_current = ones(size(M, 1), 1)
	Q_current = ones(size(M, 2), 1)
	
	# Run algorithm
	for i in 1:iterations
		F = M * Q_current
		Q = 1 ./ (M' * (1 ./ F_current))
		F_current = F / Statistics.mean(F)
		Q_current = Q / Statistics.mean(Q)
	end

	# Return results:
	complexity_tbl = DataFrames.DataFrame(product_code = product_codes, complexity = [Q_current...])
	fitness_tbl = DataFrames.DataFrame(country_code = country_codes, fitness = [F_current...])

	return Dict("Q" => complexity_tbl, "F" => fitness_tbl)
end

# TODO: HH algorithm
