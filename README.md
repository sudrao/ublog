UBLOG  
=====
[![travis](https://secure.travis-ci.org/sudrao/ublog.png)](http://travis-ci.org/sudrao/ublog)

ublog (pronounced You-blog) is a micro-blogging application meant for corporate use. 
The original (Rails 2.3.2) source code was a contribution from Cisco Systems, Inc. and is 
also available here. Select rails2 branch on sudrao/ublog.

The current source is the Rails 3.1 version.

STATUS: Upgrade to Rails 3.1 mostly complete. Not all features are tested yet.

LICENSE: MIT

Overview
========

ublog was created specifically to address the information security concerns 
that corporations have when using cloud based services. 
All data in ublog is stored in a server inside the Company firewall
and is not accessible from outside, except via VPN. This makes it possible
to post confidential information on ublog.

ublog can be used as a simple communication application to send 140 character
messages and hyperlinks. Other features include search, threads, attachments, 
groups, group nudge, hash tags, and a client replacement called Narrow view mode 
(see Tips and Tricks).

Installation
============

Dependencies
------------

* ImageMagick

* An auth module. You also need to have some way to authenticate users. This will vary
for each Company.

* sudrao/bitcompress

Platforms
---------

Tested on Mac OS X and Linux. Windows is not supported yet.

How to use ublog
================

Log into ublog
--------------

Click on the ublog link e.g. http://ublog.company.com/  and log in with your
Company user id and password. The first time you log in, a personal ublog
account will be created for you. You will then be on your home page. You can
bookmark that page. When you restart your browser or use another browser you
will be prompted to log in again.

Note: if you enter ublog using a URL for a group home page or another
person's home page you should click the "Follow" button there to subscribe.
After that you can go to your personal home page by clicking the ublog logo
at top left and follow the remaining instructions here.

Add a photo
-----------

Click the ublog logo at top left if you are not already on your personal
home page. You will see a placeholder photo on the right side of your home
page. Click it to add your photo. You need to have a picture file with .png,
.jpg, or .gif extension on your computer to upload. Follow the upload
instructions. If your picture is not a square shape to start with, it is
highly recommended to first use a photo editor and crop the photo to a
square shape. This is because ublog uses a square format and it will
compress or elongate your picture if it is not square already. Hint: right
click the image file in Windows and select Microsoft Office Picture Manager
to open it and click Edit to do the cropping.

Type a message
--------------

Answer the question, "what are you doing?" in the box provided. Or type
anything you like. Just be aware that messages are limited to 140
characters. Press enter or click the update button to save your message. It
will appear just below with your user id. Optionally, attach a file before
clicking the "Update" button. Attachments are currently restricted to images
and a few other common file types. Attachments appear either as a thumbnail
or the word "Attached" on the message and can be clicked for view/download.

Find and follow other ublog users
---------------------------------

You can search for other Company users using the Search link in ublog. Search
for their user id or name. Click and go to another user's home page from the
search result. You can also reach another user's home page by clicking on
their user id or photo in a message. Once there, you can click the Follow
button to start following that user. Following means that user's messages
will be shown on your home page as well as their's.

Reply to someone
----------------

There are three ways to reply to someone. If you see a message from someone,
you can click the reply link on that message and type in your reply. The
reply will appear in both your home page as well as the person or group to
whom you replied. Another way is to visit a group or another person's home
page and type in something in their message box. Yet another way, is to stay
on your home page and start a message with @userid ... where userid is that
other person's Company user id or group name. See more information about
groups below.

Threads
-------

Replies get automatically threaded if you use the reply link on any message.
You can reply to yourself to take advantage of threading. Threaded messages
have a discussion bubble icon. Mouse over the recepient's ublog id to see
the previous message in thread. Click the  icon to see all messages in
thread.

Email Digest
------------

If you like email then you might want your friends messages delivered to
your email inbox. You can enable an email digest delivery by visiting the
Subs link at the top of your home page. On that page, enable email by
selecting an email notification period and clicking the Set button. If you
don't do anything else, you will get email from ublog with replies from
other users which were directed to you.

In addition to replies, you can selectively enable email delivery for
individual accounts that you already follow. You need to visit and click the
"follow" button on the other accounts beforehand. Otherwise you will not see
those accounts listed on the Subs page.

The email digest comes to your inbox. It will contain messages posted to the
accounts you selected.

Note that if you set up or change the email settings, either time period or
accounts for email notify, then ublog assumes you are already updated and
caught up with all your messages. You will only get a digest of messages
that come in after that.

Groups
------

Groups are ublog accounts for a group of ublog users. Anyone can create a
group. Groups are very much like regular ublog accounts. Once created,
people can reply to the group and follow the group. Groups can be public or
private. Public groups are accessible to all ublog users. Anyone can follow
or post to the group. Private groups limit participation. The owner
initially controls the group membership. After members are added to the
private group, all members have the same privileges of adding or removing
members in the private group. Only members can post to a private group. In
addition, the messages are visible only to members.

Group email nudge
-----------------

For groups that want to migrate from email to ublog, the group nudge feature
can help. Once set up, ublog will remind group members via email to access
ublog and read recent updates on a ublog group. These members don't even
need to have a ublog account to receive the nudge but are encouraged to log
in.

First, you set up a ublog group as described above. Next, as creator and
owner of the group, visit the "Subs" link within the group page. Here set an
email notification period as well as a Company mailing list (alias,) and click
the "set" button.

Whenever one or more messages are posted to the ublog group within the
notification period, an automatic email will be sent to the mailer list
indicating that new messages are available on ublog. Note that the full
content of the ublog messages are not sent in the email message. This is to
encourage group members to visit ublog directly and participate in the
group's discussion via ublog.

As group members get used to checking and updating on ublog regularly, they
can unsubscribe from the mailing list that was used for the group
nudge. To allow unsubscribe, it is recommended to use a brand new mailer
list created just for this purpose and subscribe group members individually,
and not by reusing existing lists.

Tags
----

Tags are any words in your message starting with the # sign. For example,
the message, `"Any update on #collaboration tools?"` will create a tag called
collaboration within ublog. This message along with any new messages with
*`#collaboration`* will be available in a special tag page for collaboration.
You can find existing tags using the Tags link at the top. Tags are a simple
way to keep related messages together. Tagged messages also appear in the
usual place in your account and tags can also be in replies.

Recently used tags appear automatically on each home page. By using a tag in
your message you can get your message noticed by all ublog users, whether
they follow you or not. This is a way to advertise and cross-pollinate ideas
across groups.

Search
------

Indexed search is available for users, groups, messages, and tags. Click the
search link. Type in some words in the search box and click "Find now." The
results show the number of hits in each of these types and another click
will get you the results for one type. Click a second time to hide the
results.

Search words can end in * to indicate a "wildcard". Also, you can use OR
between words (uppercase OR) otherwise the default is AND.

RSS notification
----------------

ublog can generate Atom and RSS feeds. To get the feed from any account,
click the RSS icon  on any page. Paste the suggested URL into any RSS reader
as the subscription URL. That's it. You should start receiving messages from
that account in your RSS reader. You can follow individual or group accounts
via such feeds. Note that private group accounts are password protected and
you need to be a member of that group to get those messages.

To get an RSS feed for all public messages in ublog, visit the "Timeline"
link on any page. The RSS icon on that page can be used to get the RSS URL
for all ublog messages.

Firefox and other browsers that support RSS will show an RSS icon when you
visit any ublog page that has RSS support. That's another alternative.
Firefox shows this icon at the top in the same box as the page URL, toward
the right end.

URL Shrinking (needs sudrao/bitcompress installed)
-------------

Web addresses tend to be very long at times and consume valuable characters
in your ublog message. There is a link called "Shrink my URL" on ublog pages
to reduce any URL's length. Click this link, then paste your long URL into
the box and click the Shrink button. It will display a URL starting with
http://bit.company.com/... Right click and copy this new URL, then paste into
your message.

The bit.company.com server saves your original URL. Since this server is
inside the Company firewall, it is safe to shrink Companyinternal URL's using
this service. When anyone clicks on a shortened URL, it looks up its
database and redirects to the original URL.

Note: bitcompress is a Sinatra app that goes with ublog. It is recommended over
outside URL compression websites because URL's often contain confidential project 
names or other sensitive information.

Twitter and Yammer Cross-posting
--------------------------------

If you use Twitter, you can now post a message on ublog with a #twt tag and
it will appear on your Twitter account after a short delay. Similarly, if
you use Yammer, you can post a message on ublog with a #yam tag and it will
appear on Yammer's Company network. Before doing this, you need to have a
Twitter or Yammer account and set up your ublog account for cross-posting.
Just visit http://ublog.company.com/twitter or http://ublog.company.com/yammer
as appropriate, and follow the instructions there.

Once set up, you can also post on Twitter or Yammer with a #ublog tag and
the message will appear in ublog after a short delay. This allows you to
post to ublog indirectly from SMS text messages or Twitter or Yammer
clients. Check Twitter and Yammer sites for more information on how to use
those services with SMS and clients.

If you use both Twitter and Yammer then you can enable each one using the
links provided above. After that you can use #twt and #yam simultaneously in
your ublog post and cross-post to the other two sites.

Embed ublog on Your Website
---------------------------

If you already have a group website in the Company, you may be able to add ublog
to it. Your ublog group page on ublog can appear on your website. This needs
a little work on the group website but essentially you use ublog's embed or
iframe features for this. Any ublog home page URL with a .json, .embed, or
.iframe extension can be used. .json and .embed are read-only views while
.iframe allows two-way communication.

Tips and tricks
===============

* Clicking the ublog logo  takes you to your home page from anywhere in
ublog.

* Clicking the "All" button shows all messages on ublog. The "Mine" button
shows your messages, and from those you follow. Both options show public and
any private messages you are entitled to see. Use the Timeline link to see
all public messages on ublog.

* You can delete your own messages for example to correct something. Use the
icon on the message.

* There are buttons for "Narrow view" and "Mobile view" at the bottom of
your home page. Use the Narrow view to simulate a desktop client. Make the
browser window narrow and short while in this mode.  Mobile view is similar
to narrow view but it is automatically selected when you log in from an iPhone 
or Blackberry or other mobile device. Mobile view does not use Javascript.

* There is an easy to remember URL for each user and group: the ublog URL
plus the user id or group id. For example, http://ublog.company.com/jdoe will
go to jdoe's ublog home page.
