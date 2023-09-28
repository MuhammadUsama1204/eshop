class Product < ApplicationRecord
  has_one_attached :display_picture
  
  def self.searchFilter(params)
    @products = Product.all
    @products = @products.where("title ILIKE ?", "%#{params[:search]}%") if params[:search].present?
    @products = @products.where("price >= ?", params[:min_price]) if params[:min_price].present?
    @products = @products.where("price <= ?", params[:max_price]) if params[:max_price].present?
    @products
  end
end
