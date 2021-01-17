@testset "Fitness Complexity algorithm tests" begin

	# Test fitness algorithm --------------------------
	# Initialize test objects 
	INCIDENCE_MAT = [0 1 0 1 1 0 0 0 0 0;
			 0 1 1 0 0 0 1 0 0 0;
			 1 1 0 1 1 0 0 0 1 1;
			 1 0 0 1 0 1 0 0 1 1;
			 0 0 1 1 0 0 0 1 0 0]

	INCIDENCE_MAT = convert(Array{Float64, 2}, INCIDENCE_MAT)
	ITS = 10

	countries = ["c$x" for x in 1:size(INCIDENCE_MAT, 1)]
	products = ["p$x" for x in 1:size(INCIDENCE_MAT, 2)]

	# Check inputs:
	@test_throws AssertionError get_fitness(INCIDENCE_MAT, iterations=ITS, product_codes = products, country_codes = countries[1:4]) # Wrong length of country codes
	@test_throws AssertionError get_fitness(INCIDENCE_MAT, iterations=ITS, product_codes = products[1:5], country_codes = countries) # Wrong length of product codes
	@test_throws MethodError get_fitness(INCIDENCE_MAT, iterations=ITS, product_codes = [i for i in 1:10], country_codes = countries) # Non-string product codes
	@test_throws MethodError get_fitness(INCIDENCE_MAT, iterations=ITS, product_codes = products, country_codes = [i for i in 1:5]) # Non-string country codes
	@test_throws MethodError get_fitness(DataFrame(INCIDENCE_MAT), iterations=ITS, product_codes = products, country_codes = countries) # non-matrix input
	@test_throws MethodError get_fitness(INCIDENCE_MAT, iterations=4.7, product_codes = products, country_codes = countries) # non-integer iterations
	
	# Check output:
	# Output both Q and F
	@test all([i ∈ keys(get_fitness(INCIDENCE_MAT, iterations = ITS, product_codes = products, country_codes = countries)) for i in ["Q", "F"]])
	# Test presence of product- and country codes
	@test get_fitness(INCIDENCE_MAT, iterations = ITS, product_codes = products, country_codes = countries)["Q"].product_code == products
	@test get_fitness(INCIDENCE_MAT, iterations = ITS, product_codes = products, country_codes = countries)["F"].country_code == countries
	
	# Check results:
	# Create toy results -----------
	# Define initial conditions:
	F_current = ones(size(INCIDENCE_MAT, 1), 1)
	Q_current = ones(size(INCIDENCE_MAT, 2), 1)
	
	# Run algorithm
	for i in 1:ITS
		F = INCIDENCE_MAT * Q_current
		Q = 1 ./ (INCIDENCE_MAT' * (1 ./ F_current))
		F_current = F / (sum(F) / size(F, 1))
		Q_current = Q / (sum(Q) / size(Q, 1))
	end

	complexity_tbl = DataFrames.DataFrame(product_code = products, complexity = [Q_current...])
	fitness_tbl = DataFrames.DataFrame(country_code = countries, fitness = [F_current...])

	@test get_fitness(INCIDENCE_MAT, iterations = ITS, product_codes = products, country_codes = countries)["Q"].complexity == complexity_tbl.complexity
	@test get_fitness(INCIDENCE_MAT, iterations = ITS, product_codes = products, country_codes = countries)["F"].fitness == fitness_tbl.fitness
	@test get_fitness(INCIDENCE_MAT, iterations = ITS, product_codes = products, country_codes = countries)["Q"].product_code == complexity_tbl.product_code
	@test get_fitness(INCIDENCE_MAT, iterations = ITS, product_codes = products, country_codes = countries)["F"].country_code == fitness_tbl.country_code

end
