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

did_i_earn_a_gold_star = (callback) ->
  if my_points() >= 10
    Meteor.users.update {_id: Meteor.userId()}, {$inc: {points: -10, gold_stars: 1}}, (error) ->
      unless error
        callback()
    true

pluralize = (string, count, show_count=true) ->
  if count != 1
    string = string + 's'
  if show_count
    "#{count} #{string}"
  else
    string
