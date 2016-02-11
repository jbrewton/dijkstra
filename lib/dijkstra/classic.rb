require 'yaml'

module Dijkstra
  class Classic
    Vertex = Struct.new(:point, :dist, :prev, :neighbors)

    def initialize(graph_file, start_node, target_node)
      # Make sure we have the expected arguments
      expected_format = "dijkstra graph_file start_node target_node (dijkstra file.txt A B)"
      raise "Expecting graph file - #{expected_format}" if graph_file.nil?
      raise "Expecting start node - #{expected_format}" if start_node.nil?
      raise "Expecting target node - #{expected_format}" if graph_file.nil?
      @graph_file = graph_file
      @start_node = start_node
      @target_node = target_node

      # Holds references to the discovered vertices
      @vertices = Hash.new

      # "Queue" to hold untraversed vertices
      @unvisited_vertices = Hash.new

      # Setup the graph and vertices
      create_graph_struct
    end

    def solve
      # Start with the start_node
      current_node = @unvisited_vertices.delete @start_node
      current_node.dist = 0

      # Apply algorithm      
      while !@unvisited_vertices.empty?
        current_node.neighbors.each do |neighbor, neighbor_distance|
          alt = current_node.dist + neighbor_distance
          if alt < @vertices[neighbor].dist
            @vertices[neighbor].dist = alt
            @vertices[neighbor].prev = current_node.point
          end
        end

        min_dist_node = @unvisited_vertices.min_by{|k, v| v.dist} # [1] is the vertex, [0] key 
        current_node = @unvisited_vertices.delete min_dist_node[0]
      end

      # Back track to get the shortest path
      shortest_sequence = Array.new
      current_target = @vertices[@target_node]
      while !current_target.prev.nil?
        shortest_sequence << current_target
        current_target = @vertices[current_target.prev]
      end
      shortest_sequence << @vertices[@start_node]

      result = "Shortest path is [#{shortest_sequence.reverse.map{|x| x.point}.join(',')}] with total cost #{@vertices[@target_node].dist}"
    end

    private 

    def create_graph_struct
      begin
        # Read the file and convert it into a hash
        IO.foreach(@graph_file) do |line|
          # Using YAML parser to convert "[A,B,1]" into array for assignment
          parsed_line = YAML.load line.strip
          
          (start, destination, distance) = parsed_line
          
          #convert numbers to strings for hashing in the event the points are numeric
          start = start.to_s
          destination = destination.to_s
          # check for bad data
          raise "bad data set [#{start}, #{destination}, #{distance}]" if [start, destination, distance].map(&:nil?).include?(true)
          
          # New vertex or add neighbor to existing one
          v1 = @vertices[start] ||= Vertex.new(start, Float::INFINITY, nil, Array.new)
          v1.neighbors << [destination, distance]
          
          @unvisited_vertices[start] = v1

          # Ensure destination verticies are set to infinity
          v2 = @unvisited_vertices[destination] = @vertices[destination] ||= Vertex.new(destination, Float::INFINITY, nil, Array.new)
        end
      rescue => error
        puts "Logging some error reading file: #{error.message}"
        raise error # can't gracefully continue at this point
      end
    end
  end
end
