module CovidDash

using Matte

const title = "Evolucao do Covid-19:: Dados latinoamericanos"
south_america = "['Brazil','Uruguay', 'Argentina','Chile','Paraguay','Peru','Bolivia','Ecuador','Colombia','Venezuela','Suriname']"

function ui()
    sidebar_layout(
        side_panel(
            h1("Parametros"),
	    br(), 
	    p("<a href='https://github.com/CSSEGISandData/COVID-19'>Source</a>"),
	    p("Casos confirmados desde o primeiro"),
            selector("country", "Country", south_america),
	    selector("all_opt","All","['Yes','No']"), 
            br(),
	    p("Estimativas de coeficientes proprocionais ao ritmo de crescimento estimado em cada pais. <a href='https://github.com/fargolo/covid-dash/'>Coeficientes para curva exponencial estimados</a> com base modelo 'log-linear' hierarquico  com efeitos randomicos por pais")),
        main_panel(
            plots_output("output_plot"),plots_output("output_plot_reg"),
	    datatable_output("coefs_reg")
        )
	)
end

module Server

using StatsPlots , Plots
using DataFrames, CSV , Query

covid_data = CSV.read("data/covid-long17Mar.csv")
regplot_data = CSV.read("data/fit_plot17Mar.csv")
coefs_data = CSV.read("data/fit_data17Mar.csv")


function coefs_reg()
 	colnames = ["N","varPais","Coef","Pais","Coeficiente","Desvio padrao"]
	names!(coefs_data, Symbol.(colnames))
	coefs_data[!,[:Pais,:Coeficiente,Symbol("Desvio padrao")]]
end	

function output_plot_reg()
    @df regplot_data scatter(:diff,:val, group = :Country)
    @df regplot_data plot!(:diff,:exp_pred, group = :Country,seriestype=:line,legend= :outertopleft ,title="Ritmo de crescimento estimado por pais")
end

function output_plot(country,all_opt)
    if all_opt == "Yes"
	south_america_l = ["Brazil","Uruguay", "Argentina","Chile","Paraguay","Peru","Bolivia","Ecuador","Colombia","Venezuela","Suriname"]
	covid_plot = covid_data |> @filter(_.Country ∈ south_america_l) |> DataFrame
        @df covid_plot scatter(:diff, :val, group = :Country, legend = nothing)
        @df covid_plot plot!(:diff, :val, group=:Country,seriestype = :steppre,legend=:outertopleft)
    else 
	if typeof(country) <: AbstractString 
		covid_plot = covid_data |> @filter(_.Country ∈ [country]) |> DataFrame
        	@df covid_plot scatter(:diff, :val, group = :Country)
 		@df covid_plot plot!(:diff, :val, group=:Country,seriestype = :steppre,legend=:outertopleft)
    end
end

end

end
end
