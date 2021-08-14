require "test_helper"

class ProductTest < ActiveSupport::TestCase
fixtures :products  # Not necessary. All fixtures load automagically.
                    # Selection only restricts to specific fixtures.

  test "product attributes must not n empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test "product price must ne a positive number" do
    product = Product.new(title:  "My book",
                          description: "XYZ!",
                          image_url: "abc.jpg")
    product.price = 1
    assert product.valid?

    product.price = 0
    assert product.invalid?

    product.price = -1
    assert product.invalid?
  end

  def new_product(image_url)
    Product.new(title:       "My Book Title",
                description: "yyy",
                price:       1,
                image_url:   image_url)
  end

  test "image url" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg
             http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }

    ok.each do |image_url|
      assert new_product(image_url).valid?,
             "#{image_url} should be valid"
    end

    bad.each do |image_url|
      assert new_product(image_url).invalid?,
             "#{image_url} should be invalid"
    end
  end

end
