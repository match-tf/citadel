require 'rails_helper'

describe News do
  before(:all) { create(:news) }

  it { should belong_to(:author).class_name('User') }
  it { should_not allow_value(nil).for(:author) }

  it { should validate_presence_of(:title) }
  it { should validate_length_of(:title).is_at_least(2).is_at_most(128) }

  it { should validate_presence_of(:content) }
  it { should validate_length_of(:content).is_at_least(10).is_at_most(10_000) }

  it { should validate_presence_of(:image) }

  it { should validate_presence_of(:shorttext) }
  it { should validate_length_of(:shorttext).is_at_least(10).is_at_most(253) }

end
