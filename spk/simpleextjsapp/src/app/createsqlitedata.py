#!/usr/bin/python

import os, sys
import sqlite3

con = sqlite3.connect('api.db')

cur = con.cursor();

# Create table
cur.execute('''CREATE TABLE magazines
               (identifier text, title text, description text)''')

# Insert data
cur.execute("INSERT INTO magazines VALUES ('1','Wired','Geek magazine')")
cur.execute("INSERT INTO magazines VALUES ('2','Elle','Mode magazine')")
cur.execute("INSERT INTO magazines VALUES ('3','Green','Eco magazine')")


# Save the changes
con.commit()

