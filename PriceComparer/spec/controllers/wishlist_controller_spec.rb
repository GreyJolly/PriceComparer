require "rails_helper"

RSpec.describe WishlistController, type: :controller do
  let(:user) { create(:user) }
  let(:product) { create(:product) }
  let!(:wishlist) { create(:wishlist, username: user.username, product: product) }

  before do
    sign_in user
  end

  describe "POST #add_label" do
    it "adds a label to the wishlist" do
      post :add_label, params: { id: wishlist.product_id, label_name: "make up" }
      wishlist.reload
      expect(wishlist.labels).to include("make up")
    end

    it "does not add invalid labels" do
      post :add_label, params: { id: wishlist.product_id, label_name: "make@up" }
      expect(flash[:error]).to be_present
      wishlist.reload
      expect(wishlist.labels).not_to include("make@up")
    end
  end

  describe "DELETE #remove_label" do
    it "removes a label from the wishlist" do
      wishlist.add_label("make up")
      delete :remove_label, params: { id: wishlist.product_id, label_name: "make up" }
      wishlist.reload
      expect(wishlist.labels).not_to include("make up")
    end
  end
end
