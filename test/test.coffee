should = require 'should'
path = require 'path'
coffeescript = require 'coffee-script'
fs = require 'fs'
accord = require 'accord'
axis = require '../'
cssparse = require 'css-parse'

# utilities

test_path = path.join(__dirname, 'fixtures')

compile = (p) ->
  accord.load('scss').renderFile(p)

match_expected = (out, p, done) ->
  try
    expected_path = path.join(path.dirname(p), path.basename(p, '.scss')) + '.css'
    if not fs.existsSync(expected_path) then throw '"expected" file doesnt exist'
    expected_contents = fs.readFileSync(expected_path, 'utf8')
    cssparse(out).should.eql(cssparse(expected_contents))
  catch err
    return done(err)
  done()

compile_and_match = (p, done) ->
  compile(p)
    .done(((out) => match_expected(out.result, p, done)), done)

describe 'api', ->

  before ->
    @pkg = require('../package.json')

  it 'exposes the library path', ->
    axis.path.should.match(/axis/)
  it 'exposes the correct version', ->
    axis.version.should.eql(@pkg.version)
  it 'exposes the library name', ->
    axis.libname.should.eql(@pkg.name)
