require 'test_helper'

class AqueriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @aquery = aqueries(:one)
  end

  test "should get index" do
    get aqueries_url
    assert_response :success
  end

  test "should get new" do
    get new_aquery_url
    assert_response :success
  end

  test "should create aquery" do
    assert_difference('Aquery.count') do
      post aqueries_url, params: { aquery: { query_value: @aquery.query_value } }
    end

    assert_redirected_to aquery_url(Aquery.last)
  end

  test "should show aquery" do
    get aquery_url(@aquery)
    assert_response :success
  end

  test "should get edit" do
    get edit_aquery_url(@aquery)
    assert_response :success
  end

  test "should update aquery" do
    patch aquery_url(@aquery), params: { aquery: { query_value: @aquery.query_value } }
    assert_redirected_to aquery_url(@aquery)
  end

  test "should destroy aquery" do
    assert_difference('Aquery.count', -1) do
      delete aquery_url(@aquery)
    end

    assert_redirected_to aqueries_url
  end
end
