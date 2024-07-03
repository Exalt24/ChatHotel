#!/usr/bin/env bash
# exit on error
set -o errexit

# Install all required gems specified in Gemfile.lock
bundle install

# Precompile assets for production
bundle exec rails assets:precompile

# Clean up assets after precompilation (optional, but can be useful to reduce disk space usage)
bundle exec rails assets:clean

# Remove test files
echo "Cleaning up test files..."
rm -rf test/
rm -rf spec/

# Run database migrations
bundle exec rails db:migrate
