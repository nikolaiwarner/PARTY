check_time = ->
  Session.set("recent_time", Date.now())

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

earned_points = ->
  pluralize('point', Session.get("earned_points"))

earned_points_icon = ->
  "&##{Session.get('earned_points') + 10111};"


Activities = new Meteor.Collection("activities")
Events = new Meteor.Collection("events")

Meteor.autosubscribe ->
  Meteor.subscribe "activities", Meteor.userId()
  Meteor.subscribe "events", Meteor.userId()
  Meteor.subscribe "userData"

Meteor.startup ->
  # Recheck date every 30 minutes
  check_time()
  setInterval check_time, moment.duration(30, 'minutes')._milliseconds


# activity list
Template.your_activities_list.helpers
  activities: ->
    Activities.find {userId: Meteor.userId()}

Template.your_activities_list.events
  "click .did_activity": (event) ->
    activity = @
    Session.set("earned_points", activity.points)
    Meteor.users.update {_id: Meteor.userId()}, {$inc: {points: activity.points}}, (error) ->
      unless error
        Events.insert
          userId: Meteor.userId()
          activity_id: activity._id
          date: Date.now()
        unless did_i_earn_a_gold_star( -> $('#you_got_a_gold_star_modal').modal('show') )
          window.toastr.success("Keep it going and earn a gold star!", "You've earned #{earned_points()}!")

  "click .remove_activity": (event) ->
    activity = @
    $(event.target).closest('tr').find('td').fadeOut 1000, ->
      Activities.remove activity._id


Template.activity_list_row.helpers
  points_string: ->
    pluralize('point', @points)
  last_event: ->
    if e = Events.findOne {activity_id: @_id}, {sort: {date: -1}}
      moment(e.date).fromNow()
  event_count: ->
    Events.find({activity_id: @_id}).count()
  completed_today_class: ->
    e = Events.findOne {activity_id: @_id}, {sort: {date: -1}}
    if Session.get("recent_time")
      if e && moment(e.date) > moment(Session.get("recent_time")).startOf('day')
        'completed_today'


# New Activity
Template.new_activity.events
  "click .new_activity .btn.save": ->
    data =
      userId: Meteor.userId()
      name: $('.new_activity .name').val()
      url: $('.new_activity .url').val()
      points: parseInt($('.new_activity .points').val(), 10)
    Activities.insert data
    $('#new_activity_modal').modal('hide')
    $('.new_activity .name, .new_activity .url').val('')
    $('.new_activity .points').val(1)

Template.your_points.helpers
  count: ->
    my_points()
  points_till_next_gold_star: ->
    points = 10 - my_points()
    "#{points} more #{pluralize('point', points, false)}"
  point_list: ->
    _.range my_points()
  point_list_till_next_gold_star: ->
    _.range(10 - my_points())

Template.your_gold_stars.helpers
  count: ->
    my_gold_stars()
  has_gold_stars: ->
    (my_gold_stars() > 0)
  star_list: ->
    _.range my_gold_stars()

Template.your_gold_stars.events
  "click .spend_a_gold_star": (event) ->
    if my_gold_stars() > 0
      Meteor.users.update {_id: Meteor.userId()}, {$inc: {gold_stars: -1}}, (error) ->
        unless error
          $('#you_spent_a_gold_star_modal').modal('show')
