exec = require('child_process').exec
rsvp = require 'rsvp'
exec = require('child_process').exec
exec = rsvp.denodeify require('child_process').exec

module.exports = (cb)->
  one = false
  exec('git init')
    .then ->
      exec 'git add .'
    .then ->
      exec 'git commit -m "Initial commit"'
    .then ->
      gutil.log gutil.colors.green 'Successfully initialized git.'
    .catch (err)->
      gutil.log gutil.colors.red err
    .finally cb
  undefined

