require 'test_helper'

class InvestmentassetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @investmentasset = investmentassets(:one)
  end

  test "should get index" do
    get investmentassets_url
    assert_response :success
  end

  test "should get new" do
    get new_investmentasset_url
    assert_response :success
  end

  test "should create investmentasset" do
    assert_difference('Investmentasset.count') do
      post investmentassets_url, params: { investmentasset: { category: @investmentasset.category, name: @investmentasset.name, porfolio_id: @investmentasset.porfolio_id, purchaseValue: @investmentasset.purchaseValue, qty: @investmentasset.qty } }
    end

    assert_redirected_to investmentasset_url(Investmentasset.last)
  end

  test "should show investmentasset" do
    get investmentasset_url(@investmentasset)
    assert_response :success
  end

  test "should get edit" do
    get edit_investmentasset_url(@investmentasset)
    assert_response :success
  end

  test "should update investmentasset" do
    patch investmentasset_url(@investmentasset), params: { investmentasset: { category: @investmentasset.category, name: @investmentasset.name, porfolio_id: @investmentasset.porfolio_id, purchaseValue: @investmentasset.purchaseValue, qty: @investmentasset.qty } }
    assert_redirected_to investmentasset_url(@investmentasset)
  end

  test "should destroy investmentasset" do
    assert_difference('Investmentasset.count', -1) do
      delete investmentasset_url(@investmentasset)
    end

    assert_redirected_to investmentassets_url
  end
end
