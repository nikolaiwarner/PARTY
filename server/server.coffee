Meteor.publish "activities", ->
  Activities.find {}

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
