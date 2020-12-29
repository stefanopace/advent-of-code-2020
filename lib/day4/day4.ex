defmodule Day4 do

	defp parse_documents(lines) do
		lines
		|> Input.split_on_blank_lines
		|> Enum.map(fn doc -> Enum.flat_map(doc, fn record -> String.split(record, " ") end) end)
		|> Enum.map(fn doc -> Enum.map(doc, fn record -> 
			[_all, k, v] = Regex.run(~r"(.*):(.*)", record)
			{String.to_atom(k), v}
			end )
		end )
	end

	defp required_fields_are_present(doc) do
		[:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid]
		|> Enum.all?(fn field -> Keyword.has_key?(doc, field) end)
	end

	defp between(num, min, max) do
		{num, _rest} = Integer.parse(num, 10)
		min <= num and num <= max
	end

	defp field_is_valid({:byr, val}), do: between(val, 1920, 2002)
	defp field_is_valid({:iyr, val}), do: between(val, 2010, 2020)
	defp field_is_valid({:eyr, val}), do: between(val, 2020, 2030)
	defp field_is_valid({:hgt, val}) do
		{val, unit} = Integer.parse(val, 10)
		case unit do
			"cm" -> 150 <= val and val <= 193
			"in" -> 59 <= val and val <= 76
			_ -> false
		end
	end
	defp field_is_valid({:hcl, val}) do
		Regex.match?(~r"^#[0-9a-f]{6}$", val)
	end
	defp field_is_valid({:ecl, val}) do
		Enum.member?(["amb","blu","brn","gry","grn","hzl","oth"], val)
	end
	defp field_is_valid({:pid, val}) do
		Regex.match?(~r"^[0-9]{9}$", val)
	end
	defp field_is_valid({:cid, _val}), do: true

	defp fields_are_valids(doc) do
		Enum.all?(doc, &field_is_valid/1)
	end

	@doc """
	## Examples
		iex> Input.read(4) |> Day4.part1
		230
	"""
	def part1(input) do
		input
		|> parse_documents
		|> Enum.filter(&required_fields_are_present/1)
		|> Enum.count
	end
	
	@doc """
	## Examples
		iex> Input.read(4) |> Day4.part2
		156
	"""
	def part2(input) do
		input
		|> parse_documents
		|> Enum.filter(&required_fields_are_present/1)
		|> Enum.filter(&fields_are_valids/1)
		|> Enum.count
	end

end