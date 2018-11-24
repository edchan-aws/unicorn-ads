require 'test_helper'

class Admin::DbConfigurationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_db_configuration = admin_db_configurations(:one)
  end

  test "should get index" do
    get admin_db_configurations_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_db_configuration_url
    assert_response :success
  end

  test "should create admin_db_configuration" do
    assert_difference('Admin::DbConfiguration.count') do
      post admin_db_configurations_url, params: { admin_db_configuration: { key: @admin_db_configuration.key, value: @admin_db_configuration.value } }
    end

    assert_redirected_to admin_db_configuration_url(Admin::DbConfiguration.last)
  end

  test "should show admin_db_configuration" do
    get admin_db_configuration_url(@admin_db_configuration)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_db_configuration_url(@admin_db_configuration)
    assert_response :success
  end

  test "should update admin_db_configuration" do
    patch admin_db_configuration_url(@admin_db_configuration), params: { admin_db_configuration: { key: @admin_db_configuration.key, value: @admin_db_configuration.value } }
    assert_redirected_to admin_db_configuration_url(@admin_db_configuration)
  end

  test "should destroy admin_db_configuration" do
    assert_difference('Admin::DbConfiguration.count', -1) do
      delete admin_db_configuration_url(@admin_db_configuration)
    end

    assert_redirected_to admin_db_configurations_url
  end
end
