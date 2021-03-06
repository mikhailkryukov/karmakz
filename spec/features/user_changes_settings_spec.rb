require 'rails_helper'

feature 'User changes settings' do
  scenario 'User changes settings a couple of times' do
    set_and_login with: 'User Toni', as: 'user'
  end

  private

  def user_changes_name
    click_link 'Account Settings'
    expect(page).to have_content('My Settings')
    fill_in 'Full Name', with: 'Changed Name'
    click_button 'Save'
    expect(page).to have_content('Changed N.')
  end

  def user_changes_password_logs_out_and_than_logs_in_with_new_password
    fill_in 'Password', with: 'Changed'
    click_button 'Save'
    expect(page).to have_content("You've successfuly updated you're account settings.")
    click_link 'Log Out'
    expect(page).to have_content("You are logged out. We hope to see you soon!")
    click_link 'Login'
    fill_in 'Full Name', with: 'Changed Name'
    fill_in 'Password',  with: 'Changed'
    click_button 'Log in'
    expect(page).to have_content("Hello Changed Name! You are logged in.")
  end
end
