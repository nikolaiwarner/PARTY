Activities = new Meteor.Collection("activities")

my_gold_stars = ->
  if Meteor.user()
    Meteor.user().gold_stars || 0
  else
    0

my_points = ->
  if Meteor.user()
    Meteor.user().points || 0
  else
    0

did_i_earn_a_gold_star = ->
  if my_points() >= 10
    new_points = my_points() - 10
    Meteor.users.update {_id: Meteor.userId()}, {$set: {points: new_points}}
    Meteor.users.update {_id: Meteor.userId()}, {$inc: {gold_stars: 1}}
    true

pluralize = (string, count) ->
  if count != 1
    string = string + 's'
  "#{count} #{string}"
