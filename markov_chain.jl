
function chain(a, d)
	# matrix of all possible states in the battle
	S = fill((0,0), a+1, d+1)
	for i in 0:a
		for j in 0:d
			S[i+1,j+1] = (i,j)
		end
	end

	S_index(s::Tuple) = (a+1)*s[2] + s[1] + 1


	# set of transition maticies
	P = [fill(0., length(S), length(S))]
	for i in 1:length(S)
		s = S[i]
		dice = (clamp(s[1],0,3), clamp(s[2],0,2))
		probs = map(x->Float64(x), battle(dice))
		
		if s[1] >= 2 && s[2] >= 2
			P[1][i, S_index(s.-(0,2))] = probs[1]
			P[1][i, S_index(s.-(1,1))] = probs[2]
			P[1][i, S_index(s.-(2,0))] = probs[3]

		elseif s[1] > 0 && s[2] > 0 
			P[1][i, S_index(s.-(0,1))] = probs[1]
			P[1][i, S_index(s.-(1,0))] = probs[2]
		
		else
			P[1][i,i] = 1;
		end
	end


	# fill upto the max battle length
	push!(P, P[1]^2)
	for i in 2:a+d
		out = prod(P[1:i])
		if length(findall(x->x!=0.0, out)) > 0
			push!(P, out)
		else
			break
		end
	end

	return P, S
end
