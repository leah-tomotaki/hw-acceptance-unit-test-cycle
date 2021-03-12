# TL;DR: YOU SHOULD DELETE THIS FILE
#
# This file is used by web_steps.rb, which you should also delete
#
# You have been warned
module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

      when /^the (RottenPotatoes )?home\s?page$/ then '/movies'
      when /^the edit page for "(.*)" $/ then "/movies/#{Movie.find_by_title($1).id}/edit"
      # when /^the details page for (.*) $/ then "/movies/#{Movie.find_by_title($2).id}/"
    end
  end
end

World(NavigationHelpers)
