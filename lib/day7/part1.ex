defmodule Day7.Part1 do
	@doc """
	## Examples
		iex> Input.read("./lib/day7/input") |> Day7.Part1.solve
		148
	"""
	def solve(input) do
		input
		|> Enum.map(&decode_rule/1)
		|> find_possible_outmosts_of("shiny gold")
		|> MapSet.delete("shiny gold")
		|> MapSet.size
	end

	defp find_possible_outmosts_of(rules, color) when is_bitstring(color), do: rules |> find_possible_outmosts_of([[color]])
	defp find_possible_outmosts_of(_rules, [ [] | colors ]) do
		colors |> List.flatten |> MapSet.new
	end
	defp find_possible_outmosts_of(rules, [ current_colors | _prev ] = acc) do
		rules |> find_possible_outmosts_of([Enum.flat_map(current_colors, fn color -> find_bags_that_can_contain(rules, color) end) | acc])
	end
	

	defp find_bags_that_can_contain(rules, color) do
		rules
		|> Enum.filter(fn{_c, rule} -> 
			Enum.any?(rule, fn {_count, in_color} -> in_color == color end) 
		end)
		|> Enum.map(fn {color, _} -> color end)
	end

	def decode_rule(row) do
		[outside, inside_encoded] = row |> String.split(" bags contain ")
		inside = 
			inside_encoded
			|> String.split(", ")
			|> Enum.map(fn rule ->
				case rule |> Input.regex_match(~r"([0-9]+) (.*) bag.?") do
					{count, color} -> {String.to_integer(count), color}
					______________ -> :empty
				end
			end)
			|> Enum.filter(&(&1 != :empty))
		
		{outside, inside}
	end

end
