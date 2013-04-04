admin  = User.create!(username: "Admin User",  email: "admin@admin.com",  password: "admin")
jeff   = User.create!(username: "Jeff Schmoe", email: "jeff@gmail.com",   password: "password")
david  = User.create!(username: "David Dawg",  email: "david@gmail.com",  password: "password")
nicole = User.create!(username: "Nicole Doe",  email: "nicole@gmail.com", password: "password")

rev1 = Review.new(author: admin, title: 'Need some help on a Ruby function', body: %Q{
  <p>I need some help refining this ruby function for project I'm working on - it seems kind of ugly. Can anyone help me out?</p>


  <pre>
  <code>def some_method(opts)
    opts = opts || {}
    test = Array.new()
    test << opts[:somekey]
    return test
  end</code></pre>

  <p>Anyone have any input?</p>
})
rev1.save!

# Hack to force an rid
rev1.rid = 'abcdef'; rev1.save!

rev1.comments.create!(body: %Q{
  You could use default arguments, such as <code>def some_method(opts={})</code> for starters!
}, author: jeff)
rev1.comments.create!(body: %Q{
  I would initialize the test array using bracket notation, like <code>test = []</code>
}, author: david)
rev1.comments.create!(body: %Q{
  This is a test comment
}, author: nicole)
