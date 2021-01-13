@testset "Algorithm tests" begin

	# Test fitness algorithm --------------------------
	# Initialize test objects 
	const MATROWS = 5
	const MATCOLS = 10
	const ITERATIONS = 10
	mat = rand(0:1, MATROWS, MATCOLS)
	products = ["p$x" for x in 1:MATCOLS]
	countries = ["c$x" for x in 1:MATCOLS]

	# [ ] Should fail if inputs are wrong
	#  - size of product codes, size of country codes
	#  - non-matrix inputs
	# [ ] Should give proper returns
	#  - Names of countries, products
	#  - Number of values
	#  - Out format
	# [ ] 

	# Test complexity algorithm -----------------------
	# [ ] Should fail if inputs are wrong
	#  - size of product codes, size of country codes
	#  - non-matrix inputs
	# [ ] Should give proper returns
	#  - Names of countries, products
	#  - Number of values
	#  - Out format
	# [ ] 
end
