// go to http://unicode.org/emoji/charts/full-emoji-list.html and type in devtools console.
function getLen(str){
	let count=0;
	for(let c of str){
		if(c=='\t'){
			let spaces=8-(count%8);
			count+=spaces;
		}
		else{
			count++;
		}
	}
	return count;
}

function calculateTabsForList(list){
	let max=getLen(list[0]);
	let len=[max];
	for(let i=1;i<list.length;i++){
		len.push(getLen(list[i]));
		if(len[i]>max){
			max=len[i];
		}
	}
	let tabList=[];
	for(let i=0;i<list.length;i++){
		let tabs=Math.floor(max/8)-Math.floor(len[i]/8);
		let tabString="";
		for(let i=0;i<tabs;i++){
			tabString+="\t";
		}
		tabList.push(tabString);
	}
	return tabList;
}

//const prefix="emoji_";
//let emojiLabels = [];
emojiLabels = [];
//let chars = [];
chars = [];
$$("tr").filter(e => e.getElementsByClassName("chars").length > 0).map(e => {
	chars.push(e.getElementsByClassName("chars")[0].innerText);
	if (chars.includes("&zwj")) {
		chars = chars.slice(0, chars.indexOf("&z"));
	}
	let code = e.getElementsByClassName("code")[0].getElementsByTagName("a")[0].name.split("_")[0];
	let name = e.getElementsByClassName("name")[0].innerText.toLowerCase()
		.replace(/[\s]/g, "-")
		.replace(/[_]/g, "-")
		.replace(/[.:()"“”,’!]/g, "")
		.replace("&", "and")
		.replace(/[ãå]/g, "a")
		.replace("é", "e")
		.replace("í", "i")
		.replace("ô", "o")
		.replace("⊛_", "")
		.replace("ç", "c")
		.replace("#", "hashtag")
		.replace("*", "star");
	emojiLabels.push(`${prefix}${name}_${code}`);
})
//let tabs = calculateTabsForList(emojiLabels);
tabs = calculateTabsForList(emojiLabels);
console.log(tabs);
emojiLabels = emojiLabels.map((e, i) => `${e},${tabs[i]}# ${chars[i]}`);
emojiLabels = emojiLabels.join("\n");
copy(emojiLabels);
console.log(emojiLabels);
