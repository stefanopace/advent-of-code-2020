alias Day4.Part1, as: Part1

defmodule Day4.Part2 do

	@doc """
	## Examples
		iex> Input.read("./lib/day4/input") |> Day4.Part2.solve
		156
	"""
	def solve(input) do
		input
		|> Part1.parse_documents
		|> Enum.filter(&Part1.are_required_fields_present?/1)
		|> Enum.count(&are_all_fields_valid?/1)
	end

	defp are_all_fields_valid?(doc), do: doc |> Enum.all?(&is_field_valid?/1)

	defp is_field_valid?({:byr, val}), do: val |> String.to_integer |> between?(1920, 2002)
	defp is_field_valid?({:iyr, val}), do: val |> String.to_integer |> between?(2010, 2020)
	defp is_field_valid?({:eyr, val}), do: val |> String.to_integer |> between?(2020, 2030)
	defp is_field_valid?({:hcl, val}), do: Regex.match?(~r"^#[0-9a-f]{6}$", val)
	defp is_field_valid?({:ecl, val}), do: Enum.member?(["amb","blu","brn","gry","grn","hzl","oth"], val)
	defp is_field_valid?({:pid, val}), do: Regex.match?(~r"^[0-9]{9}$", val)
	defp is_field_valid?({:cid, _val}), do: true
	defp is_field_valid?({:hgt, val}) do
		{val, unit} = Integer.parse(val, 10)
		case unit do
			"cm" -> val |> between?(150, 193)
			"in" -> val |> between?(59, 76)
			____ -> false
		end
	end

	defp between?(num, min, max), do: min <= num and num <= max

end