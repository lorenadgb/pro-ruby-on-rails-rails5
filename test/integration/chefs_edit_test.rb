require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest

  def setup
    @chef = Chef.create!(chefname: 'lorena', email: 'lorenadgb@gmail.com', password: "password", password_confirmation: "password")
    @chef2 = Chef.create!(chefname: "john", email: "john@example.com", password: "password", password_confirmation: "password")
    @admin_user = Chef.create!(chefname: "john1", email: "john1@example.com", password: "password",
                               password_confirmation: "password", admin: true)
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

  test 'accept edit attempt by admin user' do
    sign_in_as(@admin_user, 'password')
    get edit_chef_path(@chef)
    patch chef_path(@chef), params: { chef: { chefname: 'lorena bento', email: 'lorena@example.com' } }
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match 'lorena bento', @chef.chefname
    assert_match 'lorena@example.com', @chef.email
  end

  test 'redirect edit attempt by another non-admin user' do
    sign_in_as(@chef2, 'password')
    updated_name = 'joe'
    updated_email = 'joe@example.com'
    patch chef_path(@chef), params: { chef: { chefname: updated_name, email: updated_email } }
    assert_redirected_to chefs_path
    assert_not flash.empty?
    @chef.reload
    assert_match 'lorena', @chef.chefname
    assert_match 'lorenadgb@gmail.com', @chef.email
  end
end
