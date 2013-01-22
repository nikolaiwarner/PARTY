Meteor.autosubscribe ->
  Meteor.subscribe("activities")
  Meteor.subscribe("userData")

# activity list
Template.your_activities_list.helpers
  activities: ->
    Activities.find {userId: Meteor.userId()}

Template.your_activities_list.events
  "click .did_activity": (event) ->
    points = parseInt($(event.currentTarget).data('points'), 10)
    console.log points
    Meteor.users.update {_id: Meteor.userId()}, {$inc: {points: points}}
    did_i_earn_a_token()





# New Activity
Template.new_activity.events
  "click .new_activity .btn.save": ->
    data =
      userId: Meteor.userId()
      name: $('.new_activity .name').val()
      points: parseInt($('.new_activity .points').val(), 10)
    console.log data
    Activities.insert data
    $('#new_activity_modal').modal('hide')



Template.your_points.helpers
  count: ->
    my_points()



Template.your_tokens.helpers
  count: ->
    my_tokens()

Template.your_tokens.events
  "click .spend_a_token": (event) ->
    if my_tokens() > 0
      Meteor.users.update {_id: Meteor.userId()}, {$inc: {tokens: -1}}
