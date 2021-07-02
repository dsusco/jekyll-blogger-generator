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
      urls = [] << blogger_config['url'] << blogger_config['urls']

      urls.flatten.compact.each do |url|
        blog = @blogger.get_blog_by_url(url['url'] || url)

        create_pages(site, blog, url['list_page_parameters'])
        create_posts(site, blog, url['list_post_parameters'])
      end
    end

    private

      def blogger_config
        @blogger_config ||= @config['blogger'] || {}
      end

      def create_pages(site, blog, list_page_parameters)
        list_page_parameters = blogger_config['list_page_parameters'] if list_page_parameters.nil?
        list_page_parameters = {} if list_page_parameters.nil?

        if list_page_parameters
          parameters = {
          }.merge(list_page_parameters).deep_symbolize_keys

          dir = blog.url[/^https?:\/\/([^.]+)\./, 1]

          @blogger.list_pages(blog.id, **parameters).items.each do |page|
            blogger_page = PageWithoutAFile.new(site, site.source, dir, page.url[/^.+\/p\/(.+)/, 1])
            blogger_page.content = page.content
            blogger_page.data.merge!(page.to_h.deep_stringify_keys, source: 'Blogger')
            blogger_page.data.delete('content')
            site.pages << blogger_page
          end
        end
      end

      def create_posts(site, blog, list_post_parameters)
        list_post_parameters = blogger_config['list_post_parameters'] if list_post_parameters.nil?
        list_post_parameters = {} if list_post_parameters.nil?

        if list_post_parameters
          parameters = {
            max_results: 500
          }.merge(list_post_parameters).deep_symbolize_keys

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
end
