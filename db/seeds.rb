admin  = User.create!(username: "Admin User",  email: "admin@admin.com",  password: "admin")
jeff   = User.create!(username: "Jeff Schmoe", email: "jeff@gmail.com",   password: "password")
david  = User.create!(username: "David Dawg",  email: "david@gmail.com",  password: "password")
nicole = User.create!(username: "Nicole Doe",  email: "nicole@gmail.com", password: "password")

rev1 = Review.create!(author: admin, title: 'Need some help on a Ruby function', body: %Q{
  I need some help refining this ruby function for project I'm working on - it seems kind of ugly. Can anyone help me out?

  ```
  def some_method(opts)
    opts = opts || {}
    test = Array.new()
    test << opts[:somekey]
    return test
  end
  ```

  Anyone have any input?
})
rev1.tag_list = "ruby,rumble"; rev1.save!

# Hack to force an rid
rev1.rid = 'abcdef'; rev1.save!

rev1.comments.create!(author: jeff, body: %Q{
  You could use default arguments, such as <code>def some_method(opts={})</code> for starters!
}.squish)

rev1.comments.create!(author: david, body: %Q{
  I would initialize the test array using bracket notation, like <code>test = []</code>
}.squish)

rev1.comments.create!(author: nicole, body: %Q{
  This is a test comment
}.squish)



rev2 = Review.create!(author: nicole, title: 'This is a post about PHP', body: %Q{
  Herp derp, I like php.

  ```
  &lt;?php
    $php_sucks = 'true';
    echo "Does php suck?: " . $php_sucks;
  ?&gt;
  ```

  Please advise me on my incorrect choice of language.
})
rev1.tag_list = "php,running"; rev1.save!



100.times do |i|
  half1 = LiterateRandomizer.sentence[0..10]
  half2 = LiterateRandomizer.sentence[0..10]
  rev   = Review.create!(author: admin, title: "#{half1} ruby #{half2}", body: LiterateRandomizer.paragraph)
  if rand(3) == 0 # 30%
    rev.comments.create!(author: [jeff, david, nicole].sample, body: "ruby is awesome!")
  end
end
