class Map
  def self.from_file(file)
    new.tap do |map|
      file.each_line do |line|
        map.add_edge_from_string(line)
      end
    end
  end

  def add_edge_from_string(line)
    new_edge_caves = line.split('-').map do |cave_string|
      caves_by_name[cave_string.squish]
    end

    new_edge_caves.each do |start_cave|
      new_edge_caves.each do |end_cave|
        next if start_cave == end_cave
        start_cave.add_neighbor(end_cave)
      end
    end
  end

  def caves_by_name
    @caves ||= Hash.new do |hash, key|
      hash[key] = Cave.new(key)
    end
  end

  def start_cave
    @start_cave ||= caves_by_name['start']
  end

  def end_cave
    @end_cave ||= caves_by_name['end']
  end
end
