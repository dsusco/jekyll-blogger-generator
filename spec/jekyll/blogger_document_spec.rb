require 'spec_helper'

describe(Jekyll::BloggerDocument) do
  let(:site) do
    make_site
  end

  let(:post_args) do
    { content: '<p>Here we go...</p>',
      labels: ['label-one', 'label-two'],
      published: '2021-06-28T08:48:56-04:00',
      url: 'http://some-blog.blogspot.com/2021/06/some-post.html',
      updated: '2021-06-28T09:48:56-04:00' }
  end

  before(:each) do
    @blogger_document = Jekyll::BloggerDocument.new(
      Google::Apis::BloggerV3::Post.new(**post_args),
      { blog_url: 'http://some-blog.blogspot.com/',
        collection: site.posts,
        site: site })
    @blogger_document.read_content
  end

  context('initialize') do
    it 'sets path' do
      expect(@blogger_document.path).to eq('some-blog/_posts/some-post.html')
    end
  end

  context('source_file_mtime') do
    it 'uses updated post property' do
      expect(@blogger_document.source_file_mtime).to eq(Time.parse(post_args[:updated]))
    end
  end

  context('read_content') do
    it 'sets content' do
      expect(@blogger_document.content).to eq(post_args[:content])
    end

    it 'sets data.categories' do
      expect(@blogger_document.data['categories']).to eq(['some-blog'])
    end

    it 'sets data.date' do
      expect(@blogger_document.data['date']).to eq(Time.parse(post_args[:published]))
    end

    it 'sets data.draft' do
      expect(@blogger_document.data['draft']).to be_falsey
    end

    it 'sets data.except separator' do
      expect(@blogger_document.data['excerpt_separator']).to eq('<!--more-->')
    end

    it 'sets data.tags' do
      expect(@blogger_document.data['tags']).to eq(post_args[:labels])
    end

    it 'adds all post properties to data' do
      expect(@blogger_document.data['updated']).to eq(post_args[:updated])
    end
  end
end
