require "samples/sample"

namespace :theme do
  desc "seed built-in theme"
  task seed_built_in_theme: :environment do
    p "==== start migration ===="
    ::Samples::Theme.new.load

    p "==== done migration ===="
  end
end
