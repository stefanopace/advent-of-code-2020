defmodule Day2 do
	defp between_range(num, min, max) do
		num >= min and num <= max
	end
	@doc """
	## Examples
		iex> Input.read(2) |> Day2.part1
		416
	"""
	def part1(input) do
		input
		|> Enum.map(fn line -> 
			[_all, min, max, char, password] = Regex.run(~r"(.*)-(.*) (.): (.*)", line)
			{min, _rest} = Integer.parse(min)
			{max, _rest} = Integer.parse(max)
			{min, max, char, password}
		end)
		|> Enum.filter(fn {min, max, char, password} -> 
			String.graphemes(password)
			|> Enum.count(fn c -> c == char end)
			|> between_range(min, max)
		end)
		|> Enum.count
	end

	@doc """
	## Examples
		iex> Input.read(2) |> Day2.part2
		688
	
		iex> ["1-3 a: abcde", "1-3 b: cdefg", "2-9 c: ccccccccc"] |> Day2.part2
		1
	"""
	def part2(input) do
		input
		|> Enum.map(fn line -> 
			[_all, first, second, char, password] = Regex.run(~r"(.*)-(.*) (.): (.*)", line)
			{first, _rest} = Integer.parse(first)
			{second, _rest} = Integer.parse(second)
			{first, second, char, password}
		end)
		|> Enum.filter(fn {first, second, char, password} -> 
			[String.at(password, first - 1), String.at(password, second - 1)]
			|> Enum.count(&(&1 == char))
			|> Kernel.==(1)
		end)
		|> Enum.count
	end
end