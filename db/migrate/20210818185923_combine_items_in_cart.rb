class CombineItemsInCart < ActiveRecord::Migration[6.1]
  def up
    # replace duplicates with single item
    Cart.all.each do |cart|
      # count the qty of each product in the cart
      sums = cart.line_items.group(:product_id).sum(:quantity)

      sums.each do |product_id, quantity|
        if quantity > 1
          # get rid of them all
          cart.line_items.where(product_id: product_id).delete_all

          # make a new one with the right qty
          item = cart.line_items.build(product_id: product_id)
          item.quantity = quantity
          item.save!
        end
      end
    end
  end

  def down
    # split items with qty >1 into multi line
    LineItem.where("quantity>1").each do |line_item|
      # add individual items
      line_item.quantity.times do
        LineItem.create(
          cart_id: line_item.cart_id,
          product_id: line_item.product_id,
          quantity: 1
        )
      end

    #remove the origional item
    line_item.destroy
    end
  end
end
