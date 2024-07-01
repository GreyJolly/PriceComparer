require "rails_helper"

RSpec.feature "Wishlist Management", type: :feature do
  let(:user) { create(:user) }
  let(:product) { create(:product) }
  let!(:wishlist) { create(:wishlist, username: user.username, product: product) }

  before do
    login_as(user, scope: :user)
  end

  scenario "User adds a product to the wishlist from search results" do
    # Create a product and visit the root path
    product
    visit root_path

    # Search for the product
    fill_in "query", with: "Test Product"
    click_button "Search"

    # Verify that the product appears in the search results and click on it
    expect(page).to have_content("Test Product")

    click_button "Aggiungi alla wishlist", match: :first

    # Visit the wishlist page
    visit wishlist_path

    # Verify that the product is in the wishlist
    within "#wishlist-item-#{product.id_product}" do
      expect(page).to have_content("Test Product")
      expect(page).to have_content("Test Description")
      expect(page).to have_content("Test Site")
      expect(page).to have_content("10.0")
    end
  end

  scenario "User adds a label to an item in the wishlist" do
    visit wishlist_path
    within find("#wishlist-item-#{product.id_product}") do
      fill_in "label_name", with: "make up"
      click_button "Aggiungi"
    end
    expect(page).to have_content("make up")
  end

  scenario "User removes a label from an item in the wishlist" do
	visit wishlist_path
    within find("#wishlist-item-#{product.id_product}") do
      click_button "Rimuovi", match: :first
    end
    expect(page).not_to have_content("make up")
  end
end
