include("risk.jl")
include("markov_chain.jl")

a, d = 3, 2

P, S = chain(a,d)

probs = map(x -> x[end, 1:end], P)
