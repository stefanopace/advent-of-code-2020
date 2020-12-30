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

		iex> Input.read(19) |> Day19.part1
		118
	"""
	def part1(input) do
		[encoded_rules, messages] = Input.split_on_blank_lines(input)

		rules = parse_indexed_rules(encoded_rules)

		messages
		|> Enum.filter(fn message -> [] == message |> String.graphemes |> match_rule(rules, rules[0]) end)
		|> Enum.count
	end

	@doc """
	## Examples
	# iex> [
	# ...>	"42: 9 14 | 10 1",
	# ...>	"9: 14 27 | 1 26",
	# ...>	"10: 23 14 | 28 1",
	# ...>	"1: \\"a\\"",
	# ...>	"11: 42 31",
	# ...>	"5: 1 14 | 15 1",
	# ...>	"19: 14 1 | 14 14",
	# ...>	"12: 24 14 | 19 1",
	# ...>	"16: 15 1 | 14 14",
	# ...>	"31: 14 17 | 1 13",
	# ...>	"6: 14 14 | 1 14",
	# ...>	"2: 1 24 | 14 4",
	# ...>	"0: 8 11",
	# ...>	"13: 14 3 | 1 12",
	# ...>	"15: 1 | 14",
	# ...>	"17: 14 2 | 1 7",
	# ...>	"23: 25 1 | 22 14",
	# ...>	"28: 16 1",
	# ...>	"4: 1 1",
	# ...>	"20: 14 14 | 1 15",
	# ...>	"3: 5 14 | 16 1",
	# ...>	"27: 1 6 | 14 18",
	# ...>	"14: \\"b\\"",
	# ...>	"21: 14 1 | 1 14",
	# ...>	"25: 1 1 | 1 14",
	# ...>	"22: 14 14",
	# ...>	"8: 42",
	# ...>	"26: 14 22 | 1 20",
	# ...>	"18: 15 15",
	# ...>	"7: 14 5 | 1 21",
	# ...>	"24: 14 1",
	# ...>	"",
	# ...>	"abbbbbabbbaaaababbaabbbbabababbbabbbbbbabaaaa",
	# ...>	"bbabbbbaabaabba",
	# ...>	"babbbbaabbbbbabbbbbbaabaaabaaa",
	# ...>	"aaabbbbbbaaaabaababaabababbabaaabbababababaaa",
	# ...>	"bbbbbbbaaaabbbbaaabbabaaa",
	# ...>	"bbbababbbbaaaaaaaabbababaaababaabab",
	# ...>	"ababaaaaaabaaab",
	# ...>	"ababaaaaabbbaba",
	# ...>	"baabbaaaabbaaaababbaababb",
	# ...>	"abbbbabbbbaaaababbbbbbaaaababb",
	# ...>	"aaaaabbaabaaaaababaa",
	# ...>	"aaaabbaaaabbaaa",
	# ...>	"aaaabbaabbaaaaaaabbbabbbaaabbaabaaa",
	# ...>	"babaaabbbaaabaababbaabababaaab",
	# ...>	"aabbbbbaabbbaaaaaabbbbbababaaaaabbaaabba"
	# ...> ] |> Day19.part2
	# 12

	iex> [
	...>	"42: 9 14 | 10 1",
	...>	"9: 14 27 | 1 26",
	...>	"10: 23 14 | 28 1",
	...>	"1: \\"a\\"",
	...>	"11: 42 31",
	...>	"5: 1 14 | 15 1",
	...>	"19: 14 1 | 14 14",
	...>	"12: 24 14 | 19 1",
	...>	"16: 15 1 | 14 14",
	...>	"31: 14 17 | 1 13",
	...>	"6: 14 14 | 1 14",
	...>	"2: 1 24 | 14 4",
	...>	"0: 8 11",
	...>	"13: 14 3 | 1 12",
	...>	"15: 1 | 14",
	...>	"17: 14 2 | 1 7",
	...>	"23: 25 1 | 22 14",
	...>	"28: 16 1",
	...>	"4: 1 1",
	...>	"20: 14 14 | 1 15",
	...>	"3: 5 14 | 16 1",
	...>	"27: 1 6 | 14 18",
	...>	"14: \\"b\\"",
	...>	"21: 14 1 | 1 14",
	...>	"25: 1 1 | 1 14",
	...>	"22: 14 14",
	...>	"8: 42",
	...>	"26: 14 22 | 1 20",
	...>	"18: 15 15",
	...>	"7: 14 5 | 1 21",
	...>	"24: 14 1",
	...>	"",
	...>	"babbbbaabbbbbabbbbbbaabaaabaaa",
	...> ] |> Day19.part2
	1

		# iex> Input.read(19) |> Day19.part2
		# :result
	"""
	def part2(input) do
		[encoded_rules, messages] = Input.split_on_blank_lines(input)

		rules = 
			parse_indexed_rules(encoded_rules)		
			|> Map.put(8, [[42], [42, 8]])
			|> Map.put(11, [[42, 31], [42, 11, 31]])
		
		messages
		|> Enum.map(fn message ->  message |> String.graphemes |> match_rule(rules, rules[0]) end)
		# |> Enum.count
	end

	defp match_rule(message, rules, rule) when length(rule) > 1 do
		rule
		|> Enum.map(fn rule_part -> match_rule(message, rules, [rule_part]) end)
		|> Enum.find(false, fn res -> res end)
	end
	defp match_rule([], _rules, _rule), do: false
	defp match_rule([first | rest], _rules, [["a"]]), do: (if (first == "a"), do: rest, else: false)
	defp match_rule([first | rest], _rules, [["b"]]), do: (if (first == "b"), do: rest, else: false)
	defp match_rule(message, rules, [rule]) do
		rule
		|> Enum.map(&(rules[&1]))
		|> Enum.reduce_while(
			message,
			fn rule_atom, rest ->
				case match_rule(rest, rules, rule_atom) do
					false -> {:halt, false}
					rest -> {:cont, rest}
				end
			end
		)
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
