using CSV , Tables, DataFrames
using Dates , Query , Turing

covid_data = CSV.read("data/covid-long17Mar.csv")

south_america_l = ["Brazil","Uruguay", "Argentina","Chile","Paraguay","Peru","Bolivia","Ecuador","Colombia","Venezuela","Suriname"]
covid_plot = covid_data |> @filter(_.Country ∈ south_america_l) |> DataFrame

@model exponent_mult(time_x,n_cases,country_ids) = begin
	red_ids = collect(1:length(unique(country_ids)))
	σ ~ Truncated(Cauchy(0, 1), 0, Inf)
	μ ~ Normal(0, 1)
	beta ~ Normal(0,1)
	s ~ Uniform(0,50)
 	N_countr = length(red_ids)
	a_countr = Vector{Real}(undef, N_countr)
 	a_countr ~ [Normal(μ, σ)]
	sc_parameter = [a_countr[red_ids[i]] for i = 1:N_countr]
	    	
	for j in 1:length(n_cases)
			rdeff = sc_parameter[country_ids[j]]
			n_cases[j] ~ Normal(beta*exp(rdeff*time_x[j]), s)
		end
	end

num_chains = 4
chain = mapreduce(
    c -> sample(exponent_mult(x_times, case_values, countr_id), NUTS(200, 0.65), 1000, discard_adapt=false),
    chainscat,
    1:num_chains);
describe(chain)
plot(chain)
gelmandiag(chain)

chains_new = chain[201:2500,:,:]
plot(chains_new)
corner(chains_new)
                       
