alias Day2.Part1, as: Part1

defmodule Day2.Part2 do
@doc """
	## Examples
		iex> Input.read("./lib/day2/input") |> Day2.Part2.solve
		688
	
		iex> [
		...>	"1-3 a: abcde",
		...>	"1-3 b: cdefg",
		...>	"2-9 c: ccccccccc"
		...> ] |> Day2.Part2.solve
		1
	"""
	def solve(input) do
		input
		|> Enum.map(&Part1.parse_rule_with_password/1)
		|> Enum.count(&matches_rules?/1)
	end

	defp matches_rules?{first, second, char, password} do
		[
			password |> String.at(first - 1), 
			password |> String.at(second - 1)
		]
		|> Enum.count(&(&1 == char))
		|> Kernel.==(1)
	end

end