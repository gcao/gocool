var offsetfromcursorX = 12;
var offsetfromcursorY = 10;

var offsetdivfrompointerX = 10;
var offsetdivfrompointerY = 14;

var ie = document.all;
var enabletip = false;

function ieDocument() {
  return (document.compatMode && document.compatMode!="BackCompat" && !window.opera)? document.documentElement : document.body;
}

function mozilla() { return document.getElementById && !document.all; }

function supportedBrowser() { return document.all || mozilla(); }

function mousetip(text, width, color) {
  var tooltip = document.getElementById('cursor')

  if ( typeof( width ) == "undefined" ) width = 250;
  if ( typeof( color ) == "undefined" ) color = "#FFFFCC";

  if (supportedBrowser()) {
    if (typeof width != "undefined")
      tooltip.style.width = width + "px";
    if (typeof color != "undefined" && color != "")
      tooltip.style.backgroundColor = color;

    tooltip.innerHTML = text;
    enabletip = true;
    return false;
  }
}

function currentXPositionOf(element) { return (mozilla() ? element.pageX : event.clientX+ieDocument().scrollLeft); }
function currentYPositionOf(element) { return (mozilla() ? element.pageY : event.clientY+ieDocument().scrollTop); }

function positiontip(element) {
  var mousePointer = document.getElementById('pointer');
  var tooltip = document.getElementById('cursor');

  if (enabletip) {
    var nondefaultpos = false;
    var currentXPosition = currentXPositionOf(element);
    var currentYPosition = currentYPositionOf(element);

    var winwidth = ie && !window.opera? ieDocument().clientWidth : window.innerWidth - 20;
    var winheight = ie && !window.opera? ieDocument().clientHeight : window.innerHeight - 20;

    var rightedge = ie && !window.opera? winwidth - event.clientX - offsetfromcursorX : winwidth-element.clientX-offsetfromcursorX;
    var bottomedge = ie && !window.opera? winheight - event.clientY - offsetfromcursorY : winheight-element.clientY-offsetfromcursorY;

    var leftedge=(offsetfromcursorX<0)? offsetfromcursorX*(-1) : -1000;

    if (rightedge < tooltip.offsetWidth) {
      tooltip.style.left=currentXPosition-tooltip.offsetWidth+"px";
      nondefaultpos = true;
    } else if (currentXPosition < leftedge) {
      tooltip.style.left="5px";
    } else {
      tooltip.style.left = currentXPosition + offsetfromcursorX - offsetdivfrompointerX + "px";
      mousePointer.style.left = currentXPosition + offsetfromcursorX + "px";
    }

    tooltip.style.top = currentYPosition + offsetfromcursorY + offsetdivfrompointerY + "px";
    mousePointer.style.top = currentYPosition + offsetfromcursorY + "px";

    tooltip.style.visibility = "visible";
    if (!nondefaultpos) {
      mousePointer.style.visibility = "visible";
    } else {
      mousePointer.style.visibility = "hidden";
    }
  }
}

function hidemousetip() {
  if (supportedBrowser()) {
    enabletip = false;
    document.getElementById('pointer').style.visibility = "hidden";
    var cursor = document.getElementById('cursor');
    cursor.style.visibility = "hidden";
    cursor.style.left = "-1000px";
    cursor.style.backgroundColor = '';
    cursor.style.width = '';
  }
}

document.onmousemove=positiontip;
