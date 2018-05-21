require 'rails_helper'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

RSpec.feature 'Visiting the root page', type: :feature do
  before { visit root_path }
  scenario "The visitor should see a 'Welcome'" do
    page.has_content?(I18n.t('root.welcome'))
  end

  scenario "The visitor should see a button 'Join random chat'" do
    page.has_xpath?("input[type=submit][value='#{I18n.t('root.join_random_chat')}']")
  end

  scenario "The visitor should see a button 'Create chat'" do
    page.has_xpath?("input[type=submit][value='#{I18n.t('root.create_chat')}']")
  end

  scenario "Visitor should see chat page after clicking 'Create chat'" do
    click_button(I18n.t('root.create_chat'))
    chat = Chat.first
    expect(page).to have_current_path(chat_path(chat.token))
  end

  scenario "Visitor should see chat page after clicking 'Join random chat'" do
    create(:chat)
    click_button(I18n.t('root.join_random_chat'))
    chat = Chat.first
    expect(page).to have_current_path(chat_path(chat.token))
  end

  scenario "Page should has input type='text' after clicking 'Create chat'" do
    click_button(I18n.t('root.create_chat'))
    page.has_xpath?("//input[@type='text'][class='input-box_text']")
  end

  scenario "Page should has input type='text' after clicking
            'Join random chat'" do
    create(:chat)
    click_button(I18n.t('root.join_random_chat'))
    page.has_xpath?("//input[@type='text'][class='input-box_text']")
  end
end
