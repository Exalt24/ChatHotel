# Precompile assets
echo "Precompiling assets..."
bin/rails assets:precompile

# Start the Rails server
echo "Starting Rails server..."
exec bin/rails s -e development