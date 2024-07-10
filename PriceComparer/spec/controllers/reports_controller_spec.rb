require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
  let(:admin_user) { create(:user, isAdministrator: true) }
  let(:regular_user) { create(:user) }
  let(:report) { create(:report) }
  let(:product) { create(:product) }

  describe "GET #index" do
    context "as an admin" do
      before do
        sign_in admin_user
        get :index
      end

      it "returns a success response" do
        expect(response).to be_successful
      end
    end

    context "as a regular user" do
      before do
        sign_in regular_user
        get :index
      end

      it "redirects to root_path" do
        expect(response).to redirect_to(root_path)
      end

      it "sets a flash alert" do
        expect(flash[:alert]).to eq("Non sei autorizzato ad accedere a questa pagina. Sei stato redirezionato.")
      end
    end
  end
end

