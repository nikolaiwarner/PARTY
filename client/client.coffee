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
    did_i_earn_a_gold_star()

Template.activity_list_row.helpers
  points_string: (points)->
    pluralize('point', points)


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
  points_till_next_gold_star: ->
    10 - my_points()

Template.your_gold_stars.helpers
  count: ->
    my_gold_stars()
  has_gold_stars: ->
    (my_gold_stars() > 0)

Template.your_gold_stars.events
  "click .spend_a_gold_star": (event) ->
    if my_gold_stars() > 0
      Meteor.users.update {_id: Meteor.userId()}, {$inc: {gold_stars: -1}}
