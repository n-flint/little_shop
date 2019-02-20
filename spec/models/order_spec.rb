require 'rails_helper'

RSpec.describe Order, type: :model do

  describe 'validations' do
  end

  describe 'relationships' do
    it {should belong_to :user}
  end

  describe 'instance methods' do
    describe '.total_item_quantity' do
      it 'should total the number of items in an order' do
        user = User.create(username: 'bob', street: "1234", city: "bob", state: "bobby", zip_code: 12345, email: "12345@54321", password: "password", role: 0, enabled: 0)
        merchant = User.create(username: 'bob', street: "1234", city: "bob", state: "bobby", zip_code: 12345, email: "12@54321", password: "password", role: 1, enabled: 0)
        item_1 = Item.create(name: 'meh', description: "haha", quantity: 12, price: 2.5, thumbnail: "steve.jpg", user_id: merchant.id)
        item_2 = Item.create(name: 'vfjkdnj', description: "fjndkjknk", quantity: 12, price: 2.5, thumbnail: "steve.jpg", user_id: merchant.id)
        order = Order.create(user_id: user.id)
        OrderItem.create(item_id: item_1.id, order_id: order.id, fulfilled: 0, current_price: 5.0, quantity: 2)
        OrderItem.create(item_id: item_2.id, order_id: order.id, fulfilled: 0, current_price: 7.5, quantity: 3)

        total_items = order.total_item_quantity

        expect(total_items).to eq(5)
      end
    end

    describe '.total_item_price' do
      it 'should total the price of items in an order' do
        user = User.create(username: 'bob', street: "1234", city: "bob", state: "bobby", zip_code: 12345, email: "12345@54321", password: "password", role: 0, enabled: 0)
        merchant = User.create(username: 'bob', street: "1234", city: "bob", state: "bobby", zip_code: 12345, email: "12@54321", password: "password", role: 1, enabled: 0)
        item_1 = Item.create(name: 'meh', description: "haha", quantity: 12, price: 2.5, thumbnail: "steve.jpg", user_id: merchant.id)
        item_2 = Item.create(name: 'vfjkdnj', description: "fjndkjknk", quantity: 12, price: 2.5, thumbnail: "steve.jpg", user_id: merchant.id)
        order = Order.create(user_id: user.id)
        OrderItem.create(item_id: item_1.id, order_id: order.id, fulfilled: 0, current_price: 5.0, quantity: 2)
        OrderItem.create(item_id: item_2.id, order_id: order.id, fulfilled: 0, current_price: 7.5, quantity: 3)

        total_price = order.total_item_price

        expect(total_price).to eq(12.5)
      end
    end

    describe '.total_item_quantity_for_merchant' do
      it 'should total the number of items in an order for a merchants items' do
        user = User.create(username: 'bob', street: "1234", city: "bob", state: "bobby", zip_code: 12345, email: "12345@54321", password: "password", role: 0, enabled: 0)
        merchant = User.create(username: 'bob', street: "1234", city: "bob", state: "bobby", zip_code: 12345, email: "12@54321", password: "password", role: 1, enabled: 0)
        merchant_2 = User.create(username: 'boby', street: "1234", city: "bob", state: "bobby", zip_code: 12345, email: "12@5421", password: "password", role: 1, enabled: 0)
        item_1 = Item.create(name: 'meh', description: "haha", quantity: 12, price: 2.5, thumbnail: "steve.jpg", user_id: merchant.id)
        item_2 = Item.create(name: 'vfjkdnj', description: "fjndkjknk", quantity: 12, price: 2.5, thumbnail: "steve.jpg", user_id: merchant_2.id)
        order = Order.create(user_id: user.id)
        OrderItem.create(item_id: item_1.id, order_id: order.id, fulfilled: 0, current_price: 5.0, quantity: 2)
        OrderItem.create(item_id: item_2.id, order_id: order.id, fulfilled: 0, current_price: 7.5, quantity: 3)

        total_items = order.total_item_quantity_for_merchant(merchant.id)

        expect(total_items).to eq(2)
      end
    end

    describe '.total_item_price_for_merchant' do
      it 'should total the price of items in an order for a merchant' do
        user = User.create(username: 'bob', street: "1234", city: "bob", state: "bobby", zip_code: 12345, email: "12345@54321", password: "password", role: 0, enabled: 0)
        merchant = User.create(username: 'bob', street: "1234", city: "bob", state: "bobby", zip_code: 12345, email: "12@54321", password: "password", role: 1, enabled: 0)
        merchant_2 = User.create(username: 'bob', street: "1234", city: "bob", state: "bobby", zip_code: 12345, email: "12@5321", password: "password", role: 1, enabled: 0)
        item_1 = Item.create(name: 'meh', description: "haha", quantity: 12, price: 2.5, thumbnail: "steve.jpg", user_id: merchant.id)
        item_2 = Item.create(name: 'vfjkdnj', description: "fjndkjknk", quantity: 12, price: 2.5, thumbnail: "steve.jpg", user_id: merchant_2.id)
        order = Order.create(user_id: user.id)
        OrderItem.create(item_id: item_1.id, order_id: order.id, fulfilled: 0, current_price: 5.0, quantity: 5)
        OrderItem.create(item_id: item_2.id, order_id: order.id, fulfilled: 0, current_price: 7.5, quantity: 3)

        total_price = order.total_item_price_for_merchant(merchant.id)

        expect(total_price).to eq(25.0)
      end
    end
  end

  describe 'class methods' do
    describe 'for_merchant' do
      it 'should return me only orders that have items I sell in them' do
        user = User.create(username: 'bob', street: "1234", city: "bob", state: "bobby", zip_code: 12345, email: "12345@54321", password: "password", role: 0, enabled: 0)
        merchant = User.create(username: 'bob', street: "1234", city: "bob", state: "bobby", zip_code: 12345, email: "12@54321", password: "password", role: 1, enabled: 0)
        merchant_2 = User.create(username: 'bob2', street: "12342", city: "bob2", state: "bobby2", zip_code: 12342, email: "12@54322", password: "password2", role: 1, enabled: 0)
        item_1 = Item.create(name: 'meh', description: "haha", quantity: 12, price: 2.5, thumbnail: "steve.jpg", user_id: merchant.id)
        item_2 = Item.create(name: 'vfjkdnj', description: "fjndkjknk", quantity: 12, price: 2.5, thumbnail: "steve.jpg", user_id: merchant_2.id)
        order = Order.create(user_id: user.id)
        order_2 = Order.create(user_id: user.id)
        OrderItem.create(item_id: item_1.id, order_id: order.id, fulfilled: 0, current_price: 5.0, quantity: 2)
        OrderItem.create(item_id: item_2.id, order_id: order.id, fulfilled: 0, current_price: 7.5, quantity: 3)
        OrderItem.create(item_id: item_2.id, order_id: order_2.id, fulfilled: 0, current_price: 7.5, quantity: 3)



        expect(Order.for_merchant(merchant.id)).to eq([order])
      end
    end
  end
end
