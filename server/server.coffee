Activities = new Meteor.Collection("activities")
Events = new Meteor.Collection("events")

Meteor.publish "activities", (userId) ->
  Activities.find {userId: userId}, {sort: {name: 1}}

Meteor.publish "events", (userId) ->
  Events.find {userId: userId}

Meteor.publish "userData", ->
  Meteor.users.find({_id: this.userId}, {fields: {'points': 1, 'gold_stars': 1}})

Meteor.users.allow
  update: (userId, docs, fields, modifier) ->
    if 'points' in fields
      change = modifier['$inc']['points']
      (change > 0 && change <= 10 || change == -10)
    else if 'gold_stars' in fields
      (Meteor.user().gold_stars > 0)

Activities.allow
  insert: (userId, doc) ->
    if userId && doc.userId == userId
      (doc.points > 0 && doc.points <= 10)
  remove: (userId, doc) ->
    doc.userId == userId

Events.allow
  insert: (userId, doc) ->
    userId && doc.userId == userId
