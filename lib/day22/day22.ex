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

		play(player1_deck, player2_deck)
		|> compute_score
	end

	defp compute_score({_winning_player, deck}) do
		deck
		|> Enum.reverse
		|> Enum.with_index
		|> Enum.map(fn {card, index} -> card * (index + 1) end)
		|> Enum.sum
	end

	defp play(deck1, []), do: {:player1, deck1}
	defp play([], deck2), do: {:player2, deck2}
	defp play([card1 | deck1], [card2 | deck2]) when card1 > card2 do
		play(deck1 ++ [card1, card2], deck2)
	end
	defp play([card1 | deck1], [card2 | deck2]) when card1 < card2 do
		play(deck1, deck2 ++ [card2, card1])
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

	@doc """
	## Examples
		iex> Input.read(22) |> Day22.part2
		:result
	"""
	def part2(_input) do
		:result
	end
end
