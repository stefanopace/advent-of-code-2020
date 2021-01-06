defmodule Day2 do
	@doc """
	## Examples
		iex> [
		...>	"1-3 a: abcde",
		...>	"1-3 b: cdefg",
		...>	"2-9 c: ccccccccc"
		...> ] |> Day2.part1
		2

		iex> Input.read("./lib/day2/input") |> Day2.part1
		416
	"""
	def part1(input) do
		input
		|> Enum.map(&parse_rule_with_password/1)
		|> Enum.count(&matches_part1_rules?/1)
	end

	@doc """
	## Examples
		iex> Input.read(2) |> Day2.part2
		688
	
		iex> [
		...>	"1-3 a: abcde",
		...>	"1-3 b: cdefg",
		...>	"2-9 c: ccccccccc"
		...> ] |> Day2.part2
		1
	"""
	def part2(input) do
		input
		|> Enum.map(&parse_rule_with_password/1)
		|> Enum.count(fn {first, second, char, password} -> 
			[String.at(password, first - 1), String.at(password, second - 1)]
			|> Enum.count(&(&1 == char))
			|> Kernel.==(1)
		end)
	end

	defp matches_part2_rules?{first, second, char, password} do
		[String.at(password, first - 1), String.at(password, second - 1)]
		|> Enum.count(&(&1 == char))
		|> Kernel.==(1)
	end

	defp matches_part1_rules?({min, max, char, password}) do 
		password
		|> String.graphemes
		|> Enum.count(fn c -> c == char end)
		|> between_range(min, max)
	end

	defp parse_rule_with_password(encoded_rule)do
		encoded_rule
		|> Input.regex_match(~r"(.*)-(.*) (.): (.*)")
		|> (fn {min, max, char, password} -> {String.to_integer(min), String.to_integer(max), char, password} end).()
	end

	defp between_range(num, min, max) do
		num >= min and num <= max
	end
end