1. 가상머신을 킨다

2. 프로젝트를 만든다.

3. scaffold

```
   ubuntu@ubuntu-xenial:/vagrant/facebook$ rails g scaffold post title content:text user:references
```



4. test

### test

----------





```
ntu-xenial:/vagrant/facebook$ rake test
# test/controllers/posts_con..
# route파일의 resource를 날리면, error

# test/models/post_test.rb

```

```
# test/fixtures -> 테스트 단계에서 rake db:seed와 같은 느낌
$ rake db:fixtures:load
```



```
ubuntu@ubuntu-xenial:/vagrant/facebook$ rails c
Loading development environment (Rails 4.2.9)
irb(main):001:0> Faker::Internet.email

```





TDD <br>

: 테스트를 먼저 짜고 개발하는 방식

`tdd is dea long live testing` [http://david.heinemeierhansson.com/2014/tdd-is-dead-long-live-testing.html](http://david.heinemeierhansson.com/2014/tdd-is-dead-long-live-testing.html) <br>

한글 번역:  [https://sangwook.github.io/2014/04/25/tdd-is-dead-long-live-testing.html](https://sangwook.github.io/2014/04/25/tdd-is-dead-long-live-testing.html)

<br>

rails는 개발과 test가 함께 가능하다.  <br>

rails가 제공하는 test framwork를 활용하면서 개발.


#### mvp
최소기능만을 만들어놓고, 점점 발전을 시켜나간다.  <br>
mvp부터 천천히 발전시켜나가는 방법으로 하기 위해서는 test가 매우 필요하다.  <br>
처음에는 쓸 데 없다고 생각하지만, 업무 scope에 들어가는 내용이기 때문에 매우 중요하다. <br>
Rails는 test code를 짜기 쉽고, 쉽게 testing을 할 수 있다.




## validation

---

1. input값에 의해서 active 되게끔, enactive로 만들어놓는다.
2. 하지만, front end에서만 막으면, url 등으로 오는 요청을 막지 못한다. frontend validation은 user측에만 편한 감이 있다.
3. 따라서, controller단에서 날라오는 요청을 process 하는 과정 속에 유효한가 아닌가를 판단해야 한다.

| 유저의 편의성             |                  | 최후의 방어막       |
| ------------------- | ---------------- | ------------- |
| Frontend Validation | Model validation | DB Validation |



**DB Vaildation**

`rails migration`  검색, [https://rubykr.github.io/rails_guides/migrations.html](https://rubykr.github.io/rails_guides/migrations.html)

1. null: false를 달아주는 습관을 기르자

**[migrate/create_posts.rb]**

```
# :null => false
null: false, default: ""
```

null값은 받지 않고, default는 empty string이다.

```
ActiveRecord::StatementInvalid:
Caused by:
SQLite3::ConstraintException: NOT NULL constraint failed: posts.user_id
```



user_id를 넣어주지 않으면 error가 일어난다.





2. 액티브 레코드 데이터 검증

`rails validation` 검색, [http://guides.rorlab.org/active_record_validations.html](http://guides.rorlab.org/active_record_validations.html)

**[models/comment.rb]**

```
vaildates :content, presence: true
```

**[models/post.rb]**

```
  validates :title, presence: true
  validates :content, presence: true
```

null값을 받지 않겠다.



3. 관계형에서 validation 걸어주기

```
# 에러 피해가기
if post.user
```

유저가 삭제될 경우, 유저가 가지고 있는 code를 없앤다.  user가 없는 post는 에러를 냄.

<br>

**[modle/posts.rb]**

```
# 주인없는 content를 없애준다.
has_many :comments, dependent: :destroy
```

`gitlab` 은 100% rails code이다. 따라서, 상용 코드를 보려면, gitlab을 참고하면 좋다. [https://github.com/gitlabhq/gitlabhq](https://github.com/gitlabhq/gitlabhq)

<br>

`rails opensource project` 검색하면, rails로 만들어진 opensource

[http://www.opensourcerails.com/](http://www.opensourcerails.com/)



#### 댓글 제한

`lorem ipsum`을 통해 쉽게 글자수 기능을 테스트 해볼 수 있다.
[https://www.lipsum.com/](https://www.lipsum.com/)
`rails active record korean`

`gem faker lorem`

**devise**

```
# environments / development.rb
# 추가
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
```

```
<%= form_tag create_comment_post_path, method: :post do %>
  <%= text_field_tag :content%>
  <%= submit_tag "ëę¸ëŹę¸°"%>
<% end %>
```

```
  def create_comment
    @post = Post.find(params[:id])
    Comment.create(
      content: params[:content],
      post_id: @post.id
    )

  end
```





ajax

---

페이지 전체 리로드를 없앤다.

1. ajax가 먹힐 부분을 dom으로 감싸준다.

```
<div id="comments">
  <% @comments.each do |comment|%>
    <div><%=comment.content%></div>
  <% end %>
</div>
```

2. posts_controller 원래

```
  def create_comment
    @post = Post.find(params[:id])
    @commnent = Comment.new(
      content: params[:content],
      post_id: @post.id
    )
    @comment.save

  end
```

create와 new하고 save의 차이? new하면 도중에 저장을 할 수 있다.

3. Database create 말고 new

```
  def create_comment
    @post = Post.find(params[:id])
    @comment = Comment.new(
      content: params[:content],
      post_id: @post.id
    )
    @comment.save
  end
```

```
# create_comment.js.erb
$('#comments').append("<div><%= @comment.content %></div>")
```


#### email
p. 270

```
irb(main):001:0> User.create(email: "asdf", password: "123123", password_confirmation: "123123")
   (0.1ms)  begin transaction
  User Exists (1.2ms)  SELECT  1 AS one FROM "users" WHERE "users"."email" = 'asdf' LIMIT 1
   (0.1ms)  rollback transaction
=> #<User id: nil, email: "asdf", created_at: nil, updated_at: nil>
irb(main):002:0>
```

```
$ rake test:models
```

2. email은 unique해야한다.
3.

### cotroller를 따로 만드는 경우

comment_







<br>

자동화 툴

-----------

* chef [https://www.chef.io/chef/](https://www.chef.io/chef/)
  * domain specific language
  * go rails your cheffile  [https://gorails.com/guides/using-vagrant-for-rails-development](https://gorails.com/guides/using-vagrant-for-rails-development)
