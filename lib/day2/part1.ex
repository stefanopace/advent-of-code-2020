defmodule Day2.Part1 do
	@doc """
	## Examples
		iex> [
		...>	"1-3 a: abcde",
		...>	"1-3 b: cdefg",
		...>	"2-9 c: ccccccccc"
		...> ] |> Day2.Part1.solve
		2

		iex> Input.read("./lib/day2/input") |> Day2.Part1.solve
		416
	"""
	def solve(input) do
		input
		|> Enum.map(&parse_rule_with_password/1)
		|> Enum.count(&matches_rules?/1)
	end

	defp matches_rules?({min, max, char, password}) do 
		password
		|> String.graphemes
		|> Enum.count(&(&1 == char))
		|> between_range?(min, max)
	end

	def parse_rule_with_password(encoded_rule)do
		encoded_rule
		|> Input.regex_match(~r"(.*)-(.*) (.): (.*)")
		|> (fn {min, max, char, password} -> {String.to_integer(min), String.to_integer(max), char, password} end).()
	end

	defp between_range?(num, min, max), do: num >= min and num <= max
end