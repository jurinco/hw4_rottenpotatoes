Given /^the following movies exist:$/ do |movies_table|
   movies_table.hashes.each do |movie|
      Movie.create!(movie)
          
      # each returned element will be a hash whose key is the table header.
      # you should arrange to add that movie to the database here.
   end
end

Then /^the director of "([^"]*)" should be "([^"]*)"$/ do |arg1, arg2|
   assert page.body =~ /#{arg1}.+Director.+#{arg2}/m
   # express the regexp above with the code you wish you had
end


# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  #  flunk "Unimplemented"
  titles = page.all("table#movies tbody tr td[1]").map {|t| t.text}
  assert titles.index(e1) < titles.index(e2)
  #assert_match(/#{e1}.+#{e2}/, page.body)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  if uncheck == "un"
    rating_list.split(',').each {|x| step %{I uncheck "ratings_#{x}"}}
  else
    rating_list.split(',').each {|x| step %{I check "ratings_#{x}"}}
  end
end

Then /I should (not )?see movies rated: (.*)/ do |notsee, rating_list|
  ratings = rating_list.split(",")
  if notsee
    ratings.each do |x| 
      page.find(:xpath, "//table[@id=\"movies\"]/tbody[count(tr[td = \"#{x}\"]) = 0]")
    end
  else
    db_size = filtered_movies = Movie.find(:all, :conditions => {:rating => ratings}).size
    page.find(:xpath, "//table[@id=\"movies\"]/tbody[count(tr) = #{db_size} ]")
  end
end

Then /I should see (none|all) of the movies/ do |filter|
  db_size = 0
  db_size = Movie.all.size if filter == "all"
  page.find(:xpath, "//table[@id=\"movies\"]/tbody[count(tr) = #{db_size} ]")
end


=begin
module Enumerable
  def sorted?
    each_cons(2).all? { |a, b| (a <=> b) <= 0 }
  end
end


Then /^the movies should be sorted by (.+)$/ do |sort_field|
	col_index = case sort_field
	when "title" then 0
	when "release_date" then 2
	else raise ArgumentError
	end
	
	values = all("table#movies tbody tr").collect { 
		|row| 
		row.all("td")[col_index].text 
	}
	
	assert values.sorted?
end
=end
