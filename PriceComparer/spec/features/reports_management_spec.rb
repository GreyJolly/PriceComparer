require 'rails_helper'

RSpec.feature "ReportManagement", type: :feature do
  let(:admin_user) { create(:user, isAdministrator: true, password: 'password') }
  let(:regular_user) { create(:user, password: 'password') }
  let!(:product) { create(:product) }

  before do
    login_as(admin_user)
  end

  scenario "Admin creates a new report" do
    visit new_report_path

    fill_in "Titolo", with: "Test Report"
    fill_in "Descrizione", with: "This is a test report description."
    click_button "Invia"

    expect(page).to have_text("Test Report")
    expect(page).to have_text("This is a test report description.")
  end
end
