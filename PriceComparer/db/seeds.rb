# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

products = [
    {id_product: 1, name: 'Product1', description: 'Description1', site: 'site1.com', price: 0.1, category: 'category1'},
    {id_product: 2, name: 'Product2', description: 'Description2', site: 'site2.com', price: 0.2, category: 'category2'},
    {id_product: 3, name: 'Product3', description: 'Description3', site: 'site3.com', price: 0.3, category: 'category3'},
    {id_product: 4, name: 'Product4', description: 'Description4', site: 'site4.com', price: 0.4, category: 'category4'}, 
    {id_product: 5, name: 'Product5', description: 'Description5', site: 'site5.com', price: 0.5, category: 'category5'},
    {id_product: 6, name: 'Product6', description: 'Description6', site: 'site6.com', price: 0.6, category: 'category6'},
    {id_product: 7, name: 'Product7', description: 'Description7', site: 'site7.com', price: 0.7, category: 'category7'},
    {id_product: 8, name: 'Product8', description: 'Description8', site: 'site8.com', price: 0.8, category: 'category8'},
    {id_product: 9, name: 'Product9', description: 'Description9', site: 'site9.com', price: 0.9, category: 'category9'},
    {id_product: 10, name: 'Product10', description: 'Description10', site: 'site10.com', price: 1.0, category: 'category10'},   
]

products.each do |product|
    Product.create(product)
end

users = [
    {name: 'User1', email: 'User1@uniroma1.it', password_digest: 'password_digest1'},
    {name: 'User2', email: 'User2@uniroma1.it', password_digest: 'password_digest2'},
    {name: 'User3', email: 'User3@uniroma1.it', password_digest: 'password_digest3'},
    {name: 'User4', email: 'User4@uniroma1.it', password_digest: 'password_digest4'},
    {name: 'User5', email: 'User5@uniroma1.it', password_digest: 'password_digest5'},
    {name: 'User6', email: 'User6@uniroma1.it', password_digest: 'password_digest6'},
    {name: 'User7', email: 'User7@uniroma1.it', password_digest: 'password_digest7'},
    {name: 'User8', email: 'User8@uniroma1.it', password_digest: 'password_digest8'},
    {name: 'User9', email: 'User9@uniroma1.it', password_digest: 'password_digest9'},
    {name: 'User10', email: 'User10@uniroma1.it', password_digest: 'password_digest10'},
]

users.each do |user|
    User.create(user)
end
