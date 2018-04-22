require 'rails_helper'

RSpec.feature "Visiting the root page", type: :feature do
  scenario "The visitor should see a 'Welcome'" do
    visit root_path
    page.has_content?('Welcome')
  end

  scenario "The visitor should see a link 'Подключиться'" do
    visit root_path
    find_link('Подключиться', href: '/chats/connect')
  end

  scenario "The visitor should see a button 'Создать'" do
    visit root_path
    page.has_xpath?("input[type=submit][value='Создать']")
  end

  scenario "The visitor should see a chat's page after clicking the button 'Создать" do
    visit root_path
    click_button('Создать')
    expect(page).to have_current_path(chat_path(Chat.first.token))
  end

  scenario "The visitor should see a chat's page after clicking the link 'Подключиться'" do
    visit root_path
    Chat.create(token: 12345)
    click_link('Подключиться')
    expect(page).to have_current_path(chat_path(Chat.first.token))
  end

  scenario "Page should has input type='text' after clicking the button 'Создать'" do
    visit root_path
    click_button('Создать')
    page.has_xpath?("//input[@type='text'][class='input-box_text']")
  end

  scenario "Page should has input type='text' clicking the link 'Подключиться'" do
    visit root_path
    click_button('Создать')
    page.has_xpath?("//input[@type='text'][class='input-box_text']")
  end
end