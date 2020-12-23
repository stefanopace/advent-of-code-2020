defmodule Day7 do
	@doc """
	## Examples
		iex> Day7.part1
		148
	"""
	def part1 do
		Input.read(7)
		|> Enum.map(&decode_rule/1)
		|> find_outmosts([["shiny gold"]])
		|> Enum.filter(fn col -> col != "shiny gold" end)
		|> Enum.count
	end

	defp find_outmosts(rules, acc) do
		[ current_colors | _prev ] = acc
		case current_colors do
			[] -> List.flatten(acc) |> Enum.sort |> Enum.dedup
			colors -> find_outmosts(rules, [Enum.flat_map(colors, fn color -> find_can_contain(rules, color) end) | acc])
		end
	end

	defp find_can_contain(rules, color) do
		rules
		|> Enum.filter(fn{_c, rule} -> 
			Enum.any?(rule, fn {_count, in_color} -> in_color == color end) 
		end)
		|> Enum.map(fn {color, _} -> color end)
	end

	defp decode_rule(row) do
		[out, inside_list] = String.split(row, " bags contain ")
		inside = 
			String.split(inside_list, ", ")
			|> Enum.map(fn rule ->
				case Regex.run(~r"([0-9]+) (.*) bag.?", rule) do
					[_all, count, color] -> 
						{count, _rest} = Integer.parse(count, 10)
						{count, color}
					_ -> :empty
				end
			end)
			|> Enum.filter(&(&1 != :empty))
		
		{out, inside}
	end

	@doc """
	## Examples
		iex> Day7.part2
		:error
	"""
	def part2 do
		:error
	end
end
