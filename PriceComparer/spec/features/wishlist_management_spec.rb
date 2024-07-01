require "rails_helper"

RSpec.feature "Wishlist Management", type: :feature do
  let(:user) { create(:user) }
  let(:product) { create(:product) }
  let!(:wishlist) { create(:wishlist, username: user.username, product: product) }

  before do
    login_as(user, scope: :user)
    visit wishlist_path
  end

  scenario "User adds a label to an item in the wishlist" do
    within find("#wishlist-item-#{product.id_product}") do
      fill_in "label_name", with: "make up"
      click_button "Aggiungi"
    end
    expect(page).to have_content("make up")
  end

  scenario "User removes a label from an item in the wishlist" do
    within find("#wishlist-item-#{product.id_product}") do
      click_button "Rimuovi", match: :first
    end
    expect(page).not_to have_content("make up")
  end

end
