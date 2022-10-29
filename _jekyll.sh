#!/bin/bash
instructions() {
    sleep 18
    echo "=============================================="
    echo " Start browsing on http://localhost:4000"
    echo " or edit files in http://localhost:4000/admin"
    echo "=============================================="
}
rbenv install --skip-existing
bundle
bundle exec jekyll build
bundle exec jekyll serve --livereload --verbose --incremental
# instructions &
# bundle exec jekyll serve --incremental
