defmodule Input do
	def read(day_num) do
		{:ok, input} = File.read("./lib/day#{day_num}/input")
		String.split(input, "\n")
	end
end