{print} = require 'sys'
{spawn} = require 'child_process'

task 'spec', 'Run all specs', ->
  spec = spawn 'jasmine-node', ['--coffee', 'spec']
  spec.stdout.on 'data', (data) -> print data.toString()
  spec.stderr.on 'data', (data) -> print data.toString()

task 'run', 'Run DRS server', ->
  server = spawn 'coffee', ['app.coffee']
  server.stdout.on 'data', (data) -> print data.toString()
  server.stderr.on 'data', (data) -> print data.toString()
