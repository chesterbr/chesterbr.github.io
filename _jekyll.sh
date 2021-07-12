#!/bin/bash
instructions() {
    sleep 18
    echo "=============================================="
    echo " Start browsing on http://localhost:4000"
    echo " or edit files in http://localhost:4000/admin"
    echo "=============================================="
}
rbenv install
bundle
bundle exec jekyll build
instructions &
bundle exec jekyll serve --incremental
