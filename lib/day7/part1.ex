defmodule Day7.Part1 do

	@doc """
	## Examples
		iex> Input.read("./lib/day7/input") |> Day7.Part1.solve
		148
	"""
	def solve(input) do
		rules =
			input
			|> Enum.map(&decode_rule/1)
		
		["shiny gold"]
		|> Stream.iterate(fn colors ->
			colors 
			|> Enum.flat_map(&(rules |> find_bags_that_can_contain(&1)))
		end)
		|> Enum.take_while(&Enum.any?/1)
		|> List.flatten
		|> MapSet.new
		|> MapSet.delete("shiny gold")
		|> MapSet.size
	end

	defp find_bags_that_can_contain(rules, color) do
		rules
		|> Enum.filter(fn {_container, inside_bags} -> 
			inside_bags
			|> Enum.map(&(elem(&1, 1)))
			|> Enum.any?(&(&1 == color)) 
		end)
		|> Enum.map(fn {container_color, _inside_colors} -> container_color end)
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
