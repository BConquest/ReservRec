# ReservRec
## Play any sport, any time.
A Flutter application.

# Technologies Used
 - [Flutter](https://flutter.dev/)
 - [Dart](https://dart.dev/)
 - [Firebase](https://firebase.google.com/)

# Deliverables
[Deliverables](https://bconquest.github.io/ReservRec/deliverables)

# About
[bryant](./bryant.md) 

[zach](./zach.md)

[phillip](./phillip.md)

[ryan](./ryan.md)

# Our Mission
At ReservRec, we want to help connect students to create more enjoyable and memorable experiences on the field.
Therefore we strive to make playing a sport possible no matter who or where you are.
By using our app, students across the nation can create, enjoy, and play any sport, any time.

# Goals
 [x] Only Verified People can Join
   - This is done through firebase authentication and regex parsing to make sure the email has a valid ending.
   - Valid endings can be added with Managers.
   
 [x] Have it work for different locations
   - Each school is a different colection in firebase.
   - Each school has valid locations for activites to happen and valid email endings.
   
 [ ] Coordination with Rec-Center
   - This was not done, due to covid and not having enough time.
   - If this was done we could try to work with them to use an api to reserve different fields.
   
 [ ] Different Notifications
   - This was partly done but to be able to subscribe to a sport we would have to limit the sports to only system defined ones. Another option would have been to have sport specific notifcations but this would have been hard due to different spellings and names.
   
 [x] Separate UI for manager vs users
   - This was done and allows for managers to see all the posts that have been made but does not allow them to create post. The opposite is true for players.
