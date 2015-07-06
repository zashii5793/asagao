require 'test_helper'

class Admin::ArticlesControllerTest < ActionController::TestCase
  def setup
    login_as("taro", true)
  end

  test "new" do
    get :new
    assert_response :success
  end

  test "new before login" do
    logout
    get :new
    assert_response :forbidden
  end

  test "edit" do
    article = FactoryGirl.create(:article)
    get :edit, id: article
    assert_response :success
  end

  test "create" do
    post :create, article: FactoryGirl.attributes_for(:article)
    article = Article.order(:id).last
    assert_redirected_to [:admin, article]
  end

  test "update" do
    article = FactoryGirl.create(:article)
    patch :update, id: article, article: FactoryGirl.attributes_for(:article)
    assert_redirected_to [:admin, article]
  end

  test "fail to create" do
    attrs = FactoryGirl.attributes_for(:article, title: "")
    post :create, article: attrs
    assert_response :success
    assert_template "new"
  end

  test "fail to update" do
    attrs = FactoryGirl.attributes_for(:article, body: "")
    article = FactoryGirl.create(:article)
    patch :update, id: article, article: attrs
    assert_response :success
    assert_template "edit"
  end

  test "destroy" do
    article = FactoryGirl.create(:article)
    delete :destroy, id: article
    assert_redirected_to :admin_articles
    assert_raises(ActiveRecord::RecordNotFound) {
      Article.find(article.id) }
  end
end
