---
layout: post
title:  "Learning Phoenix coming from Rails"
date:   2018-10-4 06:35:45 +0000
categories: Phoenix
---
#### Disclaimer:
* ##### My programming experience is only 1 1/2 years in Rails.
* ##### I have only ever used Rails for my side project and never for my actual work. 
#### Phoenix project:
* ##### I built a website where user can create their own communities. Kinda like Reddit, but with flat comment, and without voting system. They can also create a chat thread for a more real time discussion.

## 1. It's not as magic as Rails
What got me into wanting to learn Phoenix is that it share the same concept as Rails. Meaning it has the same folder structure, database migration and other thing that makes Rails so popular. 

Although to a large extend it is the same but it has less of the "magic" that Rails are famous for. This usually mean you need to write more code to achieve the same thing in Rails.

For example in Rails if you want to pass a variable to a view you can just use the instance variable.

Controller:
```
@my_home = "Home Page"
```
View:
```
<title><%= @my_home %></title>
```

In Phoenix you actually need to pass the variable to the view.

Controller:
```
my_home = "Home Page"
render(conn, "index.html", my_home: my_home)
```
View:
```
<title><%= @my_home %></title>
```


## 2. It's not as simple as Rails
With Phoenix 1.3, they introduced "context" which greatly differ from Rails. It took some time for me to figure it out and although I see the reason for them to introduce this concept but now it takes more time for me to decide which "context" does a model belongs to.

It actually reminds me of Django for some reason.


## 3. It doesn't play nice with vagrant/VM
Coming from a Rails background I'm used to setting up my development environment using Vagrant and Ubuntu. However, the latest version of [OTP](https://en.wikipedia.org/wiki/Open_Telecom_Platform) which is 21.1 have some weird bug around synced folders that if I were to edit my file in the host machine, the file would be corrupted and cannot be compiled. If I were to ssh to the guest machine and edit it, it works fine.

I have resulted to install OTP version 20 and even then it have some issue when serving static files. 

## 4. Phoenix, Arizona
You may get this result when you google for an answer.

## 5. The library is not that big
Phoenix is still relatively new and you don't have as much library as Rails. There is not "Devise" in Phoenix for example.

## 6. No problem finding answers
So far every problems that I have encountered have been solved either in Stackoverflow or by asking in the Phoenix slack group.

 The community is small but they are active.

## 7. Would I use it for my next project?
Yes, I love the direction they are heading with Phoenix. Eventhough it is more complex than Rails, but I always feel the complexity is helping me to become a better developer, which is what I am looking for.

## 8. Would I recommend this to beginners?
No, I would still recommend Rails. The reason is because of the introduction of context. It adds to another level of complexity that I think beginners would find it hard to grasp. Having said that, once they are familiar with Rails, I would have no problem in recommending Phoenix.