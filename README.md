# PastVu

PastVu gem is a Ruby wrapper for [PastVu API](https://docs.pastvu.com/en/dev/api). It allows convenient interaction with the API in your Ruby code.

[PastVu](https://pastvu.com) is an open-source online platform for gathering, geo-tagging, attributing and discussing retro photos. Its [repository](https://github.com/PastVu/pastvu) can be found on GitHub.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add pastvu

or add the following line to the Gemfile manually

    # gem "pastvu"

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install pastvu

and do not forget to require the gem in your code:

```ruby
require "pastvu"
```

## Usage

Refer to [PastVu API documentation](https://docs.pastvu.com/en/dev/api) for available interactions, parameters, parameter types and response examples.

### Scenario: Getting nearest photos

#### Step one - request data

```ruby
golden_gate_coordinates = [37.82,-122.469322]

# It sends photo.giveNearestPhotos request
# Returns a PhotoCollection instance on success
photo_collection = Pastvu.nearest_photos(geo: golden_gate_coordinates)

# Optional params, too, go as keyword arguments:
photo_collection = Pastvu.nearest_photos(
  geo: golden_gate_coordinates,
  except: 228481,
  limit: 12
)

# PastVu API does not allow requesting >30 nearest photos
# but you can skip the ones you have already requested
new_photo_collection = photo_collection.next

# The previous limit (12 in the case above or 30 if no limit was specified) defines how many photos the new collection gets
# It is possible to set a new limit in the argument (no more than 30!):
new_photo_collection = photo_collection.next(5)
```

#### Step two - work with data

##### Manipulate attributes:

```ruby
# The full response can be immediately transformed into JSON or Hash
photo_collection.to_json
photo_collection.to_hash

# On iteration pastvu gem extracts photo information into Photo object
photo_collection.each do |photo|
  # Photo attributes are available as methods:
  puts photo.title
  puts photo.year
  puts photo.geo
  # etc

  # Photo can be transformed into hash:
  hash = photo.to_hash
  puts hash["title"]
  puts hash["year"]
  puts hash["geo"]
  # etc

  # and into json:
  photo.to_json
end
```

##### Download photos:

```ruby
photo_collection.each_with_index do |photo, i|
  # All return download URL as String:
  photo.standard
  photo.original
  photo.thumb # or thumbnail

  # The path to a new photo must end with ".jpg" or ".jpeg"
  desired_path_to_photo = "awesome_photo_number_#{i + 1}.jpg"

  # All return File object:
  photo.download(desired_path_to_photo, :standard)
  photo.download(desired_path_to_photo, :original)
  photo.download(desired_path_to_photo, :thumb) # or :thumbnail
end
```

##### Request more data about the photo:

```ruby
photo_collection.each do |photo|
  # To make a request for comments:
  photo.comments # returns CommentCollection
  # See also the section on comments

  # To make a request for full photo information
  photo.reload # returns a new Photo object
  # See also the section on photo information
end
```

### Scenario: Getting photos inside geographical bounds

#### Step one - prepare request

PastVu API accepts geoJSON polygons and geoJSON multipolygons

```ruby
# use JSON string in the GeoJSON format:
paris_montmartre = '{"coordinates":[[[2.34218629483172,48.88623415508624],[2.34218629483172,48.88425956838617],[2.3449771858020085,48.88425956838617],[2.3449771858020085,48.88623415508624],[2.34218629483172,48.88623415508624]]],"type":"Polygon"}'

# or use hash in the GeoJSON format:
paris_montmartre = {
  "type" => "Polygon",
  "coordinates" => [
    [
      [
      2.34218629483172,
      48.88623415508624
      ],
      [
      2.34218629483172,
      48.88425956838617
      ],
      [
      2.3449771858020085,
      48.88425956838617
      ],
      [
      2.3449771858020085,
      48.88623415508624
      ],
      [
      2.34218629483172,
      48.88623415508624
      ]
    ]
  ]
}
```

#### Step two - request data

```ruby
# It sends photo.getByBounds request
# It returns BoundsResponse
bounds_response = Pastvu.by_bounds(
  geometry: paris_montmartre,
  z: 16
)
```

The response may contain clusters, photos, or both - see [API docs](https://docs.pastvu.com/en/dev/api)

```ruby
photo_collection = bounds_response.photos # returns PhotoCollection

cluster_collection = bounds_response.clusters # returns ClusterCollection
```

#### Step three - manipulate data

##### Photos

PhotoCollection and each photo object have almost all the same methods as discussed in the previous scenario section.

Note that PastVu API may send different photo data for by_bounds and nearest_photos requests. This, however, does not obstruct in-built convenience methods for downloading.

For instance:
```ruby
photo_collection.each do |photo|
  photo.original # will work
  photo.year2 # should work for by_bounds but might not work for nearest_photos
end

photo_collection.next # will not work for by_bounds
```

##### Clusters

On the [Pastvu website](https://pastvu.com), clusters are representations of multiple photos. Users see clusters when zooming out.

```ruby
# The full response can be immediately transformed into JSON or Hash
cluster_collection.to_json
cluster_collection.to_hash

cluster_collection.each do |cluster|
  # Cluster attributes are available as methods:
  puts cluster.c
  # etc

  # Cluster can be transformed into Hash
  hash = cluster.to_hash
  puts hash["c"]
  # etc

  # and into JSON
  cluster.to_json

  cluster.photo # returns Photo object corresponding to the clusters cover thumbnail
end
```

### Scenario: Getting full photo information

```ruby
  photo_cid = 5

  # It sends photo.giveForPage request
  # Returns informationResponse on success
  photo_information = Pastvu.photo_info(photo_cid)

  # informationResponse can be transformed into JSON and Hash
  photo_information.to_json
  photo_information.to_hash

  photo = photo_information.to_photo # returns Photo object

  # There is also a shorthand to return Photo object immediately instead of informationResponse
  photo = Pastvu.photo(photo_cid)
```

The created Photo object will respond to all the methods discussed previously but it tends to have more attributes. Finally, it is possible to request full information for any Photo object by calling `Photo#reload` on Photo instance, which returns a new Photo instance.

### Scenario: Getting commentaries for a photo

```ruby
photo_cid = 5

# It makes comment.giveForObj request
# It returns CommentCollection on success
comment_collection = Pastvu.comments(photo_cid)

comment_collection.users # returns hash with data about all the users who left a comment under the photo

comment_collection.each do |comment|
  # Comment attributes are available as methods
  puts cluster.user
  puts cluster.txt
  # etc

  # Cluster can be transformed into Hash
  hash = cluster.to_hash
  puts hash["user"]
  puts hash["txt"]
  # etc

  # and into JSON
  cluster.to_json


  comment.replies # returns Array containing  replies to the given comment
end
```

### Configuration

```ruby
Pastvu.configure do |c|

  c.host # "pastvu.com"
  c.path # "api2"
  c.user_agent # "Ruby PastVu Gem/#{VERSION}, #{RUBY_PLATFORM}, Ruby/#{RUBY_VERSION}"

  # Raise when API response is not of expected format
  c.ensure_successful_responses # "true"

  # Raise when supplied params are not of the required type
  c.check_params_type # "true"

  # Raise when supplied params are not of the required values
  c.check_params_value # "true"
end
```
## To do list

* Rework tests to use [VCR gem](https://github.com/vcr/vcr)
* Refactor tests

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/projecteurlumiere/pastvu.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
