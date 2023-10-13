class CartsController < ApplicationController
	def show
    @cart = current_user.cart
  end
	
	def add_to_cart	
		@product = Product.find(params[:product_id])
		@line_item = @cart.line_items.find_or_initialize_by(product: @product)
		@line_item.price = @product.price
		if @line_item.persisted?
			@line_item.increment(:quantity)
		else
			@line_item.quantity = 1
		end

		if @line_item.save
			redirect_to products_path, notice: "#{@product.title} added to cart."
		else
			render :products_path, notice: "#{@product.title} failed to add to cart."
		end
	end

  def update_quantity
    @product = Product.find(params[:id])
    @line_item = @cart.line_items.find_by(product: @product)
    case params[:data_action]
      when 'increment'
        if @line_item.quantity < @product.quantity_in_stock
          @line_item.quantity += 1
        end
      when 'decrement'
        if @line_item.quantity > 1
          @line_item.quantity -= 1
        end
      end
    @line_item.save
  end
 
	def remove_from_cart
    @line_item = LineItem.find(params[:id])    
    if @cart.line_items.empty?
      @cart.destroy
    else
      @line_item.destroy
    end
    redirect_to cart_path
  end
end
