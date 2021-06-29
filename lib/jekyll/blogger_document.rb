module Jekyll
  class BloggerDocument < Document
    require 'active_support/core_ext/hash/keys'

    def initialize(post, relations = {})
      @post = post
      @category = relations[:blog_url][/^https?:\/\/([^.]+)\./, 1]

      super(post.url.sub(/.*\//, "#{@category}/_#{relations[:collection].label}/"), relations)
    end

    def source_file_mtime
      Time.parse(@post.updated)
    end

    def read_content(**opts)
      self.content = @post.content
      merge_data!(@post.to_h.deep_stringify_keys, source: 'Blogger')
      data.delete('content')
      merge_data!({
        'categories' => [@category],
        'date' => @post.published,
        'draft' => data['status'].eql?('DRAFT'),
        'excerpt_separator' => '<!--more-->',
        'tags' => @post.labels
      }, source: 'Blogger')
    end
  end
end
