Activities = new Meteor.Collection("activities")

my_tokens = ->
  if Meteor.user()
    Meteor.user().tokens || 0
  else
    0

my_points = ->
  if Meteor.user()
    Meteor.user().points || 0
  else
    0

did_i_earn_a_token = ->
  if my_points() >= 10
    new_points = my_points() - 10
    Meteor.users.update {_id: Meteor.userId()}, {$set: {points: new_points}}
    Meteor.users.update {_id: Meteor.userId()}, {$inc: {tokens: 1}}
    true
