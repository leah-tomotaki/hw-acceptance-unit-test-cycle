
Given (/the following movies exist/) do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create(movie)
  end
end

Then (/(.*) seed movies should exist/) do | n_seeds |
  Movie.count.should be n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then (/I should see "(.*)" before "(.*)"/) do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  if page.body.respond_to? :should
    page.body.should =~ /#{e1}.*#{e2}/m 
  else
    assert_match(/#{e1}.*#{e2}/m , page.body)
  end
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When (/I (un)?check the following ratings: (.*)/) do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  for rating in rating_list.split(', ')
    if(uncheck)
      steps %Q{
        When I uncheck "#{rating}"
      }
    else 
      steps %Q{
        When I check "#{rating}"
      }
    end
  end
end

Then (/I should see all the movies/) do
  # Make sure that all the movies in the app are visible in the table
  rows = page.all('#movies tbody tr').size
  expect(rows).to eq Movie.count

end

Then (/the Rating column should (not )?contain the following: (.*)/) do |not_contain, content_list|
  # this assumes the rating column is always the 2nd column in the table
  content_list = content_list.split(', ')
  
  page.all("#movies tbody tr > td:nth-child(2)").each do |td|
    if not_contain
      expect(content_list).not_to include(td.text)
    else
      expect(content_list).to include(td.text)
    end
  end
end

# Then /the director of (.*) should be (.*)/ do |movie_title, director| 
  
# end