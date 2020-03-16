# COVID Dashboard  
R script `data/data-wrang.R` reads raw data taken from [Here](https://github.com/CSSEGISandData/COVID-19) and outputs to `data/covid-long16Mar.csv`  

`app.jl` is a [Matte.jl](https://github.com/angusmoore/Matte.jl/) app.  

```julia

julia>cd("covid-dash")
(v1.3) pkg> activate .
Activating environment at `~/covid-dash/Project.toml`
julia> using Matte
julia> using Revise
julia> includet("app.jl")
julia> run_app(CovidDash)
julia> run_app(CovidDash)
Web Sockets server running at 127.0.0.1:8001 
Web Server starting at http://127.0.0.1:8000 
Web Server running at http://127.0.0.1:8000 
```
  
![](images/printscreen.png)  

