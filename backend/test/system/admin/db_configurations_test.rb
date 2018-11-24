require "application_system_test_case"

class Admin::DbConfigurationsTest < ApplicationSystemTestCase
  setup do
    @admin_db_configuration = admin_db_configurations(:one)
  end

  test "visiting the index" do
    visit admin_db_configurations_url
    assert_selector "h1", text: "Admin/Db Configurations"
  end

  test "creating a Db configuration" do
    visit admin_db_configurations_url
    click_on "New Admin/Db Configuration"

    fill_in "Key", with: @admin_db_configuration.key
    fill_in "Value", with: @admin_db_configuration.value
    click_on "Create Db configuration"

    assert_text "Db configuration was successfully created"
    click_on "Back"
  end

  test "updating a Db configuration" do
    visit admin_db_configurations_url
    click_on "Edit", match: :first

    fill_in "Key", with: @admin_db_configuration.key
    fill_in "Value", with: @admin_db_configuration.value
    click_on "Update Db configuration"

    assert_text "Db configuration was successfully updated"
    click_on "Back"
  end

  test "destroying a Db configuration" do
    visit admin_db_configurations_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Db configuration was successfully destroyed"
  end
end
