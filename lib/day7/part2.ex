alias Day7.Part1, as: Part1

defmodule Day7.Part2 do
	
	@doc """
	## Examples
		iex> Input.read("./lib/day7/input") |> Day7.Part2.solve
		24867
	"""
	def solve(input) do
		input
		|> Enum.map(&Part1.decode_rule/1)
		|> count_containing_bags("shiny gold")
		|> Kernel.-(1)
	end

	defp count_containing_bags(rules_list, color_name) do
		rules_list
		|> Enum.find_value(fn 
			{^color_name, rule} -> rule
			___________________ -> false
		end)
		|> Enum.map(fn {count, color} -> 
			count * (rules_list |> count_containing_bags(color))
		end)
		|> Enum.sum
		|> Kernel.+(1)
	end

end
