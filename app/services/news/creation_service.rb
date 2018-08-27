class News
  module CreationService
    include BaseService

    def call(news_params, user)
      news_params[:author] = user
      news = News.new(news_params)

      news.transaction do
        news.save || rollback!
      end

      news
    end

    private
  end
end
