def parse_gff_line(line)

  fields = line.strip.split("\t")

  scaffold_name = String fields[0]
  source        = String fields[1]
  type          = String fields[2]
  start         = Integer fields[3] rescue nil
  stop          = Integer fields[4] rescue nil
  score         = Float fields[5] rescue nil
  strand        = String fields[6]
  frame         = Integer fields[7] rescue nil
  info          = String fields[8]

  { scaffold_name: scaffold_name,
    start: start,
    source: source,
    stop: stop,
    strand: strand,
    score: score,
    type: type,
    info: info }

end
