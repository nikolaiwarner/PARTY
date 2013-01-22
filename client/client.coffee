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
    Session.set("earned_points", points)
    Meteor.users.update {_id: Meteor.userId()}, {$inc: {points: points}}, (error) ->
      unless error
        unless did_i_earn_a_gold_star( -> $('#you_got_a_gold_star_modal').modal('show') )
          $('#you_earned_some_points_modal').modal('show')


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
    Activities.insert data
    $('#new_activity_modal').modal('hide')

Template.modals.helpers
  earned_points: ->
    pluralize('point', Session.get("earned_points"))
  earned_points_icon: ->
    "&##{Session.get('earned_points') + 10111};"

Template.your_points.helpers
  count: ->
    my_points()
  points_till_next_gold_star: ->
    points = 10 - my_points()
    "#{points} more #{pluralize('point', points, false)}"

Template.your_gold_stars.helpers
  count: ->
    my_gold_stars()
  has_gold_stars: ->
    (my_gold_stars() > 0)

Template.your_gold_stars.events
  "click .spend_a_gold_star": (event) ->
    if my_gold_stars() > 0
      Meteor.users.update {_id: Meteor.userId()}, {$inc: {gold_stars: -1}}, (error) ->
        unless error
          $('#you_spent_a_gold_star_modal').modal('show')
