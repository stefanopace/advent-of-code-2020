defmodule Day19 do
	@doc """
	## Examples
		iex> [ 
		...>	"0: 4 1 5",
		...>	"1: 2 3 | 3 2",
		...>	"2: 4 4 | 5 5",
		...>	"3: 4 5 | 5 4",
		...>	"4: \\"a\\"",
		...>	"5: \\"b\\"",
		...>	"",
		...>	"ababbb",
		...>	"bababa",
		...>	"abbbab",
		...>	"aaabbb",
		...>	"aaaabbb",
		...>] |> Day19.part1
		2

		# iex> Input.read(19) |> Day19.part1
		# :result
	"""
	def part1(input) do
		[encoded_rules, messages] = Input.split_on_blank_lines(input)

		rules = parse_indexed_rules(encoded_rules)
	end

	@doc """
	## Examples
		iex> Input.read(19) |> Day19.part2
		:result
	"""
	def part2(input) do
		:result
	end

	defp parse_indexed_rules(encoded_rules) do
		encoded_rules 
		|> Enum.map(fn encoded_rule -> 
			[_all, rule_index_str, rule] = Regex.run(~r|(\d+): (.*)|, encoded_rule)
			{rule_index, _} = Integer.parse(rule_index_str)
			{rule_index, rule}
		end)
		|> Enum.map(fn {index, encoded_rule} -> 
			decoded_rule = 
				encoded_rule
				|> String.split(" | ")
				|> Enum.map(fn rule_part -> 
					rule_part
					|> String.split 
					|> Enum.map(fn rule_atom -> 
						case rule_atom do
							"\"a\"" -> "a"
							"\"b\"" -> "b"
							num -> Integer.parse(num) |> elem(0)
						end
					end)
				end)
			
			{index, decoded_rule}
		end)
		|> Map.new
	end
end
