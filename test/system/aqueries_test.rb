require "application_system_test_case"

class AqueriesTest < ApplicationSystemTestCase
  setup do
    @aquery = aqueries(:one)
  end

  test "visiting the index" do
    visit aqueries_url
    assert_selector "h1", text: "Aqueries"
  end

  test "creating a Aquery" do
    visit aqueries_url
    click_on "New Aquery"

    fill_in "Query value", with: @aquery.query_value
    click_on "Create Aquery"

    assert_text "Aquery was successfully created"
    click_on "Back"
  end

  test "updating a Aquery" do
    visit aqueries_url
    click_on "Edit", match: :first

    fill_in "Query value", with: @aquery.query_value
    click_on "Update Aquery"

    assert_text "Aquery was successfully updated"
    click_on "Back"
  end

  test "destroying a Aquery" do
    visit aqueries_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Aquery was successfully destroyed"
  end
end
