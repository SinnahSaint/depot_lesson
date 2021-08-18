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


end
