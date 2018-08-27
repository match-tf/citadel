class NewsController < ApplicationController
  before_action :set_news, only: [:show, :edit, :update, :destroy]
  before_action :require_meta, only: [:new, :create, :edit, :update, :destroy]

  def index
    @first = News.first
    @rest = News.all_but_first
    @news = News.all
    respond_to do |format|
      format.html
      format.atom
    end
  end

  def show
  end

  def new
    @news = News.new
  end

  def edit
  end

  def create
    @news = News::CreationService.call(news_params, current_user)

    if @news.persisted?
      redirect_to @news, notice: 'News post was successfully born.'
      Discord::Notifier.message('@everyone **' + @news.title + '**
' + @news.shorttext + '
**Read full post:** https://match.tf/news/' + @news.id.to_s)
    else
      redirect_to news_index_path
    end
  end

  def update
    if @news.update(news_params)
      redirect_to @news, notice: 'News post was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @news.destroy
    redirect_to news_index_url, notice: 'News post was successfully killed.'
  end

  private

  def set_news
    @news = News.find(params[:id])
  end

  def news_params
    params.require(:news).permit(:title, :content, :content_render_cache, :shorttext, :image)
  end

  def require_meta
    redirect_to root_path unless user_can_meta?
  end

end
