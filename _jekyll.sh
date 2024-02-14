#!/bin/bash
instructions() {
    sleep 18
    echo "=============================================="
    echo " Start browsing on http://localhost:4000"
    echo " or edit files in http://localhost:4000/admin"
    echo "=============================================="
}
# Uncomment if needed (codespaces shoud supply a Ruby)
# rbenv install --skip-existing
bundle
bundle exec jekyll serve
# instructions &
# bundle exec jekyll build
# bundle exec jekyll serve --incremental
