class NewsPresenter < BasePresenter
  presents :news

  def title
    news.title
  end

  def created_at
    news.created_at.strftime('%d/%m/%Y %H:%M')
  end

  def link(label = nil)
    label ||= news.title
    link_to(label, news_path(news))
  end

  def image
    image_tag(news.image.url, class: 'img-responsive')
  end

  def thumb
    image_tag(news.image.thumb.url, class: 'img-responsive')
  end

  def thumblink
    link_to image_tag(news.image.thumb.url, class: 'img-responsive'), news_path(news)
  end

  def imagelink
    link_to image_tag(news.image.url, class: 'img-responsive'), news_path(news)
  end

  def content
    # rubocop:disable Rails/OutputSafety
    news.content_render_cache.html_safe
    # rubocop:enable Rails/OutputSafety
  end

  def short
    news.shorttext
  end
end
