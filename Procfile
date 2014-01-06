web: bundle exec puma -C "config/puma.rb" -p $PORT
sidekiq: bundle exec sidekiq -r "$(pwd)/app.rb" -c ${PUMA_MAX_THREADS:-4}
