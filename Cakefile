fs = require "fs"
{print} = require "sys"
{spawn, exec} = require "child_process"

build = (watch, callback) ->
  if typeof watch is "function"
    callback = watch
    watch = false
  options = [ "-c", "-o", "lib", "src" ]
  coffee = spawn "coffee", options

  coffee.stdout.on "data", (data) -> print data.toString()
  coffee.stderr.on "data", (data) -> print data.toString()
  coffee.on "exit", (status) -> callback?() if status is 0

task "build", "Compile CoffeScript source files", ->
  build()

task "test", "Run the test suite", ->
  build ->
    process.env["RUBYOPTS"] = "-rubygems"
    process.env["NODE_ENV"] = "test"
    require.paths.unshift __dirname + "/lib"

    {reporters} = require "nodeunit"
    process.chdir __dirname
    reporters.default.run ["test"]
