require 'test_helper'

class RecipeTest < ActiveSupport::TestCase

  def setup
    @chef = Chef.create!(chefname: 'Lorena', email: 'lorena@example.com')
    @recipe = @chef.recipes.build(name: 'Vegetable', description: 'Great vegetable recipe')
  end

  test 'recipe without chef should be invalid' do
    @recipe.chef_id = nil
    assert_not @recipe.valid?
  end

  test 'recipe should be valid' do
    assert @recipe.valid?
  end

  test 'name should be present' do
    @recipe.name = " "
    assert_not @recipe.valid?
  end

  test 'description should be present' do
    @recipe.description = " "
    assert_not @recipe.valid?
  end

  test "description shoudn't be less than 5 characteres" do
    @recipe.description = "a" * 3
    assert_not @recipe.valid?
  end

  test "description shoudn't be more than 500 characteres" do
    @recipe.description = "a" * 501
    assert_not @recipe.valid?
  end
end
