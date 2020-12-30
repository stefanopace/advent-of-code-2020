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
		|> Enum.count(fn message -> message |> String.graphemes |> match_rule?({rules, [rules[0]]}) end)
	end

	@doc """
	## Examples
		iex> Input.read(19) |> Day19.part2
		246
	"""
	def part2(input) do
		[encoded_rules, messages] = Input.split_on_blank_lines(input)

		rules = 
			parse_indexed_rules(encoded_rules)
			|> Map.put(8, {:or, [{:and, [42]}, {:and, [42, 8]}]})
			|> Map.put(11, {:or, [{:and, [42, 31]}, {:and, [42, 11, 31]}]})
		
		messages
		|> Enum.count(fn message ->  message |> String.graphemes |> match_rule?({rules, [rules[0]]}) end)		
	end


	defp match_rule?(string, {_rulemap, []}), do: string == []
	defp match_rule?([], {_rulemap, _rule}), do: false
	defp match_rule?(string = [head | tail], {rulemap, [rule | rest]}) do
		case rule do
			"a" -> head == "a" and match_rule?(tail, {rulemap, rest})
			"b" -> head == "b" and match_rule?(tail, {rulemap, rest})
			index when is_number(index) -> match_rule?(string, {rulemap, [rulemap[index] | rest]})
			{:or, rules} -> Enum.any?(rules, fn rule -> match_rule?(string, {rulemap, [rule | rest]}) end)
			{:and, rules} -> match_rule?(string, {rulemap, rules ++ rest})
		end
	end

	defp parse_rule(encoded_rule) do
		cond do
			String.contains?(encoded_rule, "|") ->
				encoded_rule
				|> String.split(" | ")
				|> Enum.map(&parse_rule/1)
				|> (&({:or, &1})).()
			encoded_rule == "\"a\"" -> "a"
			encoded_rule == "\"b\"" -> "b"
			true ->
				encoded_rule
				|> String.split
				|> Enum.map(fn num -> Integer.parse(num) |> elem(0) end)
				|> (&({:and, &1})).()
		end
	end

	defp parse_indexed_rules(encoded_rules) do
		encoded_rules 
		|> Enum.map(fn encoded_rule -> 
			[_all, rule_index_str, rule] = Regex.run(~r|(\d+): (.*)|, encoded_rule)
			{rule_index, _} = Integer.parse(rule_index_str)
			{rule_index, rule}
		end)
		|> Enum.map(fn {index, encoded_rule} -> {index, parse_rule(encoded_rule)} end)
		|> Map.new
	end
end
