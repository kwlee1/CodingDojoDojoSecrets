require 'rails_helper'
feature 'User features ' do
  before do
    # calling factory girl create method
    @user = create(:user)
  end
  feature "user sign-up" do
    before(:each) do
      visit "/users/new"
    end
    scenario 'visits sign-up page' do
      expect(page).to have_field('Name')
      expect(page).to have_field('Email')
      expect(page).to have_field('Password')
      expect(page).to have_field('Password_Confirmation')
    end
    scenario "with improper inputs, redirects back to sign in and shows validations" do
      click_button 'Join'
      expect(current_path).to eq('/users/new')
      expect(page).to have_text("can't be blank")
    end
    scenario "with proper inputs, create user and redirects to login page" do 
      fill_in 'Email', with: 'curry@warriors.com'
      fill_in 'Name', with: 'curry'
      fill_in 'Password', with:  'password'
      fill_in 'Password_Confirmation', with: 'password'
      click_button 'Join'
      expect(current_path).to eq("/sessions/new")
    end
  end
  feature "user dashboard" do 
    before do
      log_in
    end  
    scenario "displays user information" do 
      expect(page).to have_text("#{@user.name}")
      expect(page).to have_link('Edit Profile')
    end
  end
end

feature 'User Settings features ' do
    before do
      @user = create(:user)
      log_in
    end
    feature "User Settings Dashboard" do
      before(:each) do 
        visit "/users/#{@user.id}/edit"
      end
      scenario "visit users edit page" do
        expect(page).to have_field('Email')
        expect(page).to have_field('Name')
      end
      scenario "inputs filled out correctly" do 
        expect(find_field('Name').value).to eq(@user.name)
        expect(find_field('Email').value).to eq(@user.email)      
      end    
      scenario "incorrectly updates information" do
        fill_in 'Name', with: 'Another Name'      
        fill_in 'Email', with: 'incorrect email format'
        click_button 'Update'
        expect(current_path).to eq("/users/#{@user.id}/edit")
        expect(page).to have_text("Email is invalid")      
      end    
      scenario "correctly updates information" do 
        fill_in 'Name', with: 'Another Name'
        fill_in 'Email', with: 'correct@email.com'
        click_button 'Update'
        expect(page).to have_text('Another Name')
      end
      scenario "destroys user and redirects to registration page" do
        click_button 'Delete Account'
        expect(current_path).to eq('/users/new')
        # Make sure that you're clearing session on destroy
      end
    end
  end