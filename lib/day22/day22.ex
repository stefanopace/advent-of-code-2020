defmodule Day22 do
	@doc """
	## Examples
		iex> [
		...> 	"Player 1:",
		...> 	"9",
		...> 	"2",
		...> 	"6",
		...> 	"3",
		...> 	"1",
		...> 	"",
		...> 	"Player 2:",
		...> 	"5",
		...> 	"8",
		...> 	"4",
		...> 	"7",
		...> 	"10"
		...> ] |> Day22.part1
		306
		
		iex> Input.read(22) |> Day22.part1
		35202
	"""
	def part1(input) do
		[player1_deck, player2_deck] =
			input
			|> parse_decks

		combat(player1_deck, player2_deck)
		|> compute_score
	end

	@doc """
	## Examples
		iex> [
		...> 	"Player 1:",
		...> 	"9",
		...> 	"2",
		...> 	"6",
		...> 	"3",
		...> 	"1",
		...> 	"",
		...> 	"Player 2:",
		...> 	"5",
		...> 	"8",
		...> 	"4",
		...> 	"7",
		...> 	"10"
		...> ] |> Day22.part2
		291
		
		# test too slow
		# iex> Input.read(22) |> Day22.part2
		# 32317
	"""
	def part2(input) do
		[player1_deck, player2_deck] =
			input
			|> parse_decks

		recursive_combat(player1_deck, player2_deck, [])
		|> compute_score
	end

	defp recursive_combat(deck1, [], _), do: {:player1, deck1}
	defp recursive_combat([], deck2, _), do: {:player2, deck2}
	defp recursive_combat(deck1 = [card1 | rest1], deck2 = [card2 | rest2], previous_turns) do
		cond do
			previous_turns |> Enum.member?({deck1, deck2}) -> {:player1, deck1}
			length(rest1) >= card1 and length(rest2) >= card2 -> 
				case recursive_combat(Enum.take(rest1, card1), Enum.take(rest2, card2), []) do
					{:player1, _} -> recursive_combat(rest1 ++ [card1, card2], rest2, [{deck1, deck2} | previous_turns])
					{:player2, _} -> recursive_combat(rest1, rest2 ++ [card2, card1], [{deck1, deck2} | previous_turns])
				end
			card1 > card2 -> recursive_combat(rest1 ++ [card1, card2], rest2, [{deck1, deck2} | previous_turns])
			card2 > card1 -> recursive_combat(rest1, rest2 ++ [card2, card1], [{deck1, deck2} | previous_turns])
		end
	end

	defp compute_score({_winning_player, deck}) do
		deck
		|> Enum.reverse
		|> Enum.with_index
		|> Enum.map(fn {card, index} -> card * (index + 1) end)
		|> Enum.sum
	end

	defp combat(deck1, []), do: {:player1, deck1}
	defp combat([], deck2), do: {:player2, deck2}
	defp combat([card1 | deck1], [card2 | deck2]) when card1 > card2 do
		combat(deck1 ++ [card1, card2], deck2)
	end
	defp combat([card1 | deck1], [card2 | deck2]) when card1 < card2 do
		combat(deck1, deck2 ++ [card2, card1])
	end

	defp parse_decks(lines) do
		lines
		|> Input.split_on_blank_lines
		|> Enum.map(fn [_header | deck] -> deck end)
		|> Enum.map(fn deck -> 
			deck
			|> Enum.map(fn strnum -> Integer.parse(strnum) |> elem(0) end)
		end)
	end

end
