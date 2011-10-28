fs      = require 'fs'
{print} = require 'sys'
{spawn} = require 'child_process'

spec = ->
  options = ['spec', '--coffee']
  spec = spawn 'jasmine-node', options
  spec.stdout.on 'data', (data) -> print data.toString()
  spec.stderr.on 'data', (data) -> print data.toString()

task 'run', 'Run DRS server', ->
  invoke 'generate:parsers'

  server = spawn 'coffee', ['app.coffee']
  server.stdout.on 'data', (data) -> print data.toString()
  server.stderr.on 'data', (data) -> print data.toString()
