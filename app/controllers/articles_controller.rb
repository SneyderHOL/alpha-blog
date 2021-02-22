class ArticlesController < ApplicationController
  def show
    # byebug
    @article = Article.find(params[:id])
  end

  def index
    @articles = Article.all
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(params_article)
    @article.save
    redirect_to @article
  end

  private

  def params_article
    params.require(:article).permit(:title, :description)
  end
end