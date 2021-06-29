# jekyll-blogger-generator

[![Build Status](https://travis-ci.com/dsusco/jekyll-blogger-generator.svg?branch=main)](https://travis-ci.com/dsusco/jekyll-blogger-generator) [![Gem Version](https://badge.fury.io/rb/jekyll-blogger-generator.svg)](https://badge.fury.io/rb/jekyll-blogger-generator)

A Blogger generator for Jekyll. Blogger posts from one or more blogs are fetched and added to your site's posts.

## Installation

Add the gem to the `jekyll_plugins` group in the site's Gemfile:

    group :jekyll_plugins do
      gem 'jekyll-blogger-generator'
    end

And then bundle:

    $ bundle

## Usage

This gem uses the Blogger API V3 to fetch posts from a blog. You'll need an API key (click the "Get a Key" button on the [Using the API](https://developers.google.com/blogger/docs/3.0/using) page) in order to use it. Currently the gem does not support OAuth 2.0 authorization.

The blog's URL is used to categorize its posts (e.g. `http://some-blog.blogspot.com/` posts are given the category `some-blog`). From there front matter defaults can be set by scoping on the posts via the path of the blog's URL. Additionally, each post gets all the properties from the API response put into its YAML front matter, with Blogger labels also being used as Jekyll post tags, and the Blogger published date being used as the Jekyll post's date.

## Configuration

Configuration options are added to the `_config.yml` file like this:

    blogger:
      key: <some-key>
      url: http://some-blog.blogspot.com/
      list_post_parameters:
        max_results: 500
      urls:
        - http://another-blog.blogspot.com/
        -
          url: http://yet-another-blog.blogspot.com/
          list_post_parameters:
            max_results: 100

The options are:

### `key`

The API key used to get the Blogger blogs and their posts. This is **required**.

### `url`

The URL of the Blogger blog.

### `list_post_parameters`

A hash of additional parameters to pass to the [list posts API call](https://developers.google.com/blogger/docs/3.0/reference/posts/list). The paremter names need to be underscored, CamelCase will not work (e.g. `max_results` not `maxResults`).

### `urls`

An array of strings or hashes. If a string is found it's taken to be a Blogger blog's URL and posts are fetched with the `list_post_parameters` option above. If a hash is found its `url` key is taken to be a Blogger blog's URL. If it has a `list_post_parameters` key these are used solely for fetching the posts of this blog, otherwise the main `list_post_parameters` option from above is used.

## Contributing

1. Fork `https://github.com/dsusco/jekyll-blogger-generator`
2. Create a branch (`git checkout -b new-feature`)
3. Commit the changes (`git commit -am 'Added a new feature'`)
4. Push the branch (`git push origin new-feature`)
5. Create a pull request
