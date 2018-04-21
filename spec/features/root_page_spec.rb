require 'rails_helper'

RSpec.feature "Visiting the root page", type: :feature do
  scenario "The visitor should see a 'Welcome'" do
    visit root_path
    expect(page).to have_text("Welcome")
  end

  scenario "The visitor should see a link 'Подключиться'" do
    visit root_path
    find_link('Подключиться', href: '/chats/connect')
  end

  scenario "The visitor should see a button 'Создать'" do
    visit root_path
    find_button('Создать')
  end
end