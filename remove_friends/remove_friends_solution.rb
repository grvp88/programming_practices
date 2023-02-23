def read_input
    # puts "Insert T number of test cases:"
    @input ||= gets("\n\n").chomp
  
    string_lines = @input.split("\n")
    number_of_test = string_lines[0]
    i = 1
    number_of_test.to_i.times do |value|
      # puts "Insert N, the number of friends currently has and K ,the number of friends decides to delete."
      second_line = string_lines[i]
      # puts "Insert popularity of her friends separated by space."
      third_line = string_lines[i + 1]
      number_of_friends, friends_to_delete, popularity_variables = set_variables(second_line, third_line)
  
      delete_friends(friends_to_delete, number_of_friends, popularity_variables)
      i += 2
    end
  end
  
  def set_variables(second_line, third_line)
    # N
    number_of_friends = second_line.split(' ')[0].to_i
    # K
    friends_to_delete = second_line.split(' ')[1].to_i
    # popularity array
    popularity_variables = third_line.split(' ')
    return number_of_friends, friends_to_delete, popularity_variables
  end
  
  def delete_friends(friends_to_delete, number_of_friends, popularity_variables)
    z = 0
    friends_popularity = popularity_variables.map(&:to_i)
    while z < friends_to_delete
      delete_friend = false
      n = 0
      while n < number_of_friends
        if friends_popularity[n] < friends_popularity[n + 1]
          friends_popularity.delete_at(n)
          delete_friend = true
          break
        end
        n += 1
      end
      if delete_friend == false
        friends_popularity.delete_at(n)
      end
      z += 1
    end
    friends_popularity.each do |value|
      print value
      print ' '
    end
      puts
  end
  
  read_input
  
  