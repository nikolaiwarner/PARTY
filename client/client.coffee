Meteor.subscribe("activities")


Meteor.autosubscribe ->
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
    if Meteor.user()
      Meteor.user().points || 0

Template.your_tokens.helpers
  count: ->
    if Meteor.user()
      Meteor.user().tokens || 0
