---
title: miniTruco Client-Server API
excerpt: |
  |
    miniTruco is an implementation of the Brazilian Truco card game (also known as Truco Paulista or Truco Mineiro) for Java-enabled cellphones. One of its features is its multiplayer ability over the Internet. That is done by having a server software...
layout: post
comments: true
permalink: /archives/2008/01/minitruco_api.html/
robotsmeta:
  - index,follow
dsq_thread_id:
  - 1751442222
categories:
  - Portfolio
---
<span class="mt-enclosure mt-enclosure-image"><img title="multiplayer miniTruco running on a J2ME emulator" src="/archives/img/mt_multiplayer.jpg" width="250" height="222" class="mt-image-right" style="float: right; margin: 0 0 20px 20px;" /></span>[miniTruco][1] is an implementation of the [Brazilian Truco card game][2] (also known as Truco Paulista or Truco Mineiro) for Java-enabled cellphones.

One of its features is its multiplayer ability over the Internet. That is done by having a server software that hosts the games, and this server has a (somewhat) well-defined API that allows clients to connect to it.

This post describes how to interact with that server, so people can write their own clients in any platform they wish. Although most Truco players are Portuguese speakers, it was written in English to reach a wider audience (and in light of the recent addition of an English-language option to the J2ME miniTruco).

Both the server and the J2ME client are free (GPL) software, and albeit other clients are not obligated to be published under such a license, they are encouraged to do so.

<!--more-->

**Client-Server Gameplay**

Once a player (client) connects to the server, he must identify himself with a nickname. After that, he may enter or leave server rooms (in which games happen). Each room contains up to four players. The player who entered the room first is its manager, and he can kick unwanted players from the room, switch positions of players and change the manilha and deck styles.

When all the players in the room agree to play (there must be two at minimum), the remainder of the room is filled with computer-controlled players (using a randomly-picked strategy from the ones available in the game) and a game begins. When a game finishes, players can re-manifest their intention to play or leave the room.

**Protocol and Server Basics**

The server listens to incoming clients on port 6912, and the official miniTruco server is hosted at chester.servegame.org. Clients connect to that server on behalf of a player (all game logic happens inside the server, so there is no way to construct a &#8220;cheating&#8221; client).

Clients interact with the server by exchanging text lines. Text lines sent from the client are called **commands**, and text lines sent from the server are **notifications**.

Commands inform actions that a client may take in-game (say, play a card, ask for Truco, etc.) or outside of it (entering/leaving a room, selecting game rules, etc.).

Notifications inform the client about things that happen in the game or room he is in (or in the &#8220;lounge&#8221;, outside all rooms). For example, that a card was played, that a hand is over, or that an adversary rejected a Truco request. Errors are also delivered by notifications.

Although most commands trigger immediate notifications (e.g., when you send the &#8220;Play Card&#8221; command with a valid card, the server notifies that you have played the card), commands and notifications are asynchronous. That means client software is expected to react to notifications at any time, and it should not wait for anything after it sends a command.

**Command/Notification Format and Data Types**

To balance human-readability and machine optimization, commands and notifications use a short, yet descriptive format. Both are composed of one letter indicating the nature of the command/notification, optionally followed by a space and one ore more arguments (each one separated by a space also).

A notification is terminated with a carriage return+newline sequence (&#8220;\r\n&#8221; in C/Java notation), and commands are [expected][3] to end in either this same sequence, or one of a carriage return (&#8216;\r&#8217;) or newline (&#8216;\n&#8217;).

Arguments may be text strings (e.g., a user name), boolean (represented by a T or F character), numbers or cards.

Numbers can represent rooms (the range is from 1 to the number of rooms returned in the L notification), players (by their position in the room/game, ranging from 1 to 4 in counter-clockwise direction), teams (team 1 is players on positions 1 and 3, team 2 is players on positions 2 and 4).

Cards composed by either a number or uppercase letter representing the face falue (A, 2, 3, 4, 5, 6, 7, Q, J or K), immediately followed by a lowercase letter representing the suit (chosen after its portuguese name): c for hearts (&#9829;, copas), o for diamonds (&#9830;, ouros), e for spades (&#9824;, espadas) and p for clubs (&#9827;, paus). For example, the king of diamonds would be represented by Ko, the seven of spades would be 7e.

**Commands**

The easiest way to grasp the commands (and notifications) is to run the server on your computer (requires [Java][4] 5 or higher) and test them by yourself. Just follow these steps:

1.  Download the [miniTruco server][5];
2.  Run it locally by typing *java -jar miniTrucoServer.jar* on a terminal/console window (Command Prompt, aka &#8220;cmd&#8221; on Windows);
3.  Interact via telnet, by issuing *telnet localhost 6912* from another terminal(*).

(*) In Windows, you may need to enter *telnet*, then *set localecho* and only after that *open localhost 6912* if you want to see what you are typing. But even if you don&#8217;t, commands will work after you hit ENTER &#8211; you just won&#8217;t see them as you type ([more info on Windows telnet][6]).

By working with telnet you can experiment with commands and see the notifications caused by them. With two or more telnet windows, you can simulate the entire game cycle.

They are listed on the order of a typical session interaction. The first block is for player and server identification (other commands won&#8217;t work until N succeeds, and W may be used in the future to enable backwards compatibility, if needed &#8211; for now, just send W on startup and don&#8217;t worry about the W notification).

The second block is for identified players who are browsing rooms, and the third are in-game commands. Most (not all) commands generate a same-name notification (check notifications session below) when succeed and an error (X) notification on failure &#8211; regardless of that, you should process notifications asynchronously (see previous sessions).

In-game commands only work on the appropriate time (e.g., you can only play/raise in your turn, only accept/reject raises if a raise was made, etc.), otherwise they are ignored (without notification). V, T and F notifications allow clients to monitor current state.

Optional parameters are denoted with [brackets].

**W** Asks for a version number notification.
**N nick** Sets the player&#8217;s nickname to nick (must be unique, and only contain [A-Z], [a-z] ,[0-9] or [!@$()-_.]).

**L** Asks for a room list.
**I [number]** Asks information about the room with that number (used to &#8220;spy&#8221; a room). If number is ommited, asks information about the current room (useful for a &#8220;refresh&#8221; button). Neither spy or refresh are mandatory features.
**E number** Enters the room with that number.
**S** Leaves the current room, if any. If the user is playing a game, leaves both game and room.
**R dm** (manager only) Sets the rules for the room. d is T for clean deck and F for dirty deck, m is T for old manilha, F for new manilha. Empty rooms revert to FF
**V** (manager only) Switches adversaries (left becomes right, and right becomes left).
**O** (manager only) Changes your partner by cycling other players (partner becomes right foe, right foe becomes left foe, left foe becomes partner).
**K player** (manager only) Kicks the player at that position (1 to 4), making it leave the room.
**Q** Announces the player is ready to start (the game begins when all players in the room do this).

**J card [mode]** Plays the named card. If mode is T (default is F), plays it closed (other players won&#8217;t see the card value).
**T** Requests a increase in the bet (truco, six, nine or twelve).
**D** Accepts a bet increase.
**C** Rejects a bet increase.
**H decision** If decision is T, accepts a hand of 11. If false, rejects it.

**Notifications**

**N name** The player sucessfully set his nick to name.
**L number[|number|number...]** Room list. The argument part is a list of how many players are there in each room, separated by pipes. For example: L 4|0|2 means the server has three rooms, room 1 is full (four players, human or otherwise), the second has zero players, the third has two players. Implementations should show a human-readable room list, using &#8220;empty&#8221; and &#8220;full&#8221; to denote 4 or 0 players.
**E room** Informs the client sucessfully entered a room. Use it only to update client status, since the information needed to show him in the room is on the I notification (which always follows this one).
**S** &#8211; Informs the client left the room. Applcations should notify the user and issue a room list command.
**I room name1|name2|name3|name4 ABCD manager dm**. Details room information (in response to entering or asking info about a room. First parameter is the room number, second is a pipe-separeted list of the player&#8217;s names (an empty name means a CPU player will be on that postion if the game starts), third is the boolean (T or F) for each player&#8217;s &#8220;want to play&#8221; status, fourh is the position of the manager and the last paramter is a boolean pair indicationg the rules for the room (see R command). Clients should look for the registered player&#8217;s nickname to find his position, and position the others counter-clockwise. Whenever anything on a room with no game running changes, all players in that room receive this notification.
**P** position</strung>A new game started. The client player is at that position.
**M c1 c2 c3 c4**A hand started. Your cards are c1, c2 an c3. If we are playing with new styule manilhas, the fourth card is the one turned (e.g., if a 3 &#8211; of whatever suit &#8211; was turned, the 4s are the manilhas).
**V position closed**It&#8217;s the turn of the player on that position. If Closed is T, the person can play a closed card, otherwise he can&#8217;t (and it will be played open if he insists).
**J position [card]**The player at that position played card (if card is ommited, it was played closed).
**R team position** End of a turn (rodada), followed by the team that won and the player who will play the next turn (for cosmetic purposes, a V notification will be sent anyway).
**O points1 points2** End of a hand, followed by the points each team has now. Clients should compare with previous score to determine who won the hand and present that info.
**G team** Game Over. The team that won is the argument.
**A position** The player in that position left the game (or disconnected).
**T position value** Player in that position asked for a raise in stakes (truco, six, nine or twelve). The value (3, 6, 9 or 12) determines that.
**D position value** Player in that position accepted a raise (hand now worth the presented value</strong>
**C position** Player in that position declined from the raise
**F c1 c2 c3** Informs that the client is on a Hand of 11 (and the partner has the cards c1, c2 and c3)
**H position status** Player in that position accepted (status=T) or rejected (status=F) the hand of 11.

The following notifications are error notifications. They are all variations of the X notification, and a typical client action would be to display a message in the equivalent of a modal dialog box in the client plaform.

**X CI** Invalid command.
**X JE room** You are already on the that room (e.g., if you try to &#8220;jump&#8221; from one room to another)
**X CH** Full room (try another)
**X SI** Invalid room
**X FS** You are not in a room
**X NI** Invalid name
**X NE** Name already in use
**X JO** Tried to do out-of-game action while in-game
**X JI** Invalid player (position) &#8211; player must range from 1 to 4
**X NO** Can&#8217;t do that action until you set a nickname</p>

A final note: O and V commands were created with mobile phones in mind. Desktop implementations can have more clever interfaces (e.g., drag-and-drop to position players) and send a seuqence of O/V commands to position them after a change (both generate I notifications, so the last notification will reflect the final situation). In fact, feel free to create better metaphors for current concepts (such as &#8220;rooms&#8221;) &#8211; they were created with mobile phones in mind.

That&#8217;s it! If you want some ideas for suitable platforms, I think desktop clients would be nice. Flash is a sure contender for browser-based clients, and I&#8217;d also love to see a pure DHTML/JavaScript client (with some sort of AJAX-based gimmick, powered by middle-tier server code to bridge the stateful TCP/IP conection with stateless HTTP calls) &#8211; either of these two would be better than my current approach of using Microemulator as an applet &#8211; it&#8217;s way too heavy.

When you have any sort of working implementation, please [let everyone know][7]. Good luck!

**UPDATE**: As of April 29, 2008, the server sends an empty notification after a few seconds of inactivity. Clients were already expected to ignore those empty lines (but I did not state that explicilty here, so now I am). This is done to test for conneciton inactivity (I was just relying on socket status, but TCP/IP can be a bit sensitive &#8211; that, coupled to Java&#8217;s layered socket approach led to an endless block even after a mobile had disconnected, so I resorted to timeouts on blocks, coupled with the empty notification, which seems to solve the problem).

 [1]: /minitruco_en/
 [2]: http://en.wikipedia.org/wiki/Truco#Truco_in_Brazil
 [3]: http://java.sun.com/j2se/1.5.0/docs/api/java/io/BufferedReader.html#readLine()
 [4]: http://www.java.com/download/java/
 [5]: https://github.com/chesterbr/minitruco-j2me/tree/master/miniTruco/deploy/miniTrucoServer.jar
 [6]: http://technet.microsoft.com/en-us/library/bb491013.aspx
 [7]: http://groups.google.com/group/minitruco
