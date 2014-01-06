min_threads = ENV.fetch 'PUMA_MIN_THREADS', 8
max_threads = ENV.fetch 'PUMA_MAX_THREADS', 16

threads min_threads, max_threads
