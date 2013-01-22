Meteor.publish "activities", ->
  Activities.find {}

Meteor.publish "userData", ->
  Meteor.users.find({_id: this.userId}, {fields: {'points': 1, 'gold_stars': 1}})

Meteor.users.allow
  update: (userId, docs, fields, modifier) ->
    ('points' in fields || 'gold_stars' in fields)
