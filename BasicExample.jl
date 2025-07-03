### A Pluto.jl notebook ###
# v0.20.13

using Markdown
using InteractiveUtils

# ╔═╡ fd3eccb2-5804-11f0-1f8b-5b937fe1a4da
begin
	import Pkg
    Pkg.activate("/workspaces/DyadTutorialComponents")
    Pkg.instantiate()
end

# ╔═╡ 00fe22ee-046f-486e-a9e8-9a1988ba9cb8
using DyadTutorialComponents

# ╔═╡ 9f79d38d-36d9-4f5c-8ba0-6e2543555deb
using Plots


# ╔═╡ 13b2b86d-ad02-4706-b848-dd9014b62df2
result = DyadTutorialComponents.World()

# ╔═╡ aacf0c19-e0ad-4ac5-bc2a-6b85bc244ed1
plot(result)

# ╔═╡ Cell order:
# ╠═fd3eccb2-5804-11f0-1f8b-5b937fe1a4da
# ╠═00fe22ee-046f-486e-a9e8-9a1988ba9cb8
# ╠═13b2b86d-ad02-4706-b848-dd9014b62df2
# ╠═9f79d38d-36d9-4f5c-8ba0-6e2543555deb
# ╠═aacf0c19-e0ad-4ac5-bc2a-6b85bc244ed1
