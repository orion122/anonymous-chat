require 'rails_helper'

RSpec.feature "Visiting the home page", type: :feature do
  scenario "The visitor should see a 'Select a Chat'" do
    visit root_path
    expect(page).to have_text("Welcome")
  end
end