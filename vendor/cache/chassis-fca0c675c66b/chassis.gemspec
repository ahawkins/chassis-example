# -*- encoding: utf-8 -*-
# stub: chassis 0.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "chassis"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["ahawkins"]
  s.date = "2014-04-21"
  s.description = "A collection of modules and helpers for building mantainable Ruby applications"
  s.email = ["adam@hawkins.io"]
  s.files = [".gitignore", "Gemfile", "LICENSE.txt", "README.md", "Rakefile", "chassis.gemspec", "examples/repo.rb", "lib/chassis.rb", "lib/chassis/circuit_panel.rb", "lib/chassis/core_ext/hash.rb", "lib/chassis/core_ext/string.rb", "lib/chassis/delegate.rb", "lib/chassis/dirty_session.rb", "lib/chassis/error.rb", "lib/chassis/faraday.rb", "lib/chassis/form.rb", "lib/chassis/heroku.rb", "lib/chassis/inflector.rb", "lib/chassis/initializable.rb", "lib/chassis/logger.rb", "lib/chassis/observable.rb", "lib/chassis/persistence.rb", "lib/chassis/rack/bouncer.rb", "lib/chassis/rack/builder_shim_patch.rb", "lib/chassis/rack/health_check.rb", "lib/chassis/rack/instrumentation.rb", "lib/chassis/rack/no_robots.rb", "lib/chassis/registry.rb", "lib/chassis/repo.rb", "lib/chassis/repo/base_repo.rb", "lib/chassis/repo/delegation.rb", "lib/chassis/repo/lazy_association.rb", "lib/chassis/repo/memory_repo.rb", "lib/chassis/repo/null_repo.rb", "lib/chassis/repo/pstore_repo.rb", "lib/chassis/repo/record_map.rb", "lib/chassis/repo/redis_repo.rb", "lib/chassis/strategy.rb", "lib/chassis/version.rb", "lib/chassis/web_service.rb", "test/chassis_test.rb", "test/circuit_panel_test.rb", "test/delegate_test.rb", "test/dirty_session_test.rb", "test/error_test.rb", "test/faraday_test.rb", "test/form_test.rb", "test/initializable_test.rb", "test/logger_test.rb", "test/observable_test.rb", "test/persistence_test.rb", "test/prox_test.rb", "test/rack/bouncer_test.rb", "test/rack/builder_patch_test.rb", "test/rack/health_check_test.rb", "test/rack/instrumentation_test.rb", "test/rack/no_robots_test.rb", "test/registry_test.rb", "test/repo/delegation_test.rb", "test/repo/lazy_association_test.rb", "test/repo/memory_repo_test.rb", "test/repo/null_repo_test.rb", "test/repo/pstore_repo_test.rb", "test/repo/redis_repo_test.rb", "test/repo/repo_tests.rb", "test/repo_test.rb", "test/strategy_test.rb", "test/test_helper.rb", "test/web_service_test.rb"]
  s.homepage = ""
  s.licenses = ["MIT"]
  s.rubygems_version = "2.2.2"
  s.summary = ""
  s.test_files = ["test/chassis_test.rb", "test/circuit_panel_test.rb", "test/delegate_test.rb", "test/dirty_session_test.rb", "test/error_test.rb", "test/faraday_test.rb", "test/form_test.rb", "test/initializable_test.rb", "test/logger_test.rb", "test/observable_test.rb", "test/persistence_test.rb", "test/prox_test.rb", "test/rack/bouncer_test.rb", "test/rack/builder_patch_test.rb", "test/rack/health_check_test.rb", "test/rack/instrumentation_test.rb", "test/rack/no_robots_test.rb", "test/registry_test.rb", "test/repo/delegation_test.rb", "test/repo/lazy_association_test.rb", "test/repo/memory_repo_test.rb", "test/repo/null_repo_test.rb", "test/repo/pstore_repo_test.rb", "test/repo/redis_repo_test.rb", "test/repo/repo_tests.rb", "test/repo_test.rb", "test/strategy_test.rb", "test/test_helper.rb", "test/web_service_test.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sinatra>, [">= 0"])
      s.add_runtime_dependency(%q<sinatra-contrib>, [">= 0"])
      s.add_runtime_dependency(%q<rack-contrib>, [">= 0"])
      s.add_runtime_dependency(%q<manifold>, [">= 0"])
      s.add_runtime_dependency(%q<prox>, [">= 0"])
      s.add_runtime_dependency(%q<harness>, [">= 0"])
      s.add_runtime_dependency(%q<harness-rack>, [">= 0"])
      s.add_runtime_dependency(%q<virtus>, [">= 0"])
      s.add_runtime_dependency(%q<virtus-dirty_attribute>, [">= 0"])
      s.add_runtime_dependency(%q<faraday>, ["~> 0.9.0"])
      s.add_runtime_dependency(%q<logger-better>, [">= 0"])
      s.add_runtime_dependency(%q<breaker>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.3"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rack-test>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_development_dependency(%q<redis>, [">= 0"])
    else
      s.add_dependency(%q<sinatra>, [">= 0"])
      s.add_dependency(%q<sinatra-contrib>, [">= 0"])
      s.add_dependency(%q<rack-contrib>, [">= 0"])
      s.add_dependency(%q<manifold>, [">= 0"])
      s.add_dependency(%q<prox>, [">= 0"])
      s.add_dependency(%q<harness>, [">= 0"])
      s.add_dependency(%q<harness-rack>, [">= 0"])
      s.add_dependency(%q<virtus>, [">= 0"])
      s.add_dependency(%q<virtus-dirty_attribute>, [">= 0"])
      s.add_dependency(%q<faraday>, ["~> 0.9.0"])
      s.add_dependency(%q<logger-better>, [">= 0"])
      s.add_dependency(%q<breaker>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.3"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rack-test>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
      s.add_dependency(%q<redis>, [">= 0"])
    end
  else
    s.add_dependency(%q<sinatra>, [">= 0"])
    s.add_dependency(%q<sinatra-contrib>, [">= 0"])
    s.add_dependency(%q<rack-contrib>, [">= 0"])
    s.add_dependency(%q<manifold>, [">= 0"])
    s.add_dependency(%q<prox>, [">= 0"])
    s.add_dependency(%q<harness>, [">= 0"])
    s.add_dependency(%q<harness-rack>, [">= 0"])
    s.add_dependency(%q<virtus>, [">= 0"])
    s.add_dependency(%q<virtus-dirty_attribute>, [">= 0"])
    s.add_dependency(%q<faraday>, ["~> 0.9.0"])
    s.add_dependency(%q<logger-better>, [">= 0"])
    s.add_dependency(%q<breaker>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.3"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rack-test>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<redis>, [">= 0"])
  end
end
