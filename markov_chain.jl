
function marcov_chain(attack_troops, defend_troops)
	# matrix of all possible states in the battle
	# each tuple is the number of troops each might have in a scenario
	possible_states = fill((0, 0), attack_troops + 1, defend_troops + 1)
	for i in 0:attack_troops
		for j in 0:defend_troops
			possible_states[i + 1, j + 1] = (i,j)
		end
	end

	S_index(s::Tuple) = (attack_troops + 1) * s[2] + s[1] + 1


	# set of transition maticies
	P = [fill(0., length(possible_states), length(possible_states))]
	for i in 1:length(possible_states)
		state = possible_states[i]
		attack_dice = clamp(state[1], 0, 3)
		defend_dice = clamp(state[2], 0, 2)
		outcome_probabilities = single_battle(dice)
		
		if state[1] >= 2 && state[2] >= 2
			P[1][i, S_index(state .- (0, 2))] = outcome_probabilities[1]
			P[1][i, S_index(state .- (1, 1))] = outcome_probabilities[2]
			P[1][i, S_index(state .- (2, 0))] = outcome_probabilities[3]

		elseif state[1] > 0 && state[2] > 0 
			P[1][i, S_index(state .- (0, 1))] = outcome_probabilities[1]
			P[1][i, S_index(state .- (1, 0))] = outcome_probabilities[2]
		
		else
			P[1][i, i] = 1;
		end
	end


	# fill up to the max battle length
	push!(P, P[1]^2)
	for i in 2:attack_troops+defend_troops
		out = prod(P[1:i])
		if length(findall(x -> x != 0.0, out)) > 0
			push!(P, out)
		else
			break
		end
	end

	return P, possible_states
end
