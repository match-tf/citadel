class News < ApplicationRecord
  include MarkdownRenderCaching
  default_scope { order(created_at: :asc) }

  belongs_to :author, class_name: 'User'

  validates :title, presence: true, length: { in: 2..128 }
  validates :shorttext, presence: true, length: { in: 10..253 }
  validates :content, presence: true, length: { in: 10..10_000 }
  validates :image, presence: true
  caches_markdown_render_for :content

  mount_uploader :image, NewsimageUploader

  scope :all_but_first, -> { order(created_at: :desc)[1..-1] }

end