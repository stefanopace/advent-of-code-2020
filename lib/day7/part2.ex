alias Day7.Part1, as: Part1

defmodule Day7.Part2 do
	
	@doc """
	## Examples
		iex> Input.read(7) |> Day7.Part2.solve
		24867
	"""
	def solve(input) do
		input
		|> Enum.map(&Part1.decode_rule/1)
		|> count_bags("shiny gold")
		|> Kernel.-(1)
	end

	defp count_bags(rules_list, color_name) do
		{_color, rules} = rules_list |> Enum.find(fn {col, _rul} -> col == color_name end)
		case rules do
			[] -> 1
			rules -> Enum.map(rules, fn {count, in_color} -> 
				count * count_bags(rules_list, in_color) 
			end) |> Enum.sum |> Kernel.+(1)
		end
	end

end
