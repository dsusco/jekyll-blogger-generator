module Jekyll
  class BloggerGenerator < Generator
    require 'active_support/core_ext/hash/keys'
    require 'google/apis/blogger_v3'

    def initialize(config = {})
      @config = config
      @blogger = Google::Apis::BloggerV3::BloggerService.new
      @blogger.key = blogger_config['key']
      super
    end

    def generate(site)
      read_blog(
        site,
        @blogger.get_blog_by_url(blogger_config['url']),
        blogger_config['list_post_parameters']
      ) if blogger_config['url']

      blogger_config['urls'].each do |url|
        if url.is_a?(Hash)
          read_blog(site, @blogger.get_blog_by_url(url['url']), url['list_post_parameters'] || blogger_config['list_post_parameters'])
        else
          read_blog(site, @blogger.get_blog_by_url(url), blogger_config['list_post_parameters'])
        end
      end if blogger_config['urls']
    end

    private

      def blogger_config
        @blogger_config ||= @config['blogger'] || {}
      end

      def read_blog(site, blog, list_post_parameters = {})
        parameters = {
          max_results: 500
        }.merge(list_post_parameters || {}).deep_symbolize_keys

        loop do
          list_posts = @blogger.list_posts(blog.id, **parameters)

          list_posts.items.each do |post|
            doc = BloggerDocument.new(post, site: site, collection: site.posts, blog_url: blog.url)
            doc.read
            site.posts.docs << doc
          end

          break if (parameters[:page_token] = list_posts.next_page_token).nil?
        end
      end
  end
end
