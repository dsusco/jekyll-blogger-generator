require 'spec_helper'

describe(Jekyll::BloggerGenerator) do
  context('initialize') do
    let(:blogger) do
      instance_double('blogger')
    end

    let(:blogger_service) do
      class_double(Google::Apis::BloggerV3::BloggerService, new: blogger)
        .as_stubbed_const(transfer_nested_constants: true)
    end

    it('instantiates BloggerService') do
      expect(blogger).to receive(:key=)
      expect(blogger_service).to receive(:new)

      Jekyll::BloggerGenerator.new
    end

    it('set Blogger API key') do
      expect(blogger).to receive(:key=).with('some_key')
      expect(blogger_service).to receive(:new)

      Jekyll::BloggerGenerator.new({ 'blogger' => { 'key' => 'some_key' } })
    end
  end

  context('generate') do
  end
end
