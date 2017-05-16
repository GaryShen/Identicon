## Installation

clone this project, build gem

    $ cd Project && rake build

install the gem:

    $ gem install pkg/utils-0.1.0.gem

## Usage

    Utils::Identicon.new(name, image_path).generate

```ruby
require 'Utils'

Utils::Identicon.new('tim', '//Users/garyshen/Desktop').generate
```