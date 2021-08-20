# summation based on a function
sigma(f::Function, m) = sum(map(f, 1:m))

# simplex number of d dimension and index n
function s(d, n)
	if d == 1 return n end

	return sigma(x -> s(d-1, x), n)
end

# number of possible unique rolls with n dice
p(n) = s(n, 6)

# chance of k being the maximum of n rolled dice
c1(n, k) = ( s(n,k) - s(n, k-1) ) // p(n)

# chance of k being the second highest rolled in n dice
function c2(n, k)
	if n < 2 throw("dat is not the right size for n in c2") end

	if n > 2
		return (7-k) * k // p(n)
	elseif n == 2
		return (7-k) // p(n)
	end
end

# propability of p1 having the highest or tied number in a roll
h1(p1, p2) = sigma(n -> c1(p1,n) * sigma(k -> c1(p2,k), n), 6)

# probability of p1 having the 2nd highest or tied for it number in a roll
h2(p1, p2) = sigma(n -> c2(p1,n) * sigma(k -> c2(p2,k), n), 6)

# gives the probability of the attacker losing 0, 1, or 2 peices
function battle(a, d)
	if a<=0 || d<=0 return 0//1, 0//1, 0//1 end

	if d >= 2 && a >= 2
		roll = [h1(d, a), h2(d, a)]
	else
		roll = [h1(d, a), 0]
	end

	return (1 - roll[1]) * (1 - roll[2]) , roll[1] + roll[2] - 2*roll[1]*roll[2] , roll[1] * roll[2]
end
battle(s::Tuple) = battle(s[1], s[2])
