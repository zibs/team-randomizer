require "sinatra"
require "sinatra/reloader"
# Write a Sinatra app that allows the user to enter a list of names separated by commas and enter the number of teams. Upon hitting "submit" the app should display teams with random members in each of even numbers. If the total number of names to choose from is odd, one team may have one fewer member.
enable :sessions

get "/" do
  erb :index, layout: :application
end

post "/" do
  @guys = params[:names].split(", ")
  @names = params[:names].split(", ").shuffle
  @number = params[:num].to_i
  params[:names].empty? || @number == 0 ? @msg = "ERROR" : calculate_teams(params[:team])
  erb :index, layout: :application
end

  private

      def calculate_teams(params)
        case params
        when "of_team"
           randomize_number_of_teams(@names, @number)
        when "per_team"
          randomize_numbers_per_team(@names, @number)
        end
      end

      def number_of_teams(team_array, number_of_teams)
            randomize_uneven_group(team_array, number_of_teams)
      end

      def numbers_per_teams(team_array, number_of_teams)
        if team_array.length < number_of_teams
          @error_message = "Numbers per teams cannot be bigger than people!"
        else
          randomize(team_array, number_of_teams)
        end
      end

      def randomize_numbers_per_team(team_array, num_per_team)
        session[:teams] = team_array.each_slice(num_per_team).to_a
      end

      def randomize_number_of_teams(team_array, number_of_teams)
        teams = team_array.group_by.each_with_index do |team, index|
         index % number_of_teams
        end
        session[:teams] = teams.values
      end
      # so group by with each index is going to go through the array by index and group together the values (the names) of that index by their mod numberofteams. So if we have six names and want four teams: on the first loop, index is 0, name is "eli", and the result of 0 % 4 is 0. So "eli" goes into the HASH with a KEY of 0. The next loop is i = 1, name is "mark", 1 % 4 is 1, so 'mark' goes into the HASH KEY 1. This continues until we get to index 4 where INDEX MOD 4 == 0 and so it goes into HASH KEY 0 etc.

# each with index: Calls block with two arguments, the item (elem) and its index, for each item in enum. Given arguments are passed through to each().

#group_by: Groups the collection by result of the block. Returns a hash where the keys are the evaluated result from the block and the values are arrays of elements in the collection that correspond to the key.

# for each element, group by will execute the block and put the RESULTING VALUE of the BLOCK as A HASH KEY of
# the new hash.
# session[:teams] = (1..team_array.length).group_by {|i| i % number_of_teams }.values
