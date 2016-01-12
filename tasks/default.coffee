sync = (require 'gulp-sync') gulp
PROP = require '../lib/config'

module.exports = {
  deps: sync.sync PROP.getDefaultTaskList()
}
