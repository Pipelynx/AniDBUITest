# AniDBUITest
An iPhone app accessing the UDP API to anidb.net

This app is a work in progress and it does not have a name yet. As you know it is bad luck to name a child before it's third year :)

So far this app implements the main features of the anidb.net UDP API, meaning retrieval of database entries like Anime, Episodes, Characters and so on. It caches this data locally in a CoreData persistent storage and displays it in an iPhone UI which is very much unfinished at this point, though the back-end stuff works admirably.

My plan is to eventually split off the API access and CoreData code into a framework and make it available separately.
