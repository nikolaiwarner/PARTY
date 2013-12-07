Handlebars.registerHelper 'times', (n, block) ->
  accum = ''
  for i in n
    accum += block.fn(i)
  accum
