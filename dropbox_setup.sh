#!/bin/sh

########################################################
# after visiting the URL generated by dropboxd
########################################################

dropbox start
dropbox status
dropbox lansync y
dropbox exclude add Bookmarks Public Resume interfacelift

sleep 1s

cd ~/Dropbox
dropbox filestatus
