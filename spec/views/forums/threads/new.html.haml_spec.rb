require 'rails_helper'

describe 'forums/threads/new' do
  let(:thread) { build(:forums_thread, topic: create(:forums_topic)) }

  it 'displays' do
    assign(:thread, thread)
    assign(:post, thread.posts.new)

    render
  end
end
