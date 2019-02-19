require 'rails_helper'

RSpec.describe 'as merchant', type: :feature do

  it 'shows me my profile data when i visit my dashboard' do
    user = User.create(username: 'bob', street: "1234", city: "bob", state: "bobby", zip_code: 12345, email: "12345@54321", password: "password", role: 1, enabled: 0)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit dashboard_path

    expect(page).to have_content("Name: #{user.username}")
    expect(page).to have_content("Street Address: #{user.street}")
    expect(page).to have_content("City: #{user.city}")
    expect(page).to have_content("State: #{user.state}")
    expect(page).to have_content("Zip Code: #{user.zip_code}")
    expect(page).to have_content("Email: #{user.email}")
    expect(page).to_not have_content(user.password)
    expect(page).to_not have_link('Edit Profile')
  end

  it 'shows me a list of any orders with pending items that i sell' do
    user = User.create(username: 'bob', street: "1234", city: "bob", state: "bobby", zip_code: 12345, email: "12345@54321", password: "password", role: 0, enabled: 0)
    merchant = User.create(username: 'bob', street: "1234", city: "bob", state: "bobby", zip_code: 12345, email: "12@54321", password: "password", role: 1, enabled: 0)
    item_1 = Item.create(name: 'meh', description: "haha", quantity: 12, price: 2.5, thumbnail: "steve.jpg", user_id: merchant.id)
    item_2 = Item.create(name: 'vfjkdnj', description: "fjndkjknk", quantity: 12, price: 2.50, thumbnail: "steve.jpg", user_id: merchant.id)
    item_3 = Item.create(name: 'fvijodv', description: "oreijvioe", quantity: 12, price: 2.50, thumbnail: "steve.jpg", user_id: merchant.id)
    order_1 = Order.create(user_id: user.id)
    OrderItem.create(item_id: item_1.id, order_id: order_1.id, fulfilled: 0, current_price: 5.0, quantity: 2)
    OrderItem.create(item_id: item_2.id, order_id: order_1.id, fulfilled: 0, current_price: 7.50, quantity: 3)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

    visit dashboard_path

    within '.orders' do
      expect(page).to have_link("ID: #{order_1.id}")
      expect(page).to have_content("Date Made: #{order_1.created_at}")
      expect(page).to have_content("Number of Items: 5")
      expect(page).to have_content("Total Cost: $32.5")
      click_link "ID: #{order_1.id}"
    end
    expect(current_path).to eq(dashboard_orders_path(order_1))
  end

  it 'shows me statistics on my dashboard' do
    user = User.create(username: 'bob', street: "1234", city: "bob", state: "bobby", zip_code: 12345, email: "12345@54321", password: "password", role: 0, enabled: 0)
    user_tom = User.create(username: 'tom', street: "1234", city: "tom", state: "tommy", zip_code: 12345, email: "tommy", password: "tommy", role: 0, enabled: 0)
    user_don = User.create(username: 'don', street: "1234", city: "don", state: "donmy", zip_code: 12345, email: "donnmmy", password: "tommy", role: 0, enabled: 0)
    merchant = User.create(username: 'bob', street: "1234", city: "bob", state: "bobby", zip_code: 12345, email: "12@54321", password: "password", role: 1, enabled: 0)
    item_1 = Item.create(name: 'meh', description: "haha", quantity: 12, price: 2.50, thumbnail: "steve.jpg", user_id: merchant.id)
    item_2 = Item.create(name: 'pot', description: "fjndkjknk", quantity: 40, price: 9.50, thumbnail: "steve.jpg", user_id: merchant.id)
    item_3 = Item.create(name: 'crayon', description: "oreijvioe", quantity: 15, price: 3.75, thumbnail: "steve.jpg", user_id: merchant.id)
    item_4 = Item.create(name: 'marker', description: "oreijvioe", quantity: 50, price: 80, thumbnail: "steve.jpg", user_id: merchant.id)
    item_5 = Item.create!(name: 'house', description: "oreijvioe", quantity: 80, price: 1.99, thumbnail: "steve.jpg", user_id: merchant.id)
    order_1 = Order.create(user_id: user.id)
    order_2 = Order.create(user_id: user.id)
    order_3 = Order.create(user_id: user_tom.id)
    order_4 = Order.create(user_id: user_don.id)
    OrderItem.create(item_id: item_1.id, order_id: order_1.id, fulfilled: 1, current_price: 2.50, quantity: 2)
    OrderItem.create(item_id: item_2.id, order_id: order_1.id, fulfilled: 1, current_price: 9.50, quantity: 3)
    OrderItem.create(item_id: item_3.id, order_id: order_2.id, fulfilled: 1, current_price: 3.75, quantity: 4)
    OrderItem.create(item_id: item_4.id, order_id: order_3.id, fulfilled: 1, current_price: 80, quantity: 5)
    OrderItem.create(item_id: item_5.id, order_id: order_4.id, fulfilled: 1, current_price: 1.99, quantity: 6)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

    visit dashboard_path


    within '.statistics' do
      within '#top-items' do
        expect(page).to have_content("Top 5 Items:")
        expect(page).to have_content("#{item_5.name} - 6")
        expect(page).to have_content("#{item_4.name} - 5")
        expect(page).to have_content("#{item_3.name} - 4")
        expect(page).to have_content("#{item_2.name} - 3")
        expect(page).to have_content("#{item_1.name} - 2")
      end
      within '#total-quantity' do
        expect(page).to have_content("Total Quantity Sold: 20")
        expect(page).to have_content("Sold 20 items, which is 10.15% of your total inventory")
      end
      within '#top-states' do
        expect(page).to have_content('Top 3 States:')
        expect(page).to have_content("bobby - 9")
        expect(page).to have_content("donmy - 6")
        expect(page).to have_content("tommy - 5")
      end
      within '#top-cities' do
        expect(page).to have_content('Top 3 Cities:')
        expect(page).to have_content('bob, bobby')
        expect(page).to have_content('don, donmy')
        expect(page).to have_content('tom, tommy')
      end
      within '#top-users-orders-items' do
        expect(page).to have_content('Most Orders from You: bob, with 2 orders.')
        expect(page).to have_content('Most Items bought from you: bob, with 9 items.')
    end
      within '#top-users-price' do
        expect(page).to have_content('Top 3 Users by cost of purchases:')
        expect(page).to have_content('tom - $400')
        expect(page).to have_content('bob - $48.50')
        expect(page).to have_content('don - $11.94')
      end
    end
  end
end