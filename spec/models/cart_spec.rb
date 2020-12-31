require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe "購物車基本功能" do
    it "可以把商品丟到到購物車裡，然後購物車裡就有東西了" do
      cart = Cart.new
      cart.add_item(1)
      expect(cart.empty?).to be false
    end

    it "如果加了相同種類的商品到購物車裡，購買項目（CartItem）並不會增加，但商品的數量會改變" do
      cart = Cart.new
      3.times { cart.add_item(1) }
      5.times { cart.add_item(2) }
      expect(cart.items.count).to be 2
    end

    it "商品可以放到購物車裡，也可以再拿出來" do
      cart = Cart.new
      p9 = Product.create(name: "product9", content: "sales product9", price: 900, quantity: 90, shop: "shop9")

      cart.add_item(p9.id)

      expect(cart.items.first.product.id).to be p9.id
    end

    it "每個 Cart Item 都可以計算它自己的金額（小計）" do
      cart = Cart.new
      p9 = Product.create(name: "product9", content: "sales product9", price: 900, quantity: 90, shop: "shop9")
      p1 = Product.create(name: "product1", content: "sales product1", price: 100, quantity: 10, shop: "shop1")

      3.times { cart.add_item(p9.id)}
      2.times { cart.add_item(p1.id)}

      expect(cart.items.first.total_price).to be 2700
      expect(cart.items.last.total_price).to be 200
    end

    it "可以計算整台購物車的總消費金額" do
      cart = Cart.new
      p9 = Product.create(name: "product9", content: "sales product9", price: 900, quantity: 90, shop: "shop9")
      p1 = Product.create(name: "product1", content: "sales product1", price: 100, quantity: 10, shop: "shop1")

      3.times { cart.add_item(p9.id) }
      2.times { cart.add_item(p1.id) }

      expect(cart.total_price).to be 2900
    end

    it "特別活動可能可搭配折扣（例如聖誕節的時候全面打 9 折，或是滿額滿千送百）" do
      cart = Cart.new
      p9 = Product.create(name: "product9", content: "sales product9", price: 900, quantity: 90, shop: "shop9")
      p1 = Product.create(name: "product1", content: "sales product1", price: 100, quantity: 10, shop: "shop1")

      3.times { cart.add_item(p9.id) }
      2.times { cart.add_item(p1.id) }
      t = Time.local(2000,12,25, 10,5,0)
      Timecop.travel(t)

      expect(cart.total_price).to eq 2610
    end
  end

  describe "購物車進階功能" do
    it "可以將購物車內容轉換成 Hash，存到 Session 裡" do
      cart = Cart.new
      cart.add_item(1)
      expect(cart.serialize).to eq cart_hash
    end
    it "可以把 Session 的內容（Hash 格式），還原成購物車的內容" do
      cart = Cart.from_hash(cart_hash)

      expect(cart.items.count).to eq 1
      expect(cart.items.first.quantity).to be 1
    end

    private
    def cart_hash
      cart_hash = {
        "items" =>
        [
          {"item_id" => 1, "quantity" => 1, }
        ]
      }
      cart_hash
    end
  end
end