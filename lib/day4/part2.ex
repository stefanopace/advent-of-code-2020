alias Day4.Part1, as: Part1

defmodule Day4.Part2 do

	@doc """
	## Examples
		iex> Input.read(4) |> Day4.Part2.solve
		156
	"""
	def solve(input) do
		input
		|> Part1.parse_documents
		|> Enum.filter(&Part1.required_fields_are_present/1)
		|> Enum.filter(&fields_are_valids/1)
		|> Enum.count
	end

	defp fields_are_valids(doc) do
		Enum.all?(doc, &field_is_valid/1)
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

end