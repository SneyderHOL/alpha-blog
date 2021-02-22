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

  def edit
    # byebug
    @article = Article.find(params[:id])
  end

  def create
    @article = Article.new(params_article)
    if @article.save
      flash[:notice] = "Article was created successfully."
      redirect_to @article
    else
      render 'new'
    end
  end

  def update
    # byebug
    @article = Article.find(params[:id])
    if @article.update(params_article)
      flash[:notice] = "Article was updated successfully."
      redirect_to @article
    else
      render 'edit'
    end
  end

  private

  def params_article
    params.require(:article).permit(:title, :description)
  end
end