Meteor.publish "activities", ->
  Activities.find {}

Meteor.publish "userData", ->
  Meteor.users.find({_id: this.userId}, {fields: {'points': 1, 'tokens': 1}})

Meteor.users.allow
  update: (userId, docs, fields, modifier) ->
    ('points' in fields || 'tokens' in fields)
