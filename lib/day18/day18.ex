defmodule Day18 do
	@doc """
	## Examples
		iex> Input.read(18) |> Day18.part1
		69490582260
	"""
	def part1(input) do
		input
		|> Enum.map(&parse_expression/1)
		|> Enum.map(&solve/1)
		|> Enum.sum
	end


	@doc """
	## Examples
		iex> ["4 * 2 + 3"] |> Day18.part2
		20

		iex> ["(4 * 2) + 3"] |> Day18.part2
		11

		iex> ["4 * 2 + 3 * 9"] |> Day18.part2
		180

		iex> ["((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2"] |> Day18.part2
		23340
		
		iex> ["5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))"] |> Day18.part2
		669060

		iex> Input.read(18) |> Day18.part2
		362464596624526
	"""
	def part2(input) do
		input
		|> Enum.map(fn row -> 
			row
			|> parse_expression
			|> solve_v2
		end)
		|> Enum.sum
	end

	defp solve_v2(expression) do
		case expression do
			expression when is_number(expression) -> expression
			[expression] -> solve_v2(expression)
			[left, "*", right | rest] -> solve_v2(left) * solve_v2([right | rest])
			[left, "+", right | rest] -> solve_v2([solve_v2(left) + solve_v2(right) | rest])
		end
	end

	defp solve(expression) do
		case expression do
			expression when is_number(expression) -> expression
			[expression] -> solve(expression)
			[left, "*", right | rest] -> solve([solve(left) * solve(right) | rest])
			[left, "+", right | rest] -> solve([solve(left) + solve(right) | rest])
		end
	end

	defp parse_expression(encoded) do
		encoded
		|> String.replace(" ", "")
		|> String.graphemes
		|> parse_integers
		|> parse_parenthesis
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

	defp parse_parenthesis(encoded) do
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
				expr when is_list(expr) -> parse_parenthesis(expr)
				symbol -> symbol
			end
		)
	end
end
