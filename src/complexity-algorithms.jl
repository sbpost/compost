# TODO: Fitness algorithm
function get_fitness(M::Array{Float64, 2}, iterations::Int, product_codes::Array{String, 1}, country_codes::Array{String, 1})
	
	# Check inputs:
	size(product_codes, 1) == size(M, 2) && return "`product_codes` needs to be same length as width of `M`."
	# [ ] Make sure length of country_code = rows in mat
	size(country_codes, 1) == size(M, 1) && return "`country_codes` needs to be same length as the height of `M`."

	# Define initial conditions:
	F_current = ones(size(M, 1), 1)
	Q_current = ones(size(M, 2), 1)
	
	# Run algorithm
	for i in 1:iterations
		F = M * Q_current
		Q = 1 ./ (M' * (1 ./ F_current))
		F_current = F / mean(F)
		Q_current = Q / mean(Q)
	end

	# Return results:
	complexity_tbl = DataFrame(product_code = product_codes, complexity = [Q_current...])
	fitness_tbl = DataFrame(country_code = country_codes, fitness = [F_current...])

	return [complexity_tbl, fitness_tbl]
end

# TODO: HH algorithm
function get_hh_complexity(M::Array{Float64, 2}, iterations::Int, product_codes::Array{String, 1}, country_codes::Array{String, 1})

	# Check inputs:
	size(product_codes, 1) == size(M, 2) && return "`product_codes` needs to be same length as width of `M`."
	# [ ] Make sure length of country_code = rows in mat
	size(country_codes, 1) == size(M, 1) && return "`country_codes` needs to be same length as the height of `M`."

    # Get Kc, Kp ------------------------------------------
    # Get Kc0 and Kp0
    Kc0 = M * ones(10, 1) # country diversity
    Kp0 = M' * ones(5, 1) # product ubuiquity

    # Get ECI and PCI -------------------------------------
    # Method taken from the economic complexity package on CRAN ('economicomplexity').
    # ECI
    Mcc <- (Mcp / Kc0) %*% (t(Mcp) / Kp0)


    (M .* M) / 

    Kc0

    Kp0

    M' * (1 ./ Kc0)

    M * (1 ./ Kp0)

    Kp0

    Kc0



    # K_vec <- eigen(Mcc)$vectors[, 2] %>% # get eigen-vector ass. with second largest eigen val
     # Re()

    # ECI <- (K_vec - mean(K_vec)) / sd(K_vec) # standardize (Z)
    # ECI <- setNames(ECI, rownames(Mcp))
    
    # PCI 
    # Mpp <- (t(Mcp) / Kp0) %*% (Mcp / Kc0) 
    # Q_vec <- eigen(Mpp)$vectors[, 2] %>% # get eigen-vector ass. with second largest eigen val
       #Re()
     #PCI <- (Q_vec - mean(Q_vec)) / sd(Q_vec) # standardize (Z)
     #PCI <- setNames(PCI, colnames(Mcp)) 
    
    # Return output -----------------------------------------------------
end
