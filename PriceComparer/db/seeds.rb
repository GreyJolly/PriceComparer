# Create products
Product.create(
  id_product: 1,
  name: "Product 1",
  description: "Description of Product 1",
  site: "Site A",
  price: 99.99,
  category: "Category A",
  url: "http://example.com/product1",
  currency: "USD",
)

Product.create(
  id_product: 2,
  name: "Product 2",
  description: "Description of Product 2",
  site: "Site B",
  price: 149.50,
  category: "Category B",
  url: "http://example.com/product2",
  currency: "EUR",
)

# Create reports
Report.create(
  title: "Report 1",
  content: "Content of Report 1",
)

Report.create(
  title: "Report 2",
  content: "Content of Report 2",
)

# Create users
User.create(
  email: "amministratore@mail.it",
  username: "amministratore",
  password: "password",
  isAdministrator: true,
)

User.create(
  email: "analista@mail.it",
  username: "analista",
  password: "password",
  isAnalyst: true,
)

User.create(
  email: "user1@example.com",
  username: "user1",
  password: "user123",
)
