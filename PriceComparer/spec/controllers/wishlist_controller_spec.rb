require "rails_helper"

RSpec.describe WishlistController, type: :controller do
  let(:user) { create(:user) }
  let(:product) { create(:product) }
  let!(:wishlist) { create(:wishlist, username: user.username, product: product) }

  before do
    sign_in user
  end

  describe "POST #add_to_wishlist" do
    let(:valid_product_params) do
      {
        name: "Test Product",
        description: "Test description",
        site: "www.testsite.com",
        price: 100,
        currency: "EUR",
        category: "Test Category",
		url: "http://example.com/test_product",
		condition: "Test Condition"
      }
    end

    it "adds a product to the wishlist" do
      post :add_to_wishlist, params: valid_product_params
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("Prodotto aggiunto alla wishlist con successo")

      added_product = Product.find_by(name: valid_product_params[:name], site: valid_product_params[:site])
      expect(added_product).to be_present
    end

    it "does not add a product with invalid params" do
      post :add_to_wishlist, params: { name: "", site: "www.testsite.com" }
      expect(response).to redirect_to(request.referer || root_path)
      expect(flash[:alert]).to eq("Please provide all required product information.")

      # Ensure the product was not added
      expect(Product.count).to eq(1)  # Assuming one product already exists (product created in let(:product))
    end
  end

  describe "POST #add_label" do
    it "adds a label to the wishlist" do
      post :add_label, params: { id: wishlist.id_product, label_name: "make up" }
      wishlist.reload
      expect(wishlist.labels).to include("make up")
    end

    it "does not add invalid labels" do
      post :add_label, params: { id: wishlist.id_product, label_name: "make@up" }
      expect(flash[:error]).to be_present
      wishlist.reload
      expect(wishlist.labels).not_to include("make@up")
    end
  end

  describe "DELETE #remove_label" do
    it "removes a label from the wishlist" do
      wishlist.add_label("make up")
      delete :remove_label, params: { id: wishlist.id_product, label_name: "make up" }
      wishlist.reload
      expect(wishlist.labels).not_to include("make up")
    end
  end
end
