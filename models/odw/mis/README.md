# What is this for?

MIS = Mariner Internal Strategies
Perform = Fixed Income trading
Moxy = Bond trading

[Lucid chart design](https://lucid.app/lucidchart/648b59ff-808d-4571-b25f-a9c57cff25e4/edit?invitationId=inv_1bcc1c40-06e3-4cef-9207-1c316c2a4799&page=OFLDii4v6bbB#)

# Background


# Things you should know

Primary sources are Orion and Salesforce Compass.

We repliace Orion data from redshift to snowflake and denormalize it into usable
datasets.

From there we reference the head records from Orion as part of the MIS build process and determine which accounts are bound for each destination. These head
records produce the snapshot that is used for loading each trading system.


# Perform

Orion data.
Salesforce data.
Perform data.

Create the account and asset builds.

SQL to files.

What is the difference between regular upload and review upload?

# Moxy


