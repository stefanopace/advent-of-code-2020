defmodule Day18 do
	@doc """
	## Examples
		iex> Day18.part1
		69490582260
	"""
	def part1 do
		Input.read(18)
		|> Enum.map(&parse_expression/1)
		|> Enum.map(&solve_v1/1)
		|> Enum.sum
	end

	defp solve_v1(expression) when is_number(expression) do
		expression
	end
	defp solve_v1([expression]) do
		expression
	end
	defp solve_v1([left, "*", right | rest]) do
		solve_v1([solve_v1(left) * solve_v1(right) | rest])
	end
	defp solve_v1([left, "+", right | rest]) do
		solve_v1([solve_v1(left) + solve_v1(right) | rest])
	end

	defp parse_expression(encoded) do
		encoded
		|> String.replace(" ", "")
		|> String.graphemes
		|> parse_integers
		|> parenthesize
	end

	defp parse_integers(encoded) do
		encoded
		|> Enum.map(fn char -> 
			case Integer.parse(char) do
				:error -> char
				{num, _} -> num
			end
		end)
	end

	defp parenthesize(encoded) do
		encoded
		|> Enum.chunk_while(
			{0, []},
			fn 
				"(", {parenthesis_count, expr} -> {:cont, {parenthesis_count + 1, ["(" | expr]}}
				")", {parenthesis_count, expr} when parenthesis_count == 1 -> 
					{
						:cont, 
						expr |> Enum.reverse |> (fn [_first_parenthesis | rest] -> rest end).(),
						{0, []}
					}
				")", {parenthesis_count, expr} -> {:cont, {parenthesis_count - 1, [")" | expr]}}
				symbol, {parenthesis_count, _expr} when parenthesis_count == 0 -> {:cont, symbol, {0, []}}
				symbol, {parenthesis_count, expr} -> {:cont, {parenthesis_count, [symbol | expr]}}
			end,
			fn acc -> {:cont, acc} end
		)
		|> Enum.map(
			fn 
				expr when is_list(expr) -> parenthesize(expr)
				symbol -> symbol
			end
		)
	end

	@doc """
	## Examples
		iex> Day18.part2
		:error
	"""
	def part2 do
		:error
	end
end
