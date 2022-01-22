# frozen_string_literal: true

require "test_helper"

class DynamicPermissionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @dynamic_permission = dynamic_permissions(:one)
  end

  test "should get index" do
    get dynamic_permissions_url
    assert_response :success
  end

  test "should get new" do
    get new_dynamic_permission_url
    assert_response :success
  end

  test "should create dynamic_permission" do
    assert_difference("DynamicPermission.count") do
      post dynamic_permissions_url, params: { dynamic_permission: { default: @dynamic_permission.default, key: @dynamic_permission.key, name: @dynamic_permission.name } }
    end

    assert_redirected_to dynamic_permission_url(DynamicPermission.last)
  end

  test "should show dynamic_permission" do
    get dynamic_permission_url(@dynamic_permission)
    assert_response :success
  end

  test "should get edit" do
    get edit_dynamic_permission_url(@dynamic_permission)
    assert_response :success
  end

  test "should update dynamic_permission" do
    patch dynamic_permission_url(@dynamic_permission), params: { dynamic_permission: { default: @dynamic_permission.default, key: @dynamic_permission.key, name: @dynamic_permission.name } }
    assert_redirected_to dynamic_permission_url(@dynamic_permission)
  end

  test "should destroy dynamic_permission" do
    assert_difference("DynamicPermission.count", -1) do
      delete dynamic_permission_url(@dynamic_permission)
    end

    assert_redirected_to dynamic_permissions_url
  end
end
