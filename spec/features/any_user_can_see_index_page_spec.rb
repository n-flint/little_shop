require 'rails_helper'

RSpec.describe 'When I visit the items catalog', type: :feature do
  describe 'as visitor' do
    it 'lets me see all items in the system except disabled ones' do
      item = Item.create!(name: 'pot_1', description:'a small pot for plants', quantity: 30, price: 2.50, thumbnail: "https://i.etsystatic.com/13875023/r/il/0db0e5/1570825768/il_570xN.1570825768_anvx.jpg", user: user)
      item = Item.create!(name: 'pot_2', description:'another small pot for plants', quantity: 20, price: 3.00, thumbnail: "https://i.etsystatic.com/13875023/r/il/0db0e5/1570825768/il_570xN.1570825768_anvx.jpg", user: user)
      item = Item.create!(name: 'pot_3', description:'this is also a small pot for plants', quantity: 10, price: 4.50, thumbnail: https://i.etsystatic.com/13875023/r/il/0db0e5/1570825768/il_570xN.1570825768_anvx.jpg, user: user)
      item = Item.create!(name: 'pot_4', description:'small pot for plants, very rare', quantity: 0, price: 2.00, thumbnail: https://i.etsystatic.com/13875023/r/il/0db0e5/1570825768/il_570xN.1570825768_anvx.jpg, user: user)

      visit item_path(item.id)

      expect(page).to have_content("Cart(0)")

      click_button 'Add to Cart'


      expect(current_path).to eq(items_path)
      expect(page).to have_content("Cart(1)")
      expect(page).to have_content("#{item.name} has been succesfully added to your cart.")
    end
  end

  describe 'as registered user' do
    it 'lets me see all items in the system except disabled ones' do
      user = User.create(username: 'bob', street: "1234", city: "bob", state: "bobby", zip_code: 12345, email: "12345@54321", password: "password", role: 0, enabled: 0)
      item = Item.create(name: 'pot', description:'small pot for plants', quantity: 30, price: 2.49, thumbnail: 'thumbnail.jpeg', user: user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit item_path(item)


      expect(page).to have_content("Cart(0)")

      click_button 'Add to Cart'


      expect(current_path).to eq(items_path)
      expect(page).to have_content("Cart(1)")
      expect(page).to have_content("#{item.name} has been succesfully added to your cart.")
    end
  end

  describe 'as registered merchant' do
    it 'lets me see all items in the system except disabled ones' do
      user = User.create(username: 'bob', street: "1234", city: "bob", state: "bobby", zip_code: 12345, email: "12345@54321", password: "password", role: 1, enabled: 0)
      item = Item.create(name: 'pot', description:'small pot for plants', quantity: 30, price: 2.49, thumbnail: 'thumbnail.jpeg', user: user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit item_path(item)

      expect(page).to_not have_content("Cart(0)")
      expect(page).to_not have_button('Add to Cart')
    end
  end

  describe 'as registered admin' do
    it 'lets me see all items in the system except disabled ones' do
      user = User.create(username: 'bob', street: "1234", city: "bob", state: "bobby", zip_code: 12345, email: "12345@54321", password: "password", role: 2, enabled: 0)
      item = Item.create(name: 'pot', description:'small pot for plants', quantity: 30, price: 2.49, thumbnail: 'thumbnail.jpeg', user: user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit item_path(item)

      expect(page).to_not have_content("Cart(0)")
      expect(page).to_not have_button('Add to Cart')
    end
  end
end
