require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest

  def setup
    @chef = Chef.create!(chefname: 'lorena', email: 'lorenadgb@gmail.com', password: "password", password_confirmation: "password")
  end

  test 'reject an invalid edit' do
    sign_in_as(@chef, 'password')
    get edit_chef_path(@chef)
    patch chef_path(@chef), params: { chef: { chefname: ' ', email: 'lorena@example.com' } }
    assert_template 'chefs/edit'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end

  test 'accept valid signup' do
    sign_in_as(@chef, 'password')
    get edit_chef_path(@chef)
    patch chef_path(@chef), params: { chef: { chefname: 'lorena bento', email: 'lorena@example.com' } }
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match 'lorena bento', @chef.chefname
    assert_match 'lorena@example.com', @chef.email
  end

end
