# Project 3 - Instagram

Instagram is a photo sharing app using Parse as its backend.

Time spent: 20 hours spent in total

## User Stories

The following **required** functionality is completed:

- [X] User can sign up to create a new account using Parse authentication
- [X] User can log in and log out of his or her account
- [X] The current signed in user is persisted across app restarts
- [X] User can take a photo, add a caption, and post it to "Instagram"
- [X] User can view the last 20 posts submitted to "Instagram"
- [X] User can pull to refresh the last 20 posts submitted to "Instagram"
- [X] User can tap a post to view post details, including timestamp and caption

The following **optional** features are implemented:

- [ ] Run your app on your phone and use the camera to take the photo
- [X] User can load more posts once he or she reaches the bottom of the feed using infinite scrolling
- [X] Show the username and creation time for each post
- [X] User can use a Tab Bar to switch between a Home Feed tab (all posts) and a Profile tab (only posts published by the current user)
- User Profiles:
  - [X] Allow the logged in user to add a profile photo
  - [X] Display the profile photo with each post
  - [ ] Tapping on a post's username or profile photo goes to that user's profile page
- [ ] After the user submits a new post, show a progress HUD while the post is being uploaded to Parse
- [ ] User can comment on a post and see all comments for each post in the post details screen
- [ ] User can like a post and see number of likes for each post in the post details screen
- [X] Style the login page to look like the real Instagram login page
- [ ] Style the feed to look like the real Instagram feed
- [ ] Implement a custom camera view

The following **additional** features are implemented:

- [X] User can add and edit a biography from their profile
- [X] User can tap on a picture from their profile view to view the corresponding post's details

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. I would be interested in discussing how to implement the Instagram likes feature, not only being able to store and display the number of likes each post has, but also whether or not a user has previously liked a given post.
2. I also wonder whether we can edit given Parse models such as the PFUser class in order to account for added properties.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/link/to/your/gif/file.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [Kap](https://getkap.co/).

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library
- [Parse](https://github.com/parse-community/Parse-SDK-iOS-OSX) - utilize the Parse server backend
- [Parse/UI](https://github.com/parse-community/Parse-SDK-iOS-OSX) - utilize the Parse server backend
- [DateTools](https://github.com/MatthewYork/DateTools) - date and time handling
- [UITextView+Placeholder](https://github.com/devxoul/UITextView-Placeholder) - a missing placeholder for UITextView

## Notes

Describe any challenges encountered while building the app.

One of the challenges I encountered while building the app was understanding
PFObjects and making sure that object types were compatible. I read up on them 
online in order to better understand how to use them in the app.

I also focused on incorporating my manager's suggestions into this project's code, 
taking note to extract code where possible and utilize meaningful function names.
There was some challenge in finding a balance between extracting out too much and 
not doing so enough.

## License

    Copyright 2022 Kathy Zhong

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
