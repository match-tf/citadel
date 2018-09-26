class PagesController < ApplicationController
  layout "home", only: [:home]

  def home
    read_news_config
  end

  private

  def read_news_config
    @news = News.all
    @head = News.first
    @rest = News.all_but_first.first(3)
  end

end
