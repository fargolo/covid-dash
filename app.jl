module CovidDash

using Matte

const title = "Covid evolution :: Live dashboard"
south_america = "['Brazil','Uruguay', 'Argentina','Chile','Paraguay','Peru','Bolivia','Ecuador','Colombia','Venezuela','Suriname']"

function ui()
    sidebar_layout(
        side_panel(
            h1("Choose settings"),
	    br(), 
	    p("<a href='https://github.com/CSSEGISandData/COVID-19'>Source</a>"),
	    p("Confirmed cases for each country since first report"),
            selector("country", "Country", south_america),
	    selector("all_opt","All","['Yes','No']"), 
            br()),
        main_panel(
            plots_output("output_plot")
        )
	)
end

module Server

using StatsPlots , Plots
using DataFrames, CSV , Query

covid_data = CSV.read("data/covid-long17Mar.csv")


function output_plot(country,all_opt)
    if all_opt == "Yes"
	south_america_l = ["Brazil","Uruguay", "Argentina","Chile","Paraguay","Peru","Bolivia","Ecuador","Colombia","Venezuela","Suriname"]
	covid_plot = covid_data |> @filter(_.Country ∈ south_america_l) |> DataFrame
        @df covid_plot scatter(:diff, :val, group = :Country)
        @df covid_plot plot!(:diff, :val, group=:Country,seriestype = :steppre,legend=:bottomleft)
    else 
	if typeof(country) <: AbstractString 
		covid_plot = covid_data |> @filter(_.Country ∈ [country]) |> DataFrame
        	@df covid_plot scatter(:diff, :val, group = :Country)
 		@df covid_plot plot!(:diff, :val, group=:Country,seriestype = :steppre,legend=:bottomleft)
    end
end

end

end
end
