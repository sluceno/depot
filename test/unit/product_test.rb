require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  def new_product(image_url)
    Product.new(title:       "title more than 10 chars",
                description: "description",
                price:       1,
                image_url:   image_url)
  end

  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:image_url].any?
    assert product.errors[:price].any?
  end

  test "product price must be positive" do
    product = new_product "image.png"

    product.price = -1
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01",
      product.errors[:price].join("; ")

    product.price = 0
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01",
      product.errors[:price].join("; ")

    product.price = 1
    assert product.valid?
    assert product.errors.empty?
  end

  test "image url" do
    valid_image_urls = %w{ img.jpg img.png img.JPG img.PNG
                           img.gif http://adasd.com/x/y/img.png }

    invalid_image_urls = %w{ fred.jpeg png.img
                             hpng://png/jpg/gif }

    valid_image_urls.each do |image|
      assert new_product(image).valid?, "#{image} should be valid"
    end

    invalid_image_urls.each do |image|
      assert new_product(image).invalid?, "#{image} should be invalid"
    end
  end

  test "product is not valid without a unique title" do
    product = Product.new(title:       products(:ruby).title,
                          description: "lalala",
                          price:       1,
                          image_url:   "image.png"
                         )
    assert !product.save
    assert_equal I18n.t('activerecord.errors.messages.taken'), 
      product.errors[:title].join("; ")
  end

  test "product title is more than 10 chars" do
    product = new_product('image.png')

    product.title = '123456789'
    assert product.invalid?

    product.title = '1234567890'
    assert product.valid?
  end
end
