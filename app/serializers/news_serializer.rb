class NewsSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :content, :content_render_cache, :author_id, :twitter_url, :image
end
