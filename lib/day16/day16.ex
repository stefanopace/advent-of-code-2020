defmodule Day16 do
	@doc """
	## Examples
		iex> Day16.part1
		25984
	"""
	def part1 do
		[rules_input, my_ticket_input, nearby_tickets_input] = 
			Input.read(16)
			|> Input.split_on_blank_lines

		rules = parse_rules(rules_input)
		_my_ticket = parse_ticket(my_ticket_input)
		nearby_tickets = parse_nearby_tickets(nearby_tickets_input)

		nearby_tickets
		|> List.flatten
		|> Enum.reject(fn value -> 
			rules
			|> Enum.any?(fn {_field_name, ranges} ->
				ranges
				|> Enum.any?(fn {min, max} -> min <= value and value <= max end)
			end)
		end)
		|> Enum.sum
	end


	@doc """
	## Examples
		iex> Day16.part2
		:error
	"""
	def part2 do
		[rules_input, my_ticket_input, nearby_tickets_input] = 
			Input.read(16)
			|> Input.split_on_blank_lines

		rules = parse_rules(rules_input)
		my_ticket = parse_ticket(my_ticket_input)
		nearby_tickets = parse_nearby_tickets(nearby_tickets_input)

		valid_tickets = 
			[my_ticket | nearby_tickets]
			|> Enum.filter(&(ticket_is_valid?(&1, rules)))
		
		rules
		|> compute_candidates_indexes(valid_tickets)
		|> find_actual_indexes([])
		|> Enum.filter(fn {field_name, _index} -> String.starts_with?(field_name, "departure") end)
		|> Enum.map(fn {_field_name, index} -> Enum.at(my_ticket, index) end)
		|> Enum.reduce(fn n, mul -> n * mul end)

	end
	
	defp find_actual_indexes([], actual) do
		actual
	end
	defp find_actual_indexes(candidates, actual) do
		{name, [index]} =
			candidates
			|> Enum.find(fn {_name, indexes} -> length(indexes) == 1 end)
		
		rest =
			candidates
			|> Enum.reject(fn 
				{^name, _} -> true 
				_ -> false
			end)
			|> Enum.map(fn {name, indexes} -> {name, indexes -- [index]} end)
		
		find_actual_indexes(rest, [{name, index} | actual])
	end

	defp compute_candidates_indexes(rules, tickets = [example_ticket | _]) do
		rules
		|> Enum.map(fn rule = {field_name, _ranges} -> 
			field_indexes =
				0..(length(example_ticket) - 1)
				|> Enum.filter(fn index ->
					tickets
					|> Enum.all?(fn ticket -> 
						ticket
						|> Enum.at(index)
						|> rule_matches?(rule)
					end)
				end)
		
			{field_name, field_indexes}
		end)
	end

	defp ticket_is_valid?(values, rules) do
		values
		|> Enum.all?(fn value -> 
			rules |> Enum.any?(&(rule_matches?(value, &1)))
		end)
	end

	defp rule_matches?(value, {_field_name, ranges}) do
		ranges
		|> Enum.any?(fn {min, max} -> min <= value and value <= max end)
	end

	defp parse_rules(input) do
		input
		|> Enum.map(&(Regex.run(~r/([\w ]+): (\d+)-(\d+) or (\d+)-(\d+)/, &1)))
		|> Enum.map(fn [_all, field_name, min1, max1, min2, max2] -> 
			{
				field_name, 
				[{to_int(min1), to_int(max1)}, {to_int(min2), to_int(max2)}]
			} 
		end)
	end

	defp to_int(strval) do
		Integer.parse(strval) |> elem(0)
	end

	defp parse_ticket([_header, values_input]) do
		String.split(values_input, ",")
		|> Enum.map(&(&1 |> Integer.parse |> elem(0)))
	end

	defp parse_nearby_tickets([_header | tickets_input]) do
		tickets_input
		|> Enum.map(fn line ->
			String.split(line, ",")
			|> Enum.map(&(&1 |> Integer.parse |> elem(0)))
		end)
	end
end
