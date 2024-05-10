options = [strict: [file: :string, day: :integer, part: :integer],aliases: [f: :file, d: :day, p: :part]]
{opts,_,_}= OptionParser.parse(System.argv(), options)

file = "./input/day#{opts[:day]}.txt"
module = String.to_atom("Elixir.Day#{opts[:day]}")
function = String.to_atom("part#{opts[:part]}")
apply(module, function, [file])
|> IO.puts
