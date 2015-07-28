# WDI Melville - Project 2 - Forum
You can create posts, register accounts, view posts, log in, log out, write comments, and much more

### Trello planning board
[Trello Board](https://trello.com/b/4GbDQk0l/wdi-project-2-forum)

### Wireframes
Home page
![home page](/planning-images/Home Page.png)
Creating a post
![create post](/planning-images/Create Post-topic.png)
Viewing a single post
![view post](/planning-images/View Post-topic.png)

### ERD diagram
![ERD diagram](/planning-images/IMAG0336.jpg)

### APIs/Modules used
I used the [ipinfo.io](http://ipinfo.io) API to get location data when you create a post. Unfortunately, when running the server on your local machine, it will always give you an IP address of "::1", which you obviously can't get location info for. Because of this I just put in a default value for testing purposes.

To get the IP info, I used the REST-client ruby gem.

To enable markdown syntax usage in posts, I used the RedCarpet ruby gem.

-----------
## To see it live...
check it out [here](https://max-peterson-project-2.herokuapp.com/)