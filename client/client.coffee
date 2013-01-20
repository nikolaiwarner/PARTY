# activity list
Template.your_activities_list.activities = ->
  Activity.find {userId: Meteor.userId()}

Template.new_activity.events
  "click .new_activity .btn.save": ->

    data =
      userId: Meteor.userId()
      name: $('.new_activity .name').val()
      points: parseInt($('.new_activity .points').val(), 10)

    console.log data
    Activity.insert data

    $('#new_activity_modal').modal('hide')
