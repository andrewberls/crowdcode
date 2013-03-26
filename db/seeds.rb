admin_user = User.create!(username: "Admin User", email: "admin@admin.com", password: "admin")

rev1 = Review.new(title: 'Need some help on a Ruby function', body: %Q{
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

rev1.user = admin_user
rev1.save!

rev1.comments.create(body: %Q{
  You could use default arguments, such as <code>def some_method(opts={})</code> for starters!
})
rev1.comments.create(body: %Q{
  I would initialize the test array using bracket notation, like <code>test = []</code>
})
