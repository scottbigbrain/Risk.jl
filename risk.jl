# summation based on attack_dice function
sigma(f::Function, m) = sum(map(f, 1:m))

# simplex number of defend_dice dimension and index n
function simplex(defend_dice, n)
	if defend_dice == 1 return n end

	return sigma(x -> simplex(defend_dice - 1, x), n)
end

# number of possible unique rolls with n dice
possible_unique_rolls(n) = simplex(n, 6)

# chance of k being the maximum of n rolled dice
chance_of_highest(n, k) = ( simplex(n, k) - simplex(n, k - 1) ) / possible_unique_rolls(n)

# chance of k being the second highest rolled in n dice
function chance_of_second_highest(n, k)
	if n < 2 throw("dat is not the right size for n in c2") end

	if n > 2
		return (7 - k) * k / possible_unique_rolls(n)
	elseif n == 2
		return (7 - k) / possible_unique_rolls(n)
	end
end

# propability of p1_dice having the highest or tied number in attack_dice roll
function chance_of_highest_or_tied(p1_dice, p2_dice)
	return sigma(n -> chance_of_highest(p1_dice, n) * sigma(k -> chance_of_highest(p2_dice, k), n), 6)
end

# probability of p1_dice having the 2nd highest or tied for it number in attack_dice roll
function chance_of_second_or_tied(p1_dice, p2_dice)
	return sigma(n -> chance_of_second_highest(p1_dice, n) * sigma(k -> chance_of_second_highest(p2_dice, k), n), 6)
end

# gives the probability of the attacker losing 0, 1, or 2 peices
function single_battle(attack_dice, defend_dice)
	if attack_dice <= 0 || defend_dice <= 0 return 0, 0, 1 end

	if defend_dice >= 2 && attack_dice >= 2
		roll = [chance_of_highest_or_tied(defend_dice, attack_dice), chance_of_second_or_tied(defend_dice, attack_dice)]
	else
		roll = [chance_of_highest_or_tied(defend_dice, attack_dice), 0]
	end

	return (1 - roll[1]) * (1 - roll[2]) , roll[1] + roll[2] - 2 * roll[1] * roll[2] , roll[1] * roll[2]
end
single_battle(s::Tuple) = single_battle(s[1], s[2])
