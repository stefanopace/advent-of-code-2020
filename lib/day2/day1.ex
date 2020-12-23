defmodule Day2 do
	def between_range(num, min, max) do
		num >= min and num <= max
	end

	def part1 do
		Input.read(2)
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
end