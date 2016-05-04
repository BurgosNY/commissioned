
document.getElementById('searchbutton').onclick = function () {

    var text = document.getElementById('search').value;

    var searchString = encodeURI(text.split(' ').filter(
	(s) => s.length > 0
    ).join(' '));
    if (searchString.length >0) {
	document.location = 'search?q=' + searchString;
    }
};


var togglers = document.getElementsByClassName('readtoggle');

for (var i = 0; i < togglers.length; i+=1) {
    (function () {
	var b = togglers[i];
	b.onclick = function () {
	    fetch('toggleread/' + b.id).then(function (resp) {
		return resp.json();
	    }).then(function (json) {
		if (json.readStatus) {
		    b.innerHTML = "Mark Unread";
		} else {
		    b.innerHTML = "Mark Read";
		}
	    });
	};
    })();
}	    

