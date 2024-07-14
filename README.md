# Emoji Emission

## Description

Program to scrape all Google android and emoji kitchen emojis, along as their corresponding names, in order to take in 2 emojis and provide the merged emoji.

## How it Works

* Scrape all Google emojis and labels from ![Unicode.org](https://unicode.org/emoji/charts/full-emoji-list.html).
* Scrape all emoji kitchen emojis.
* Rasterize each svg image file to a bitmap (with a fixed width and height).
* Algorithm to convert each 24 bit value (3 8 bit rgb values) into 4 bit rgbi.
* Convert bitmap to a hex code where each digit is rgb value in 4 bits (rgbi).
* Repeat for both emojis:
  * Display available emojis.
  * Take in emojis.
   * If asterik on end of input, then regex find emoji labels that match input.
* Display merged emoji (if available).
