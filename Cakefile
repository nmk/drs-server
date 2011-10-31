{print} = require 'sys'
{spawn} = require 'child_process'

option '-v', '--verbose', 'use verbose reporting'

task 'spec', 'Run all specs', (options) ->

  defaultOptions = ['--coffee', 'spec']
  defaultOptions.push '--verbose' if options.verbose

  spec = spawn 'jasmine-node', defaultOptions
  spec.stdout.on 'data', (data) -> print data.toString()
  spec.stderr.on 'data', (data) -> print data.toString()

task 'run', 'Run DRS server', ->
  server = spawn 'coffee', ['app.coffee']
  server.stdout.on 'data', (data) -> print data.toString()
  server.stderr.on 'data', (data) -> print data.toString()
