fs      = require 'fs'
{print} = require 'sys'
{spawn} = require 'child_process'

build = (watch=false) ->
  options = ['-c', 'lib', 'public/javascripts']
  options.unshift '-w' if watch

  coffee = spawn 'coffee', options
  coffee.stdout.on 'data', (data) -> print data.toString()
  coffee.stderr.on 'data', (data) -> print data.toString()

spec = ->
  options = ['spec', '--coffee']
  spec = spawn 'jasmine-node', options
  spec.stdout.on 'data', (data) -> print data.toString()
  spec.stderr.on 'data', (data) -> print data.toString()

task 'build', 'Compile CoffeeScript source files', ->
  build()

task 'watch', 'Recompile CoffeeScript source files when modified', ->
  build true

task 'spec', 'Run Jasmine-Node', ->
  build()
  spec()

task 'run', 'Run DRS server', ->
  build(true)

  server = spawn 'node', ['app.js']
  server.stdout.on 'data', (data) -> print data.toString()
  server.stderr.on 'data', (data) -> print data.toString()

