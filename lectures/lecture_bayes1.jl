### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ c9cfb450-3e8b-11ed-39c2-cd1b7df7ca01
begin
	using PlutoTeachingTools
	using HypertextLiteral
	using Plots; default(fontfamily="Computer Modern", framestyle=:box) # LaTex-style
	using Distributions, LinearAlgebra
	using StatsPlots
	using LogExpFunctions
	using SpecialFunctions
	# using Statistics
	using StatsBase
	using LaTeXStrings
	using Latexify
	using Random
	# using Dagitty
	using PlutoUI
end

# ╔═╡ f3c62849-620d-47b3-b698-79c925897d54
TableOfContents()

# ╔═╡ 30b4bf3c-82dc-46f7-bd69-5fdeada9ebad
ChooseDisplayMode()

# ╔═╡ 77535564-648a-4e17-83a0-c562cc5318ec
md"""

# Bayesian modelling


**Lecture 2. A first look at Bayesian inference** 


$(Resource("https://www.st-andrews.ac.uk/assets/university/brand/logos/standard-vertical-black.png", :width=>130, :align=>"right"))

Lei Fang (lf28@st-andrews.ac.uk)

*School of Computer Science*

*University of St Andrews, UK*

*March 2023*

"""

# ╔═╡ 2057c799-18b5-4a0f-b2c7-66537a3fbe79
md"""

## In this lecture

* More Bayesian inference 
  * more examples of the workflow


  * Estimate the bias of a coin (Bernoulli likelihood)
    * a classic statistical inference problem
    * compare with the **frequentist** method


* Two Amazon seller problem as an example
  
  







"""

# ╔═╡ 43cedf4c-65c4-4b2b-afb3-21f5827f2af6
md"""
## Coin flipping example


A classic statistical inference problem

> A coin 🪙 is tossed 10 times. 
> * the tossing results are recorded:  $\mathcal D=\{1, 1, 1, 0, 1, 0, 1, 1, 1, 0\}$; 7 out of 10 are heads
> * is the coin **fair**?


"""

# ╔═╡ 351694f5-1b83-426f-a190-c87c69152ef0
md"""

## Forward modelling

The random variables are 

**The positive rate**: ``\theta \in [0,1]``: 

* the unknown positive rate of the seller; also known as the bias for Bernoulli r.v.


**The observed tosses**: ``\mathcal{D} =\{Y_1, \ldots, Y_n\}``


How the random variables shall be linked?
* need to think generatively
* the following seems  right
```math
\theta \Rightarrow \mathcal{D}
```
* common cause pattern
"""

# ╔═╡ 66926dbf-964d-4048-b8ad-459f36236c14
md"""

## The graphical model


Equivalently, we can represent it as a graphical model


In other words, the joint distribution is factored as (conditional independence assumption)

```math
P(\theta, Y_1, Y_2, \ldots, Y_{10}) = \underbrace{P(\theta)}_{\text{prior}} \underbrace{P(Y_1, Y_2, \ldots, Y_{10}|\theta)}_{\text{likelihood}} = P(\theta)\prod_i P(Y_i|\theta)
```


"""

# ╔═╡ 1b4c860a-7245-4793-8acf-a1f01700b499
html"""<center><img src="https://leo.host.cs.st-andrews.ac.uk/figs/oneselleredges.png" width = "900"/></center>
"""

# ╔═╡ 3319498b-db49-4516-b699-b99da093c9cb
md"""


The most common pattern for statistical inference problems
* **i.i.d** case: (independently and identically distributed) 
"""

# ╔═╡ 0f8b4a5b-94b8-4f2b-975d-3579eb9c62b1
md"In plate notation"

# ╔═╡ 1f524d92-e589-48f9-b3cc-bcef0bae4bca
html"""<center><img src="https://leo.host.cs.st-andrews.ac.uk/figs/onesellerplate.png" width = "200"/></center>
"""

# ╔═╡ ce1d28e1-3c77-461e-822a-6e5783bf2744
md"""

## Prior and Likelihood Specification


**The prior**: ``\theta\in [0,1]``

* discretize it to ``[0, 0.1, 0.2, \ldots, 1.0]`` 11 grid values
* and a uniform prior

```math
P(\theta) = \begin{cases} \frac{1}{11} & \theta \in \{0, 0.1, \ldots, 1.0\} \\
0 & \text{otherwise}\end{cases}
```


**The likelihood**: Bernoulli distribution

```math
P(Y_i|\theta) = \begin{cases} 1-\theta & Y_i = 0 \\ \theta & Y_i = 1\end{cases}
```

"""

# ╔═╡ dafe8d1f-6c99-46a4-a2d1-2e34e12ba4a7
md"""


To be more specific, ``\mathcal{D} =\{1,0,0,1,1,1,1,1,1,0\}``


```math
P(\mathcal{D}|\theta) = \theta (1-\theta)(1-\theta) \theta \ldots (1-\theta) = \theta^{7}(1-\theta)^{3}
```

More generally,

```math
P(\mathcal{D}|\theta) = \theta^{N^+}(1-\theta)^{N-N^+}
```
* ``N^+ = \sum_{i=1}^N Y_i``: the total number of heads 
* ``N``: total tosses

"""

# ╔═╡ 1bc6b970-f1fa-48c9-b17e-cef4d01aa47a
md"""

## MLE

The likelihood ``P(\mathcal{D}|\theta)`` is plotted
"""

# ╔═╡ 15571edc-32d7-4ac5-9c53-d49f595f84b1
md"""

> What is the maximum likelihood estimator for ``\theta``?

"""

# ╔═╡ 1d835b12-f1d7-4ce4-a62e-2cfa7a7b3a21
md"""

The MLE can be shown to be  

```math
	\theta_{ML} = \frac{N^+}{N}
```

* what if the observed data is ``\mathcal{D}= \{0, 0\}``
"""

# ╔═╡ f06264f4-f020-48f6-9ff3-cac308518eac
md"""

## Posterior computation
"""

# ╔═╡ 9308405d-36d0-41a1-8c73-e93b8d699320
begin
	# 𝒟 = [1, 0, 0, 1, 1, 1, 1, 1, 1, 0]
	𝒟 = [0, 0]
end

# ╔═╡ 0da00057-6bf1-407d-a15f-af24ee549182
@bind step Slider(0.01:0.005:0.1, default = 0.1)

# ╔═╡ be0fe9aa-32e6-4c18-8bad-2213e05bca1c
md"We can of course change the step size to discretise ``\theta``

Step to discretise ``\theta``: $(step)"

# ╔═╡ f593d1c9-7382-4d5c-9c99-5709123af43d
θs = 0:step:1

# ╔═╡ 8f9d1066-91d5-43af-9834-b3dc2dbc6400
begin
	prior_plt_seller=Plots.plot(θs, 1/length(θs) * ones(length(θs)), ylim= [0,1], seriestype=[:path, :sticks], color= 1, fill=true, alpha=0.3, markershape=:circle, xlabel=L"θ", ylabel=L"P(θ)", label="", title="Prior")
end;

# ╔═╡ 947a0e0f-b620-4e0e-97bd-74749ed87042
function ℓ(θ, 𝒟; logprob=false)
	N = length(𝒟)
	N⁺ = sum(𝒟)
	ℓ(θ, N, N⁺; logprob=logprob)
end

# ╔═╡ 1e267303-160d-43b9-866f-2d7afc2c4c3f
function ℓ(θ, n, n⁺; logprob=false)
	# logL = n⁺ * log(θ) + (n-n⁺) * log(1-θ)
	# use xlogy(x, y) to deal with the boundary case 0*log(0) case gracefully, i.e. θ=0, n⁺ = 0
	logL = xlogy(n⁺, θ) + xlogy(n-n⁺, 1-θ)
	logprob ? logL : exp(logL)
end

# ╔═╡ 5cbd933e-db0e-49fb-b9d0-267dc93efdb7
md"""


## Aside: Maximum likelihood estimator (conti.)

What if we observed ``\mathcal{D}=\{0,0\}`` ? 
* ``N⁺ =0, N=2``



$(let
	gr()
	𝒟 = [0,0]
	like_plt_seller = plot(θs, θ -> ℓ(θ, 𝒟), seriestype=:sticks, color=1, markershape=:circle, xlabel=L"θ", ylabel=L"P(\{0,0\}|θ)", label="", title="Likelihood: "*L"P(\{0,0\}|\theta)")

end)
The MLE is 

$$\hat{\theta}_{\text{ML}} = \frac{0}{2} =0$$

"""

# ╔═╡ 70c00cf9-65ac-44d7-b25c-153614d24240
begin
	
	
	function posterior_robust(𝒟, θs)
		likes = [ℓ(θ, 𝒟; logprob=true) for θ in θs]
		logsum = logsumexp(likes)
		posterior_dis = exp.(likes .- logsum)
		return posterior_dis
	end
	
end

# ╔═╡ 4bae9df7-36a2-4e8a-bdd8-5fdec68cddba
md"""
## Frequentist approach


To draw a comparison with the frequentist method, let's see 

* how **frequentist** would approach the problem
* we will use the *confidence interval* method 
* note that this is not the best frequentist practice
  * for comparison purposes


"""

# ╔═╡ 2338bade-9fb2-4a75-a39c-3e056f2d00d5
md"""

## Frequentist approach

The fundamental difference

> **frequentist** does **NOT** treat the unknown parameter ``\theta`` a random variable **but** an unknown fixed constant

  * therefore, frequentist has neither prior ``P(\theta)`` nor posterior  ``P(\theta|\mathcal{D})``

The only random variables are the data ``\mathcal{D}`` 
  * frequentists only need the likelihood ``P(\mathcal{D}|\theta)``
  * MLEs are usually random variables (therefore, with sampling distribution)

A **confidence interval** can be calculated as 

$$(\hat{\theta} - z_{\alpha/2} \hat{\texttt{se}}, \hat{\theta} + z_{\alpha/2} \hat{\texttt{se}}), \text{where}$$ 

$$\hat{\texttt{se}}= \sqrt{\frac{\hat{\theta}(1-\hat{\theta})}{N}}.$$

* ``\hat{\theta}`` is the MLE, which is a random variable
* the interval is formed based on the converging property of the MLE
"""

# ╔═╡ b3bcf03b-f4f8-4ddb-ab59-fa5f780ed563
md"""

## Confidence interval


For our problem, a 90% frequentist confidence interval is

$$(0.46, 0.94)$$


> But how shall we interpret this interval?

* ``\theta`` is not a random variable, it is clearly not an uncertainty statement  about ``\theta``
* but the interval itself is random


!!! danger ""
	
	
	A ``\alpha=10\%`` **confidence interval** interpretation: 

	*Repeat the following two steps, say 10,000 times:*

	1. *toss the coin another 10 times*
	2. *calculate another confidence interval*: ``(\hat{\theta} - 1.645 \hat{\texttt{se}}, \hat{\theta} + 1.645 \hat{\texttt{se}})`` *as above*

	Over the 10,000 realised random intervals, approximately 90% of them trap the true unknown parameter.

"""

# ╔═╡ ff01e390-a72d-41b0-9a7c-1d63060491f9
md"""

The animation illustrates the idea 
* conditional on the hypothesis that the coin is fair, *i.e.* ``\theta =0.5`` (it works for any ``\theta\in [0,1]``)
* the above two steps were repeated 100 times, *i.e.* tossing the coin ten times and then forming a confidence interval
* the red ones are the 10% CIs that **do not** trap the true bias. 
"""

# ╔═╡ c1edf5ff-f25f-4a71-95fb-53515aae9d97
md"""

## Frequentist sampling theory method

If you think the Frequentist's confidence interval is confusing

* I agree with you. 


But the frequentist method is suitable for controlled experiment settings 

* we are truly interested in the long term frequency pattern under repeated experiments

But Bayesian inference give you a more **direct answer** to the inference question

> "*In light of the observed data, what ``\theta`` is more credible, i.e. what is ``p(\theta|\mathcal D)``?*''

And Bayesian inference is procedurally simple and uniform

* forward modelling + inference computation
* frequentist methods need different tests for different purposes
"""

# ╔═╡ 6131ad55-eee7-44ec-b965-ce17ef3f8f84
begin
	cint_normal(n, k; θ=k/n, z=1.96) = max(k/n - z * sqrt(θ*(1-θ)/n),0), min(k/n + z * sqrt(θ*(1-θ)/n),1.0)
	within_int(intv, θ=0.5) = θ<intv[2] && θ>intv[1]
end;

# ╔═╡ a152a7bd-062d-4fd9-be38-c217fdaca20f
begin
	Random.seed!(100)
	θ_null = 0.5
	n_exp = 100
	trials = 10
	outcomes = rand(Binomial(trials, θ_null), n_exp)
	intvs = cint_normal.(trials, outcomes; z= 1.645)
	true_intvs = within_int.(intvs)
	ϵ⁻ = outcomes/trials .- [intvs[i][1] for i in 1:length(intvs)]
	ϵ⁺ = [intvs[i][2] for i in 1:length(intvs)] .- outcomes/trials
end;

# ╔═╡ 5462f241-e284-45b8-8e61-3c0317f6b08b
let
	p = hline([0.5], label=L"\mathrm{true}\;θ=0.5", color= 3, linestyle=:dash, linewidth=2,  xlabel="Experiments", ylim =[0,1])
	anim = @animate for i in 1:n_exp
		k_ = outcomes[i]
		# intv = cint_normal(trials, k_; z= 1.645)
		# intv = intvs[i]
		in_out = true_intvs[i]
		col = in_out ? 1 : 2
		θ̂ = k_/trials
		Plots.scatter!([i], [θ̂],  label="", yerror= ([ϵ⁻[i]], [ϵ⁺[i]]), markerstrokecolor=col, color=col)
	end

	gif(anim, fps=3)
end

# ╔═╡ 6d136ab7-c7ea-43a7-a16d-0af53b123b59
begin
	first_20_intvs = true_intvs[1:100]
	Plots.scatter(findall(first_20_intvs), outcomes[findall(first_20_intvs)]/trials, ylim= [0,1], yerror =(ϵ⁻[findall(first_20_intvs)], ϵ⁺[findall(first_20_intvs)]), label="true", markerstrokecolor=:auto, legend=:outerbottom,legendtitle = "true θ within CI ?")
	Plots.scatter!(findall(.!first_20_intvs), outcomes[findall(.!first_20_intvs)]/trials, ylim= [0,1], yerror =(ϵ⁻[findall(.!first_20_intvs)],ϵ⁺[findall(.!first_20_intvs)]), label="false", markerstrokecolor=:auto)
	hline!([0.5], label=L"\mathrm{true}\;θ=0.5", linewidth =2, linestyle=:dash, xlabel="Experiments")
end

# ╔═╡ a2642e09-3202-4c73-914a-bdd6c0b374c2
md"""

## Amazon seller problem



!!! note "Amazon reseller"
	Two resellers on Amazon with different review counts 

	| Seller | A | B |
	|:---:|---|---|
	|#Positive ratings  |8  |799 |
	|#Total ratings  |10|1000|
	Which seller provides **better** service?


* we will consider one seller first 
* and then extend it to two seller

## One seller problem
"""

# ╔═╡ 89f0aa81-1da3-41a0-8d72-72637d8052aa
md"""

It is the same to estimating a coin's bias actually

> Seller *A* is "tossed" 10 times. 
> * 8 out of the 10 experiments are positive. 
> * what is the unknown positive rating ?


The difference: the observations are ``N^+`` directly
* note that ``N⁺`` is defined as the total count of successes of ``N`` tosses:

```math
N⁺\triangleq \sum_i Y_i 
```
* the likelihood is binomial distributed
```math
P(N⁺ |\theta, N) = \text{Binom}(N⁺; N, \theta) = \binom{N}{N⁺} \theta^{N⁺} (1-\theta)^{N-N⁺}
```  
  * ``N=10`` is a hyperparameter, omitted here 

"""

# ╔═╡ 4f6232be-dbd1-4e1a-a28c-5fc60964bb9f
html"""<center><img src="https://leo.host.cs.st-andrews.ac.uk/figs/bayes/oneseller.png" width = "150"/></center>
"""

# ╔═╡ d76d0594-5a53-4641-818e-496ce3a52c6b
function ℓ_binom(N⁺, θ, N; logprob=false)
	# log(binomial(N, N⁺) * (1-θ)^(N-N⁺) * θ^N⁺)
	logL = logabsbinomial(N, N⁺)[1] + xlogy(N-N⁺, 1-θ)  + xlogy(N⁺, θ)
	logprob ? logL : exp(logL)
end

# ╔═╡ 19892f66-98e1-405e-abae-ffda46a546b1
begin
	Nᴬ = 10
	N⁺ = 7
	like_plt_seller = Plots.plot(θs, θ -> ℓ_binom(N⁺, θ, Nᴬ), seriestype=:sticks, color=1, markershape=:circle, xlabel=L"θ", ylabel=L"p(𝒟|θ)", label="", title="Likelihood: "*L"P(\mathcal{D}|\theta)")
end

# ╔═╡ 31c064a3-e074-409a-9431-48a573a83884
let
	gr()
	l = @layout [a b; c]
	N⁺ = sum(𝒟)
	Nᴬ = length(𝒟)
	likes = ℓ_binom.(N⁺, θs, Nᴬ; logprob=false)
	posterior_dis = likes/ sum(likes)
	post_plt = plot(θs, posterior_dis, seriestype=:sticks, markershape=:circle, label="", color=2, title="Posterior", xlabel=L"θ", ylabel=L"p(θ|𝒟)", legend=:outerright, size=(600,500))
	plot!(post_plt, θs, posterior_dis, color=2, label ="Posterior", fill=true, alpha=0.5)
	plot!(post_plt, θs, 1/length(θs) * ones(length(θs)), seriestype=:sticks, markershape=:circle, color =1, alpha=0.2, label="")
	plot!(post_plt, θs, 1/length(θs) * ones(length(θs)), color=1, label ="Prior", fill=true, alpha=0.2)
	plot(prior_plt_seller, like_plt_seller, post_plt, layout=l)
end

# ╔═╡ fde1b917-9d81-4a29-b553-caad3c736682
md"""

## Two resellers

* The two unknowns: ``\theta_A,\theta_B``. 
* The likelihood are the counts of "heads" (or positive reviews): ``\mathcal{D} = \{N_{A}^+, N_{B}^+\}``.




"""

# ╔═╡ b4709e13-24ad-4c7e-bd9f-e7113b5089f5
html"""<center><img src="https://leo.host.cs.st-andrews.ac.uk/figs/bayes/twoseller.png" width = "350"/></center>
"""

# ╔═╡ 278bb5cb-6734-499c-b954-0590f559af1f
md"""

We have assumed 

* the two sellers' biases are independent 
* the reviews counts are also independent 
"""

# ╔═╡ 92e2e50b-bbce-4b4d-aad4-02e4f374b286
begin
	dis_size = 101
	θ₁s, θ₂s = range(0, 1 , dis_size), range(0, 1 , dis_size)
end

# ╔═╡ 316db89e-0b73-4993-a778-5d3ff890e807
md"""
## Two reseller: likelihood ``p(\mathcal{D}|\theta_A, \theta_B)``

The two resellers' performance are assumed independent

```math
\begin{align}
p(\mathcal{D}|\theta_A, \theta_B) &= p(N_A^+|\theta_A, N_A=10) p(N_B^+|\theta_B, N_B=100)\\

&=\binom{N_A}{N_A^+}\theta_A^{N_A^+}(1-\theta_A)^{N_A- N_A^+}\times \binom{N_B}{N_B^+}\theta_B^{N_B^+}(1-\theta_B)^{N_B- N_B^+}
\end{align}
```

* two independent Binomial likelihoods

"""

# ╔═╡ 2c6b9d29-1ab8-4b59-a867-1aecf27dc679
md"""

## Two reseller: posterior

Apply Bayes' rule to find the posterior


$$\begin{align}
p(\theta_A, \theta_B|\mathcal D) &\propto p(\theta_A, \theta_B)\cdot p(\mathcal D|\theta_A, \theta_B)\\
&\propto \theta_A^{N_A^+}(1-\theta_A)^{N_A- N_A^+}\times \theta_B^{N_B^+}(1-\theta_B)^{N_B- N_B^+}
\end{align}$$

Note that
* ``1/101^2`` is a constant *w.r.t.* ``\theta_A, \theta_B``
* ``\binom{N_B}{N_B^+}, \binom{N_A}{N_A^+}`` are also constants *w.r.t.* ``\theta_A,\theta_B``

And the normalising constant $p(\mathcal D)$ is

$$p(\mathcal D) = \sum_{\theta_A\in \{0.0, \ldots,1.0\}}\sum_{\theta_B\in \{0.0,\ldots, 1.0\}} \theta_A^{N_A^+}(1-\theta_A)^{N_A- N_A^+}\times \theta_B^{N_B^+}(1-\theta_B)^{N_B- N_B^+}$$ 

* the updated posterior is plotted below


"""

# ╔═╡ cb09680f-ae53-45b1-aa61-e73f81a4bcce
md"""

## Posterior
"""

# ╔═╡ 022c5b56-e683-4f66-aba9-8b2e89f11e24
md"""
* the posterior now centres around (0.8, 0.79); 
* however, the ``\theta_A``'s marginal distribution is wider than the other, which makes perfect sense. 

"""

# ╔═╡ 56893f7f-e59c-434d-b8cf-2dd553111707
begin
	N₁, N₂ = 10, 1000
	Nₕ₁, Nₕ₂ = 8, 799
end;

# ╔═╡ 5a09f7ba-20df-4b28-a457-7e790efee888
begin
	function ℓ_two_coins(θ₁, θ₂; N₁=10, N₂=100, Nh₁=7, Nh₂=69, logLik=false)
		logℓ = ℓ_binom(Nh₁, θ₁, N₁;  logprob=true) + ℓ_binom(Nh₂, θ₂, N₂; logprob=true)
		logLik ? logℓ : exp(logℓ)
	end

	ℓ_twos = [ℓ_two_coins(θᵢ, θⱼ; N₁=N₁, N₂=N₂, Nh₁=Nₕ₁, Nh₂=Nₕ₂, logLik=true) for θᵢ in θ₁s, θⱼ in θ₂s]
	p𝒟 = exp(logsumexp(ℓ_twos))
	ps = exp.(ℓ_twos .- logsumexp(ℓ_twos))
end;

# ╔═╡ 32c06874-204d-4319-9879-8af6039d5cae
md"""


## Two resellers: Prior ``P(\theta_A, \theta_B)``


A uniform prior 

$$p(\theta_A, \theta_B) = \begin{cases} 1/101^2, & \theta_A,\theta_B \in \{0, 0.01, \ldots, 1.0\}^2 \\
0, & \text{otherwise}; \end{cases}$$

The prior distribution is shown below:

$(begin
gr()
p1 = Plots.plot(θ₁s, θ₂s,  (x,y) -> 1/(length(θ₁s)^2), st=:surface, xlabel=L"\theta_A", ylabel=L"\theta_B", ratio=1, xlim=[0,1], ylim=[0,1], zlim =[-0.0005, maximum(ps)], colorbar=false, c=:plasma, alpha =0.5, zlabel="density", title="Prior")
end)
"""

# ╔═╡ 5649bcda-2ab5-4bb7-b0dc-c132c5fb0a0d

begin
	plotly()
	p2 = Plots.plot(θ₁s, θ₂s,  ps', st=:surface, xlabel= "θA", ylabel="θB", ratio=1, xlim=[0,1], ylim=[0,1], zlim =[-0.0005, maximum(ps)], colorbar=false, c=:jet, zlabel="", alpha=0.9, title="Posterior")
end


# ╔═╡ 9c49b056-7329-49af-838b-3e8b28826157
md"""
The heatmap of the posterior density is also plotted for reference.

$(begin

Plots.plot(θ₁s, θ₂s,  ps', st=:heatmap, xlabel=L"\theta_A", ylabel=L"\theta_B", ratio=1, xlim=[0,1], ylim=[0,1], zlim =[-0.003, maximum(ps)], colorbar=false, c=:plasma, zlabel="density", alpha=0.7, title="Posterior's density heapmap")

end)
"""

# ╔═╡ 0cd24282-74a4-4261-aa33-019d3afac248
md"""

## Lastly: answer the question

The question boils down to a posterior probability:

```math
P(\theta_A > \theta_B|\mathcal{D}).
```
* *In light of the data, how likely coin ``A`` has a higher bias than coin ``B``?*, 
* geometrically, calculate the probability below the shaded area


"""

# ╔═╡ 1cf90ba3-2f9a-4d58-bdd3-7b57e43fe307
begin
	gr()
	post_p_amazon =Plots.plot(θ₁s, θ₂s,  ps', st=:contour, xlabel=L"\theta_A", ylabel=L"\theta_B", ratio=1, xlim=[0,1], ylim=[0,1], colorbar=false, c=:thermal, framestyle=:origin)
	plot!((x) -> x, lw=1, lc=:gray, label="")
	equalline = Shape([(0., 0.0), (1,1), (1, 0)])
	plot!(equalline, fillcolor = plot_color(:gray, 0.2), label=L"\theta_A>\theta_B", legend=:bottomright)
end

# ╔═╡ 5a58f305-4af0-40ae-830a-a318576bf85d
post_AmoreB = let
	post_AmoreB = 0
	for (i, θᵢ) in enumerate(θ₁s)
		for (j, θⱼ) in enumerate(θ₂s)
			if θᵢ > 1.0 * θⱼ
				post_AmoreB += ps[i,j]
			end
		end
	end
	post_AmoreB
end;

# ╔═╡ fdfa9423-e09e-42b6-bce3-ebbc681f3c93
md"For our problem,"

# ╔═╡ bca20d87-e453-4106-a5cf-bd99d25021ab
L"p(\theta_A > \theta_B|\mathcal{D}) \approx %$(round(post_AmoreB, digits=2))"

# ╔═╡ da59ebaa-e366-4753-8329-27119be19d9a
md"""
* it is only about 37% chance that seller A is truly better than seller B
* 63% chance seller B is better!
"""

# ╔═╡ 3caf8d96-7cdd-45f4-a54e-08b7a1bc2251
md"""

## Question

> What's the chance that seller A's positive rate is twice better than seller B?

"""

# ╔═╡ 12f92e46-9581-4c04-be11-3f3f9b316f26
md"""

!!! hint "Answer"

	You can even calculate 

	```math
	p(\theta_A > 2\cdot \theta_B|\mathcal{D}) = \sum_{\theta_A >2 \theta_B:\;\theta_A,\theta_B\in \{0.0, \ldots 1.0\}^2} p(\theta_A, \theta_B|\mathcal{D})
	```
	
	* just a different shaded area!


"""

# ╔═╡ a30ed481-a09a-4d9c-a960-2ca3b4898e30
@bind k Slider(0.1:0.05:3; default =1, show_value=true)

# ╔═╡ d6550d70-a1c1-48fd-b99d-c041b40efad2
post_AmoreKB = let
	post_AmoreKB = 0
	for (i, θᵢ) in enumerate(θ₁s)
		for (j, θⱼ) in enumerate(θ₂s)
			if θᵢ > k*θⱼ
				post_AmoreKB += ps[i,j]
			end
		end
	end
	post_AmoreKB
end;

# ╔═╡ d7a4bd52-8cf1-4495-bc14-2fe19fc9a037
let
	gr()
	post_p_amazon =Plots.plot(θ₁s, θ₂s,  ps', st=:contour, xlabel=L"\theta_A", ylabel=L"\theta_B", ratio=1, xlim=[0,1], ylim=[0,1], colorbar=false, c=:thermal, framestyle=:origin)
	plot!((x) -> x, lw=1, lc=:gray, label="")
	equalline = Shape([(0., 0.0), (1,1), (1, 0)])
	plot!(equalline, fillcolor = plot_color(:gray, 0.2), label=L"\theta_A>\theta_B", legend=:bottomright)
	kline = Shape([(0., 0.0), (1,1/k), (1, 0)])
	plot!(post_p_amazon, kline, fillcolor = plot_color(:gray, 0.5), label=L"\theta_A>%$(k)\cdot \theta_B", legend=:bottomright, title =L"P(\theta_A > %$(k) \theta_B|\mathcal{D})\approx %$(round(post_AmoreKB, digits=2))")
end

# ╔═╡ 98672fd3-f85c-40e2-8f71-3a46b8632bf6
# only works for uni-modal
function find_hpdi(ps, α = 0.95)
	cum_p, idx = findmax(ps)
	l = idx - 1
	u = idx + 1
	while cum_p <= α
		if l >= 1 
			if u > length(ps) || ps[l] > ps[u]
				cum_p += ps[l]
				l = max(l - 1, 0) 
				continue
			end
		end
		
		if u <= length(ps) 
			if l == 0 || ps[l] < ps[u]
				cum_p += ps[u]
				u = min(u + 1, length(ps))
			end
		end
	end
	return l+1, u-1, cum_p
end;

# ╔═╡ e4af93c4-19f9-4d94-8ed2-729852ca9432
begin
	θs_refined = 0:0.01:1.0
	likes = ℓ_binom.(N⁺, θs_refined, Nᴬ; logprob=false)
	posterior_dis_refined = likes/ sum(likes)
	post_plt3 = Plots.plot(θs_refined, posterior_dis_refined, seriestype=:sticks, markershape=:circle, markersize=2, label="", title=L"\mathrm{Posterior}\, \, p(\theta|\mathcal{D})", xlabel=L"θ", ylabel=L"p(θ|𝒟)")
	l2, u2, _ = find_hpdi(posterior_dis_refined, 0.9)
	Plots.plot!(post_plt3, θs_refined[l2:u2], posterior_dis_refined[l2:u2], seriestype=:sticks, markershape=:circle, markersize=2, label="", legend=:topleft)
	Plots.plot!(post_plt3, θs_refined[l2:u2], posterior_dis_refined[l2:u2], seriestype=:path, fill=true, alpha=0.3, color=2, label="90% credible interval", legend=:topleft)
	Plots.annotate!((0.7, maximum(posterior_dis_refined)/2, ("90 % HDI", 15, :red, :center, "courier")))

end

# ╔═╡ 80cb7bab-4eb0-4ec1-a067-9d661f2c4da3
md"""
## Report the posterior

The posterior distribution ``P(\theta|\mathcal{D})`` provides what we need to know

* the mode of the posterior is around 0.7



To summarise the uncertainty, we can report **highest probability density interval (HPDI)** 

* Bayesian **credible interval** (c.f. confidence interval)

* an interval that the encloses probability *e.g.* 90% of the posterior

$$p(l \leq \theta \leq u|\mathcal D) = 90 \%.$$

* however, the wide tail suggests it is not very certain; we only have observed 10 tosses after all
  * the 90% region for ``\theta`` is ($(θs_refined[l2]), $(θs_refined[u2]))
"""

# ╔═╡ f7456b7a-3d05-468a-a7ee-50a83affba72
md"""

## Frequentist method ?


One may choose a test say χ²-test with testing hypothesis

> ``\mathcal{H}_0:`` A and B have the same positive review rate
>
>  and 
>
> ``\mathcal{H}_1:``  A and B have different positive review rate

* one then proceeds to compute the required statistic (with no obvious reasons why)

* and the result might be reported like

> the two sellers offer **significantly different** levels of service (``p``), say 0.05


How to interpret the statement?


It **does not** tell you

!!! danger ""
	there is a ``(1-p)`` chance that the sellers differ in positive ratings


but rather 


!!! correct ""
	if we did this experiment many times, and the two resellers had equal ratings, then p of the time you would find a value of χ2 more extreme than the one that calculated above.


And the response or interpretation does not really directly answer the original question we are interested in, *i.e.*

!!! warning ""
	Is A better B?

"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Distributions = "31c24e10-a181-5473-b8eb-7969acd0382f"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
Latexify = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
LogExpFunctions = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
StatsPlots = "f3b207a7-027a-5e70-b257-86293d7955fd"

[compat]
Distributions = "~0.25.103"
HypertextLiteral = "~0.9.5"
LaTeXStrings = "~1.3.1"
Latexify = "~0.16.1"
LogExpFunctions = "~0.3.26"
Plots = "~1.39.0"
PlutoTeachingTools = "~0.2.13"
PlutoUI = "~0.7.54"
SpecialFunctions = "~2.3.1"
StatsBase = "~0.34.2"
StatsPlots = "~0.15.6"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.4"
manifest_format = "2.0"
project_hash = "cd3ddb015e060cf929f9898c16074c5cb5dc9ac4"

[[deps.AbstractFFTs]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "d92ad398961a3ed262d8bf04a1a2b8340f915fef"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.5.0"
weakdeps = ["ChainRulesCore", "Test"]

    [deps.AbstractFFTs.extensions]
    AbstractFFTsChainRulesCoreExt = "ChainRulesCore"
    AbstractFFTsTestExt = "Test"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "793501dcd3fa7ce8d375a2c878dca2296232686e"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.2"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "02f731463748db57cc2ebfbd9fbc9ce8280d3433"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.7.1"
weakdeps = ["StaticArrays"]

    [deps.Adapt.extensions]
    AdaptStaticArraysExt = "StaticArrays"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Arpack]]
deps = ["Arpack_jll", "Libdl", "LinearAlgebra", "Logging"]
git-tree-sha1 = "9b9b347613394885fd1c8c7729bfc60528faa436"
uuid = "7d9fca2a-8960-54d3-9f78-7d1dccf2cb97"
version = "0.5.4"

[[deps.Arpack_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "OpenBLAS_jll", "Pkg"]
git-tree-sha1 = "5ba6c757e8feccf03a1554dfaf3e26b3cfc7fd5e"
uuid = "68821587-b530-5797-8361-c406ea357684"
version = "3.5.1+1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "66771c8d21c8ff5e3a93379480a2307ac36863f7"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.0.1"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitFlags]]
git-tree-sha1 = "2dc09997850d68179b69dafb58ae806167a32b1b"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.8"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra"]
git-tree-sha1 = "e0af648f0692ec1691b5d094b8724ba1346281cf"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.18.0"
weakdeps = ["SparseArrays"]

    [deps.ChainRulesCore.extensions]
    ChainRulesCoreSparseArraysExt = "SparseArrays"

[[deps.Clustering]]
deps = ["Distances", "LinearAlgebra", "NearestNeighbors", "Printf", "Random", "SparseArrays", "Statistics", "StatsBase"]
git-tree-sha1 = "05f9816a77231b07e634ab8715ba50e5249d6f76"
uuid = "aaaa29a8-35af-508c-8bc3-b662a17a0fe5"
version = "0.15.5"

[[deps.CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "c0216e792f518b39b22212127d4a84dc31e4e386"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.3.5"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "cd67fc487743b2f0fd4380d4cbd3a24660d0eec8"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.3"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "67c1f244b991cad9b0aa4b7540fb758c2488b129"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.24.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"
weakdeps = ["SpecialFunctions"]

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.Compat]]
deps = ["UUIDs"]
git-tree-sha1 = "8a62af3e248a8c4bad6b32cbbe663ae02275e32c"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.10.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+0"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "8cfa272e8bdedfa88b6aefbbca7c19f1befac519"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.3.0"

[[deps.Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[deps.DataAPI]]
git-tree-sha1 = "8da84edb865b0b5b0100c0666a9bc9a0b71c553c"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.15.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3dbd312d370723b6bb43ba9d02fc36abade4518d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.15"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.Distances]]
deps = ["LinearAlgebra", "Statistics", "StatsAPI"]
git-tree-sha1 = "5225c965635d8c21168e32a12954675e7bea1151"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.10"
weakdeps = ["ChainRulesCore", "SparseArrays"]

    [deps.Distances.extensions]
    DistancesChainRulesCoreExt = "ChainRulesCore"
    DistancesSparseArraysExt = "SparseArrays"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Distributions]]
deps = ["FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SpecialFunctions", "Statistics", "StatsAPI", "StatsBase", "StatsFuns"]
git-tree-sha1 = "a6c00f894f24460379cb7136633cef54ac9f6f4a"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.103"

    [deps.Distributions.extensions]
    DistributionsChainRulesCoreExt = "ChainRulesCore"
    DistributionsDensityInterfaceExt = "DensityInterface"
    DistributionsTestExt = "Test"

    [deps.Distributions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    DensityInterface = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
    Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.DualNumbers]]
deps = ["Calculus", "NaNMath", "SpecialFunctions"]
git-tree-sha1 = "5837a837389fccf076445fce071c8ddaea35a566"
uuid = "fa6b7ba4-c1ee-5f82-b5fc-ecf0adba8f74"
version = "0.6.8"

[[deps.EpollShim_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8e9441ee83492030ace98f9789a654a6d0b1f643"
uuid = "2702e6a9-849d-5ed8-8c21-79e8b8f9ee43"
version = "0.0.20230411+0"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "e90caa41f5a86296e014e148ee061bd6c3edec96"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.9"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "4558ab818dcceaab612d1bb8c19cee87eda2b83c"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.5.0+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "466d45dc38e15794ec7d5d63ec03d776a9aff36e"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.4+1"

[[deps.FFTW]]
deps = ["AbstractFFTs", "FFTW_jll", "LinearAlgebra", "MKL_jll", "Preferences", "Reexport"]
git-tree-sha1 = "b4fbdd20c889804969571cc589900803edda16b7"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.7.1"

[[deps.FFTW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c6033cc3892d0ef5bb9cd29b7f2f0331ea5184ea"
uuid = "f5851436-0d7a-5f13-b9de-f02708fd171a"
version = "3.3.10+0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random"]
git-tree-sha1 = "28e4e9c4b7b162398ec8004bdabe9a90c78c122d"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.8.0"
weakdeps = ["PDMats", "SparseArrays", "Statistics"]

    [deps.FillArrays.extensions]
    FillArraysPDMatsExt = "PDMats"
    FillArraysSparseArraysExt = "SparseArrays"
    FillArraysStatisticsExt = "Statistics"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "d8db6a5a2fe1381c1ea4ef2cab7c69c2de7f9ea0"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.1+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "d972031d28c8c8d9d7b41a536ad7bb0c2579caca"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.8+0"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Preferences", "Printf", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "UUIDs", "p7zip_jll"]
git-tree-sha1 = "27442171f28c952804dede8ff72828a96f2bfc1f"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.72.10"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "FreeType2_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt6Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "025d171a2847f616becc0f84c8dc62fe18f0f6dd"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.72.10+0"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "e94c92c7bf4819685eb80186d51c43e71d4afa17"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.76.5+0"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "5eab648309e2e060198b45820af1a37182de3cce"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.0"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.HypergeometricFunctions]]
deps = ["DualNumbers", "LinearAlgebra", "OpenLibm_jll", "SpecialFunctions"]
git-tree-sha1 = "f218fe3736ddf977e0e772bc9a586b2383da2685"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.23"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

[[deps.IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ad37c091f7d7daf900963171600d7c1c5c3ede32"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2023.2.0+0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.Interpolations]]
deps = ["Adapt", "AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "Requires", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "721ec2cf720536ad005cb38f50dbba7b02419a15"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.14.7"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "a53ebe394b71470c7f97c2e7e170d51df21b17af"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.7"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7e5d6779a1e09a36db2a7b6cff50942a0a7d0fca"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.5.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6f2675ef130a300a112286de91973805fcc5ffbc"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.91+0"

[[deps.JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "0592b1810613d1c95eeebcd22dc11fba186c2a57"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.26"

[[deps.KernelDensity]]
deps = ["Distributions", "DocStringExtensions", "FFTW", "Interpolations", "StatsBase"]
git-tree-sha1 = "90442c50e202a5cdf21a7899c66b240fdef14035"
uuid = "5ab0869b-81aa-558d-bb23-cbf5423bbe9b"
version = "0.6.7"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f689897ccbe049adb19a065c495e75f372ecd42b"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "15.0.4+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "50901ebc375ed41dbf8058da26f9de442febbbec"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.1"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "f428ae552340899a935973270b8d98e5a31c49fe"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.1"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SymEngineExt = "SymEngine"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "6f73d1dd803986947b2c750138528a999a6c7733"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.6.0+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "f9557a255370125b405568f9767d6d195822a175"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.17.0+0"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "2da088d113af58221c52828a80378e16be7d037a"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.5.1+1"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "7d6dd4e9212aebaeed356de34ccf262a3cd415aa"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.26"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "c1dd6d7978c12545b4179fb6153b9250c96b0075"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.3"

[[deps.LoweredCodeUtils]]
deps = ["JuliaInterpreter"]
git-tree-sha1 = "60168780555f3e663c536500aa790b6368adc02a"
uuid = "6f1432cf-f94c-5a45-995e-cdbf5db27b0b"
version = "2.3.0"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "Pkg"]
git-tree-sha1 = "eb006abbd7041c28e0d16260e50a24f8f9104913"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2023.2.0+0"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "9ee1618cbf5240e6d4e0371d6f24065083f60c48"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.11"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "NetworkOptions", "Random", "Sockets"]
git-tree-sha1 = "c067a280ddc25f196b5e7df3877c6b226d390aaf"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.9"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.MultivariateStats]]
deps = ["Arpack", "LinearAlgebra", "SparseArrays", "Statistics", "StatsAPI", "StatsBase"]
git-tree-sha1 = "68bf5103e002c44adfd71fea6bd770b3f0586843"
uuid = "6f286f6a-111f-5878-ab1e-185364afe411"
version = "0.10.2"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NearestNeighbors]]
deps = ["Distances", "StaticArrays"]
git-tree-sha1 = "2c3726ceb3388917602169bed973dbc97f1b51a8"
uuid = "b8a86587-4115-5ab1-83bc-aa920d37bbce"
version = "0.4.13"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Observables]]
git-tree-sha1 = "7438a59546cf62428fc9d1bc94729146d37a7225"
uuid = "510215fc-4207-5dde-b226-833fc4488ee2"
version = "0.5.5"

[[deps.OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "2ac17d29c523ce1cd38e27785a7d23024853a4bb"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.12.10"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "51901a49222b09e3743c65b8847687ae5fc78eb2"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.1"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "cc6e1927ac521b659af340e0ca45828a3ffc748f"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.0.12+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+0"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "4e5be6bb265d33669f98eb55d2a57addd1eeb72c"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.30"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "a935806434c9d4c506ba941871b327b96d41f2bf"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.0"

[[deps.Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "64779bc4c9784fee475689a1752ef4d5747c5e87"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.42.2+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.2"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "1f03a2d339f42dca4a4da149c7e15e9b896ad899"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.1.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "f92e1315dadf8c46561fb9396e525f7200cdc227"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.5"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "PrecompileTools", "Preferences", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "UnitfulLatexify", "Unzip"]
git-tree-sha1 = "ccee59c6e48e6f2edf8a5b64dc817b6729f99eb5"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.39.0"

    [deps.Plots.extensions]
    FileIOExt = "FileIO"
    GeometryBasicsExt = "GeometryBasics"
    IJuliaExt = "IJulia"
    ImageInTerminalExt = "ImageInTerminal"
    UnitfulExt = "Unitful"

    [deps.Plots.weakdeps]
    FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
    GeometryBasics = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
    IJulia = "7073ff75-c697-5162-941a-fcdaad2a7d2a"
    ImageInTerminal = "d8c32880-2388-543b-8c61-d9f865259254"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.PlutoHooks]]
deps = ["InteractiveUtils", "Markdown", "UUIDs"]
git-tree-sha1 = "072cdf20c9b0507fdd977d7d246d90030609674b"
uuid = "0ff47ea0-7a50-410d-8455-4348d5de0774"
version = "0.0.5"

[[deps.PlutoLinks]]
deps = ["FileWatching", "InteractiveUtils", "Markdown", "PlutoHooks", "Revise", "UUIDs"]
git-tree-sha1 = "8f5fa7056e6dcfb23ac5211de38e6c03f6367794"
uuid = "0ff47ea0-7a50-410d-8455-4348d5de0420"
version = "0.1.6"

[[deps.PlutoTeachingTools]]
deps = ["Downloads", "HypertextLiteral", "LaTeXStrings", "Latexify", "Markdown", "PlutoLinks", "PlutoUI", "Random"]
git-tree-sha1 = "542de5acb35585afcf202a6d3361b430bc1c3fbd"
uuid = "661c6b06-c737-4d37-b85c-46df65de6f69"
version = "0.2.13"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "bd7c69c7f7173097e7b5e1be07cee2b8b7447f51"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.54"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "03b4c25b43cb84cee5c90aa9b5ea0a78fd848d2f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00805cd429dcb4870060ff49ef443486c262e38e"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Qt6Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Vulkan_Loader_jll", "Xorg_libSM_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_cursor_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "libinput_jll", "xkbcommon_jll"]
git-tree-sha1 = "37b7bb7aabf9a085e0044307e1717436117f2b3b"
uuid = "c0090381-4147-56d7-9ebc-da0b1113ec56"
version = "6.5.3+1"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "9ebcd48c498668c7fa0e97a9cae873fbee7bfee1"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.9.1"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Ratios]]
deps = ["Requires"]
git-tree-sha1 = "1342a47bf3260ee108163042310d26f2be5ec90b"
uuid = "c84ed2f1-dad5-54f0-aa8e-dbefe2724439"
version = "0.4.5"
weakdeps = ["FixedPointNumbers"]

    [deps.Ratios.extensions]
    RatiosFixedPointNumbersExt = "FixedPointNumbers"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "PrecompileTools", "RecipesBase"]
git-tree-sha1 = "45cf9fd0ca5839d06ef333c8201714e888486342"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.12"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "ffdaf70d81cf6ff22c2b6e733c900c3321cab864"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.1"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Revise]]
deps = ["CodeTracking", "Distributed", "FileWatching", "JuliaInterpreter", "LibGit2", "LoweredCodeUtils", "OrderedCollections", "Pkg", "REPL", "Requires", "UUIDs", "Unicode"]
git-tree-sha1 = "a38e7d70267283888bc83911626961f0b8d5966f"
uuid = "295af30f-e4ad-537b-8983-00126c2a3abe"
version = "3.5.9"

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "f65dcb5fa46aee0cf9ed6274ccbd597adc49aa7b"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.1"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6ed52fdd3382cf21947b15e8870ac0ddbff736da"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.4.0+0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "3bac05bc7e74a75fd9cba4295cde4045d9fe2386"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.1"

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "0e7508ff27ba32f26cd459474ca2ede1bc10991f"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.4.1"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "5165dfb9fd131cf0c6957a3a7605dede376e7b63"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.0"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "e2cfc4012a19088254b3950b85c3c1d8882d864d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.3.1"
weakdeps = ["ChainRulesCore"]

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore"]
git-tree-sha1 = "5ef59aea6f18c25168842bded46b16662141ab87"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.7.0"
weakdeps = ["Statistics"]

    [deps.StaticArrays.extensions]
    StaticArraysStatisticsExt = "Statistics"

[[deps.StaticArraysCore]]
git-tree-sha1 = "36b3d696ce6366023a0ea192b4cd442268995a0d"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.2"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "1d77abd07f617c4868c33d4f5b9e1dbb2643c9cf"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.2"

[[deps.StatsFuns]]
deps = ["HypergeometricFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "f625d686d5a88bcd2b15cd81f18f98186fdc0c9a"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "1.3.0"

    [deps.StatsFuns.extensions]
    StatsFunsChainRulesCoreExt = "ChainRulesCore"
    StatsFunsInverseFunctionsExt = "InverseFunctions"

    [deps.StatsFuns.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.StatsPlots]]
deps = ["AbstractFFTs", "Clustering", "DataStructures", "Distributions", "Interpolations", "KernelDensity", "LinearAlgebra", "MultivariateStats", "NaNMath", "Observables", "Plots", "RecipesBase", "RecipesPipeline", "Reexport", "StatsBase", "TableOperations", "Tables", "Widgets"]
git-tree-sha1 = "9115a29e6c2cf66cf213ccc17ffd61e27e743b24"
uuid = "f3b207a7-027a-5e70-b257-86293d7955fd"
version = "0.15.6"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TableOperations]]
deps = ["SentinelArrays", "Tables", "Test"]
git-tree-sha1 = "e383c87cf2a1dc41fa30c093b2a19877c83e1bc1"
uuid = "ab02a1b2-a7df-11e8-156e-fb1833f50b87"
version = "1.2.0"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "cb76cf677714c095e535e3501ac7954732aeea2d"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.11.1"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
git-tree-sha1 = "1fbeaaca45801b4ba17c251dd8603ef24801dd84"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.10.2"
weakdeps = ["Random", "Test"]

    [deps.TranscodingStreams.extensions]
    TestExt = ["Test", "Random"]

[[deps.Tricks]]
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "242982d62ff0d1671e9029b52743062739255c7e"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.18.0"

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    InverseFunctionsUnitfulExt = "InverseFunctions"

    [deps.Unitful.weakdeps]
    ConstructionBase = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "e2d817cc500e960fdbafcf988ac8436ba3208bfd"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.6.3"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.Vulkan_Loader_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Wayland_jll", "Xorg_libX11_jll", "Xorg_libXrandr_jll", "xkbcommon_jll"]
git-tree-sha1 = "2f0486047a07670caad3a81a075d2e518acc5c59"
uuid = "a44049a8-05dd-5a78-86c9-5fde0876e88c"
version = "1.3.243+0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "EpollShim_jll", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "7558e29847e99bc3f04d6569e82d0f5c54460703"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+1"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.Widgets]]
deps = ["Colors", "Dates", "Observables", "OrderedCollections"]
git-tree-sha1 = "fcdae142c1cfc7d89de2d11e08721d0f2f86c98a"
uuid = "cc8bc4a8-27d6-5769-a93b-9d913e69aa62"
version = "0.6.6"

[[deps.WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "5f24e158cf4cee437052371455fe361f526da062"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "0.5.6"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "da69178aacc095066bad1f69d2f59a60a1dd8ad1"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.12.0+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "522b8414d40c4cbbab8dee346ac3a09f9768f25d"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.4.5+0"

[[deps.Xorg_libICE_jll]]
deps = ["Libdl", "Pkg"]
git-tree-sha1 = "e5becd4411063bdcac16be8b66fc2f9f6f1e8fe5"
uuid = "f67eecfb-183a-506d-b269-f58e52b52d7c"
version = "1.0.10+1"

[[deps.Xorg_libSM_jll]]
deps = ["Libdl", "Pkg", "Xorg_libICE_jll"]
git-tree-sha1 = "4a9d9e4c180e1e8119b5ffc224a7b59d3a7f7e18"
uuid = "c834827a-8449-5923-a945-d239c165b7dd"
version = "1.2.3+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "afead5aba5aa507ad5a3bf01f58f82c8d1403495"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.6+0"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6035850dcc70518ca32f012e46015b9beeda49d8"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.11+0"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "34d526d318358a859d7de23da945578e8e8727b7"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.4+0"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8fdda4c692503d44d04a0603d9ac0982054635f9"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.1+0"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "b4bfde5d5b652e22b9c790ad00af08b6d042b97d"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.15.0+0"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "730eeca102434283c50ccf7d1ecdadf521a765a4"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.2+0"

[[deps.Xorg_xcb_util_cursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_jll", "Xorg_xcb_util_renderutil_jll"]
git-tree-sha1 = "04341cb870f29dcd5e39055f895c39d016e18ccd"
uuid = "e920d4aa-a673-5f3a-b3d7-f755a4d47c43"
version = "0.1.4+0"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "330f955bc41bb8f5270a369c473fc4a5a4e4d3cb"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.6+0"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "691634e5453ad362044e2ad653e79f3ee3bb98c3"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.39.0+0"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e92a1a012a10506618f10b7047e478403a046c77"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.5.0+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "49ce682769cd5de6c72dcf1b94ed7790cd08974c"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.5+0"

[[deps.eudev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "gperf_jll"]
git-tree-sha1 = "431b678a28ebb559d224c0b6b6d01afce87c51ba"
uuid = "35ca27e7-8b34-5b7f-bca9-bdc33f59eb06"
version = "3.2.9+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a68c9655fbe6dfcab3d972808f1aafec151ce3f8"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.43.0+0"

[[deps.gperf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3516a5630f741c9eecb3720b1ec9d8edc3ecc033"
uuid = "1a1c6b14-54f6-533d-8383-74cd7377aa70"
version = "3.1.1+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+0"

[[deps.libevdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "141fe65dc3efabb0b1d5ba74e91f6ad26f84cc22"
uuid = "2db6ffa8-e38f-5e21-84af-90c45d0032cc"
version = "1.11.0+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libinput_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "eudev_jll", "libevdev_jll", "mtdev_jll"]
git-tree-sha1 = "ad50e5b90f222cfe78aa3d5183a20a12de1322ce"
uuid = "36db933b-70db-51c0-b978-0f229ee0e533"
version = "1.18.0+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.mtdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "814e154bdb7be91d78b6802843f76b6ece642f11"
uuid = "009596ad-96f7-51b1-9f1b-5ce2d5e8a71e"
version = "1.1.6+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "9c304562909ab2bab0262639bd4f444d7bc2be37"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+1"
"""

# ╔═╡ Cell order:
# ╟─c9cfb450-3e8b-11ed-39c2-cd1b7df7ca01
# ╟─f3c62849-620d-47b3-b698-79c925897d54
# ╟─30b4bf3c-82dc-46f7-bd69-5fdeada9ebad
# ╟─77535564-648a-4e17-83a0-c562cc5318ec
# ╟─2057c799-18b5-4a0f-b2c7-66537a3fbe79
# ╟─43cedf4c-65c4-4b2b-afb3-21f5827f2af6
# ╟─351694f5-1b83-426f-a190-c87c69152ef0
# ╟─66926dbf-964d-4048-b8ad-459f36236c14
# ╟─1b4c860a-7245-4793-8acf-a1f01700b499
# ╟─3319498b-db49-4516-b699-b99da093c9cb
# ╟─0f8b4a5b-94b8-4f2b-975d-3579eb9c62b1
# ╟─1f524d92-e589-48f9-b3cc-bcef0bae4bca
# ╟─ce1d28e1-3c77-461e-822a-6e5783bf2744
# ╟─dafe8d1f-6c99-46a4-a2d1-2e34e12ba4a7
# ╟─1bc6b970-f1fa-48c9-b17e-cef4d01aa47a
# ╟─15571edc-32d7-4ac5-9c53-d49f595f84b1
# ╟─19892f66-98e1-405e-abae-ffda46a546b1
# ╟─1d835b12-f1d7-4ce4-a62e-2cfa7a7b3a21
# ╟─5cbd933e-db0e-49fb-b9d0-267dc93efdb7
# ╟─f06264f4-f020-48f6-9ff3-cac308518eac
# ╠═9308405d-36d0-41a1-8c73-e93b8d699320
# ╟─be0fe9aa-32e6-4c18-8bad-2213e05bca1c
# ╟─0da00057-6bf1-407d-a15f-af24ee549182
# ╟─f593d1c9-7382-4d5c-9c99-5709123af43d
# ╟─31c064a3-e074-409a-9431-48a573a83884
# ╟─80cb7bab-4eb0-4ec1-a067-9d661f2c4da3
# ╟─e4af93c4-19f9-4d94-8ed2-729852ca9432
# ╟─8f9d1066-91d5-43af-9834-b3dc2dbc6400
# ╟─70c00cf9-65ac-44d7-b25c-153614d24240
# ╟─947a0e0f-b620-4e0e-97bd-74749ed87042
# ╟─1e267303-160d-43b9-866f-2d7afc2c4c3f
# ╟─4bae9df7-36a2-4e8a-bdd8-5fdec68cddba
# ╟─2338bade-9fb2-4a75-a39c-3e056f2d00d5
# ╟─b3bcf03b-f4f8-4ddb-ab59-fa5f780ed563
# ╟─5462f241-e284-45b8-8e61-3c0317f6b08b
# ╟─ff01e390-a72d-41b0-9a7c-1d63060491f9
# ╟─6d136ab7-c7ea-43a7-a16d-0af53b123b59
# ╟─c1edf5ff-f25f-4a71-95fb-53515aae9d97
# ╟─a152a7bd-062d-4fd9-be38-c217fdaca20f
# ╟─6131ad55-eee7-44ec-b965-ce17ef3f8f84
# ╟─a2642e09-3202-4c73-914a-bdd6c0b374c2
# ╟─89f0aa81-1da3-41a0-8d72-72637d8052aa
# ╟─4f6232be-dbd1-4e1a-a28c-5fc60964bb9f
# ╟─d76d0594-5a53-4641-818e-496ce3a52c6b
# ╟─5a09f7ba-20df-4b28-a457-7e790efee888
# ╟─fde1b917-9d81-4a29-b553-caad3c736682
# ╟─b4709e13-24ad-4c7e-bd9f-e7113b5089f5
# ╟─278bb5cb-6734-499c-b954-0590f559af1f
# ╟─32c06874-204d-4319-9879-8af6039d5cae
# ╟─92e2e50b-bbce-4b4d-aad4-02e4f374b286
# ╟─316db89e-0b73-4993-a778-5d3ff890e807
# ╟─2c6b9d29-1ab8-4b59-a867-1aecf27dc679
# ╟─cb09680f-ae53-45b1-aa61-e73f81a4bcce
# ╟─022c5b56-e683-4f66-aba9-8b2e89f11e24
# ╟─5649bcda-2ab5-4bb7-b0dc-c132c5fb0a0d
# ╟─9c49b056-7329-49af-838b-3e8b28826157
# ╠═56893f7f-e59c-434d-b8cf-2dd553111707
# ╟─0cd24282-74a4-4261-aa33-019d3afac248
# ╟─1cf90ba3-2f9a-4d58-bdd3-7b57e43fe307
# ╟─5a58f305-4af0-40ae-830a-a318576bf85d
# ╟─fdfa9423-e09e-42b6-bce3-ebbc681f3c93
# ╟─bca20d87-e453-4106-a5cf-bd99d25021ab
# ╟─da59ebaa-e366-4753-8329-27119be19d9a
# ╟─3caf8d96-7cdd-45f4-a54e-08b7a1bc2251
# ╟─12f92e46-9581-4c04-be11-3f3f9b316f26
# ╟─a30ed481-a09a-4d9c-a960-2ca3b4898e30
# ╟─d7a4bd52-8cf1-4495-bc14-2fe19fc9a037
# ╟─d6550d70-a1c1-48fd-b99d-c041b40efad2
# ╟─98672fd3-f85c-40e2-8f71-3a46b8632bf6
# ╟─f7456b7a-3d05-468a-a7ee-50a83affba72
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
