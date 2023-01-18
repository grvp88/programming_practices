# frozen_string_literal: true

# require "byebug"

CONVERSION_TO_HIGHWAY_COST = 1

def file
  # @file ||= File.readlines(File.join(File.dirname(__FILE__), "mr_president_input.txt"))
  @file ||= @input.split("\n")
end

def mr_president_variables
  # @mr_president_variables ||= file.take(1)[0].split(" ")
  @mr_president_variables ||= file[0].split(" ")
end

# from 2nd line
def nodes
  @nodes = file.drop(1)
end

# N
def number_of_cities
  @number_of_cities ||= mr_president_variables[0].to_i
end

# M
def number_of_roads
  @number_of_roads ||= mr_president_variables[1].to_i
end

# K
def maximum_cost
  @maximum_cost ||= mr_president_variables[2].to_i
end

def build_adjacency_matrix
  adjacency_matrix = [].tap { |m| number_of_cities.times { m << Array.new(number_of_cities) } }
  nodes.map { |x| x.delete("\n").split(" ").map(&:to_i) }.each do |(city_from, city_to, maintance_cost)|
    adjacency_matrix[city_from - 1][city_to - 1] = maintance_cost + CONVERSION_TO_HIGHWAY_COST
    adjacency_matrix[city_to - 1][city_from - 1] = maintance_cost + CONVERSION_TO_HIGHWAY_COST
  end
  adjacency_matrix
end

def find_cheapest_road(adjacency_matrix, visited_cities, number_of_cities)
  available_nodes = (0..number_of_cities - 1).to_a.reject { |city_index| visited_cities.include?(city_index + 1) }

  cheapest_roads = available_nodes.each_with_object([]) do |city_index, auxiliar|
    get_roads(adjacency_matrix, city_index).select { |_, other_city_index| visited_cities.include?(other_city_index + 1) }.each do |cost, other_city_index|
      auxiliar << { start: city_index + 1, end: other_city_index + 1, cost: cost }
    end
  end
  cheapest_roads.min_by { |road| road[:cost] }
end

def get_roads(adjacency_matrix, city_index)
  adjacency_matrix[city_index].each_with_index.reject { |road, _index| road.nil? }
end

def select_first_road(adjacency_matrix)
  starting_city = 1
  cheapest_roads = get_roads(adjacency_matrix, 0).each_with_object([]) do |(road, index), all_roads|
    all_roads << { start: starting_city, end: index + 1, cost: road }
  end
  # byebug
  cheapest_roads.min_by { |a| a[:cost] }
end

def unvisited_cities
  (1..number_of_cities).to_a - @visited_cities
end

@input ||= gets("\n\n").chomp
adjacency_matrix = build_adjacency_matrix
first_road = select_first_road(adjacency_matrix)
@visited_cities = [first_road[:start], first_road[:end]]
@roads = first_road[:cost] <= maximum_cost ? [first_road] : []

until unvisited_cities.empty?
  cheapest_road = find_cheapest_road(adjacency_matrix, @visited_cities, number_of_cities)
  # byebug
  if @roads.inject(0) { |sum, road| sum + road[:cost] } + cheapest_road[:cost] <= maximum_cost
    @roads << cheapest_road
    @visited_cities << cheapest_road[:start]
  else
    break
  end
end
# puts "Roads: #{@roads}"
# puts "Final cost #{@roads.inject(0) { |sum, road| sum + road[:cost] }}"
puts @roads.count > 0 ? @roads.count : -1

