const axios = require('axios');
const cheerio = require('cheerio');
const fs = require('fs');
const path = require('path');
const https = require('https');

const url = 'https://emojipedia.org/google';

axios.get(url)
	.then(response => {
		const $ = cheerio.load(response.data);
		const imageLinks = [];

		$('a.Emoji_emoji-image__aBPU4').each((index, element) => {
			const imageUrl = $(element).attr('data-src');
			imageLinks.push(imageUrl);
		});

		imageLinks.forEach((imageUrl, index) => {
			const fileName = `image_${index}.webp`;
			const filePath = path.join(__dirname, fileName);
			const file = fs.createWriteStream(filePath);

			https.get(imageUrl, response => {
				response.pipe(file);
			});
		});
	})
	.catch(error => {
		console.error('Error:', error);
	});