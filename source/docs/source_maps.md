# Source maps

Source maps are available (on current stable release, v0.6.x) even without explicit support from Sprockets in a sort of hackish way.

_As such even if they generally work fine there are some limitations and edge case issues._

> ##### Note on `master` branch
> Currently on master sourcemaps are work-in-progress and probably will integrate with the upcoming Sprockets 4 that has integrated support for them.


#### Processor `source_map_enabled` flag
To enable sourcemaps in the Sprockets processor you need to turn on the relative flag:

```ruby
Opal::Processor.source_map_enabled = true # default
```


#### Sprockets debug mode

The  sourcemaps only work with Sprockets in debug mode because they are generated just for single files.


## Enable source maps

### in Rails

Rails has debug mode already enabled in development environment with the following line from `config/environments/development.rb`:

```ruby
# Debug mode disables concatenation and preprocessing of assets.
# This option may cause significant delays in view rendering with a large
# number of complex assets.
config.assets.debug = true
```

`opal-rails` also enables sourcemaps in development so with the standard setup you ready to go.

### in Opal::Server / Opal::Environment

Debug mode should be on by default.

