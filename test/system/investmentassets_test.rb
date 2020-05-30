require "application_system_test_case"

class InvestmentassetsTest < ApplicationSystemTestCase
  setup do
    @investmentasset = investmentassets(:one)
  end

  test "visiting the index" do
    visit investmentassets_url
    assert_selector "h1", text: "Investmentassets"
  end

  test "creating a Investmentasset" do
    visit investmentassets_url
    click_on "New Investmentasset"

    fill_in "Category", with: @investmentasset.category
    fill_in "Name", with: @investmentasset.name
    fill_in "Porfolio", with: @investmentasset.porfolio_id
    fill_in "Purchasevalue", with: @investmentasset.purchaseValue
    fill_in "Qty", with: @investmentasset.qty
    click_on "Create Investmentasset"

    assert_text "Investmentasset was successfully created"
    click_on "Back"
  end

  test "updating a Investmentasset" do
    visit investmentassets_url
    click_on "Edit", match: :first

    fill_in "Category", with: @investmentasset.category
    fill_in "Name", with: @investmentasset.name
    fill_in "Porfolio", with: @investmentasset.porfolio_id
    fill_in "Purchasevalue", with: @investmentasset.purchaseValue
    fill_in "Qty", with: @investmentasset.qty
    click_on "Update Investmentasset"

    assert_text "Investmentasset was successfully updated"
    click_on "Back"
  end

  test "destroying a Investmentasset" do
    visit investmentassets_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Investmentasset was successfully destroyed"
  end
end
