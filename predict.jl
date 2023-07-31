include("risk.jl")
include("markov_chain.jl")

attacker_troops, defender_troops = 3, 2

P, possible_states = chain(a,d)

probs = map(x -> x[end, 1:end], P)
