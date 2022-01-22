# frozen_string_literal: true

require "application_system_test_case"

class DynamicPermissionsTest < ApplicationSystemTestCase
  setup do
    @dynamic_permission = dynamic_permissions(:one)
  end

  test "visiting the index" do
    visit dynamic_permissions_url
    assert_selector "h1", text: "Dynamic permissions"
  end

  test "should create dynamic permission" do
    visit dynamic_permissions_url
    click_on "New dynamic permission"

    check "Default" if @dynamic_permission.default
    fill_in "Key", with: @dynamic_permission.key
    fill_in "Name", with: @dynamic_permission.name
    click_on "Create Dynamic permission"

    assert_text "Dynamic permission was successfully created"
    click_on "Back"
  end

  test "should update Dynamic permission" do
    visit dynamic_permission_url(@dynamic_permission)
    click_on "Edit this dynamic permission", match: :first

    check "Default" if @dynamic_permission.default
    fill_in "Key", with: @dynamic_permission.key
    fill_in "Name", with: @dynamic_permission.name
    click_on "Update Dynamic permission"

    assert_text "Dynamic permission was successfully updated"
    click_on "Back"
  end

  test "should destroy Dynamic permission" do
    visit dynamic_permission_url(@dynamic_permission)
    click_on "Destroy this dynamic permission", match: :first

    assert_text "Dynamic permission was successfully destroyed"
  end
end
