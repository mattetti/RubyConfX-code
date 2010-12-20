window.onload = function() {  
  leftJoystickWidth = $('#joystick-left').width();
  leftJoystickHeight = $('#joystick-left').height();
  
  rightJoystickWidth = $('#joystick-right').width();
  rightJoystickHeight = $('#joystick-right').height();
  
  // bg = Raphael('background', 500, 500)
  // bg.image("playstation-logo.jpg", 10, 10, 520, 120);
  
  paper = Raphael("canvas_container", 500, 250);
  jPaper = Raphael("joystick-left", leftJoystickWidth, leftJoystickHeight);
  rPaper = Raphael("joystick-right", rightJoystickWidth, rightJoystickHeight);
  leftJ = jPaper.circle(245/2, 100/2, 20).attr({fill: "#CCCCCC", "stroke-width": 8});
  rightJ = rPaper.circle(245/2, 100/2, 20).attr({fill: "#CCCCCC", "stroke-width": 8});

  leftJPressed = false;
  rightJPressed = false;

  itemX = 250;
  itemY = 125;
  
}

function circle(){
  paper.clear();
  var radius = 25;
  var x = itemX;
  var y = itemY;
    
  lastEdit = paper.circle(x, y, radius);
  lastEdit.attr({stroke: "#D55E4B", "stroke-width": 8});
  return lastEdit;
}

function square(){
  paper.clear();
  var width = 50;
  var height = 50;
  var x = itemX - (width/2);
  var y = itemY - (height/2);
  lastEdit = paper.rect(x, y, width, height);
  lastEdit.attr({stroke: "#FF6470", "stroke-width": 8});
  return lastEdit;
}

function triangle(){
  paper.clear();
  var x = itemX;
  var y = itemY;
  var g = 50;
  lastEdit = paper.path("M".concat(x,",",y,"m0-",g*0.58,"l",g*0.5,",",g*0.87,"-",g,",0z"));
  lastEdit.attr({stroke: "#399738", "stroke-width": 8});
  return lastEdit;
}

function cross(){
  paper.clear();
  var x = itemX;
  var y = itemY;
  var width = 50;
  var color = "#45507F"; 
  var crossPath = "M".concat(x-width,",",y,"m",width/2,"-",width/2,"l",width,",",width,"m-",width,",-",0,"l",width,"-",width,",0z")
  lastEdit = paper.path(crossPath);
  lastEdit.attr({stroke: color, "stroke-width": 8});
  return lastEdit;
}

var displayText = function(text, fontSize, extraAttr){
  fontSize = typeof(fontSize) != 'undefined' ? fontSize : 42
  paper.clear();
  lastEdit = paper.text(itemX, itemY, text);
  lastEdit.attr({"font-size": 42});
  if(typeof(extraAttr) != 'undefined'){
    lastEdit.attr(extraAttr);
  }
  return lastEdit;
}

function ps(){
  return displayText('PS');
}

function l1(){
  return displayText('L1');
}

function l2(){
  return displayText('L2');
}

function r1(){
  return displayText('R1');
}

function r2(){
  return displayText('R2');
}

function right(){
  lastEdit.translate(10, 0)
}

function left(){
  lastEdit.translate(-10, 0)
}

function up(){
  lastEdit.translate(0, -10)
}

function down(){
  lastEdit.translate(0, 10)
}

function leftJoystick(x, y){
  var xPercent = x / 255;
  var yPercent = y / 255;
  var x = leftJoystickWidth * xPercent;
  var y = leftJoystickHeight * yPercent;
  joystickLog('left Stick:' + x + ', '+ y)
  leftJ.attr({cx: x, cy: y})
}

function leftJoystickPressed(pressed){
  if(leftJPressed != pressed){
    var color = pressed ? "#00A653" : "#CCCCCC";
    leftJ.attr({fill: color});
    leftJPressed = pressed;
  }
}

function rightJoystickPressed(pressed){
  if(rightJPressed != pressed){
    var color = pressed ? "#00A653" : "#CCCCCC";
    rightJ.attr({fill: color});
    rightJPressed = pressed;
  }
}


function rightJoystick(x, y){
  var xPercent = x / 255;
  var yPercent = y / 255;
  var x = rightJoystickWidth * xPercent;
  var y = rightJoystickHeight * yPercent;
  joystickLog('right Stick:' + x + ', '+ y)
  rightJ.attr({cx: x, cy: y})
}

function darker(){
  lastEdit.attr({stroke: Raphael.getColor()})
}

function joystickLog(text){
  $('#joystick-log').text(text);
}

function debug(text){
  $('#debug').text(text);
}

var pad = function(num, totalChars) {
    var pad = '0';
    num = num + '';
    while (num.length < totalChars) {
        num = pad + num;
    }
    return num;
};

// Ratio is between 0 and 1
var changeColor = function(color, ratio, darker) {
    // Trim trailing/leading whitespace
    color = color.replace(/^\s*|\s*$/, '');

    // Expand three-digit hex
    color = color.replace(
        /^#?([a-f0-9])([a-f0-9])([a-f0-9])$/i,
        '#$1$1$2$2$3$3'
    );

    // Calculate ratio
    var difference = Math.round(ratio * 256) * (darker ? -1 : 1),
        // Determine if input is RGB(A)
        rgb = color.match(new RegExp('^rgba?\\(\\s*' +
            '(\\d|[1-9]\\d|1\\d{2}|2[0-4][0-9]|25[0-5])' +
            '\\s*,\\s*' +
            '(\\d|[1-9]\\d|1\\d{2}|2[0-4][0-9]|25[0-5])' +
            '\\s*,\\s*' +
            '(\\d|[1-9]\\d|1\\d{2}|2[0-4][0-9]|25[0-5])' +
            '(?:\\s*,\\s*' +
            '(0|1|0?\\.\\d+))?' +
            '\\s*\\)$'
        , 'i')),
        alpha = !!rgb && rgb[4] != null ? rgb[4] : null,

        // Convert hex to decimal
        decimal = !!rgb? [rgb[1], rgb[2], rgb[3]] : color.replace(
            /^#?([a-f0-9][a-f0-9])([a-f0-9][a-f0-9])([a-f0-9][a-f0-9])/i,
            function() {
                return parseInt(arguments[1], 16) + ',' +
                    parseInt(arguments[2], 16) + ',' +
                    parseInt(arguments[3], 16);
            }
        ).split(/,/),
        returnValue;

    // Return RGB(A)
    return !!rgb ?
        'rgb' + (alpha !== null ? 'a' : '') + '(' +
            Math[darker ? 'max' : 'min'](
                parseInt(decimal[0], 10) + difference, darker ? 0 : 255
            ) + ', ' +
            Math[darker ? 'max' : 'min'](
                parseInt(decimal[1], 10) + difference, darker ? 0 : 255
            ) + ', ' +
            Math[darker ? 'max' : 'min'](
                parseInt(decimal[2], 10) + difference, darker ? 0 : 255
            ) +
            (alpha !== null ? ', ' + alpha : '') +
            ')' :
        // Return hex
        [
            '#',
            pad(Math[darker ? 'max' : 'min'](
                parseInt(decimal[0], 10) + difference, darker ? 0 : 255
            ).toString(16), 2),
            pad(Math[darker ? 'max' : 'min'](
                parseInt(decimal[1], 10) + difference, darker ? 0 : 255
            ).toString(16), 2),
            pad(Math[darker ? 'max' : 'min'](
                parseInt(decimal[2], 10) + difference, darker ? 0 : 255
            ).toString(16), 2)
        ].join('');
};
var lighterColor = function(color, ratio) {
    return changeColor(color, ratio, false);
};
var darkerColor = function(color, ratio) {
    return changeColor(color, ratio, true);
};

// Use
// var darker = darkerColor('rgba(80, 75, 52, .5)', .2);
// var lighter = lighterColor('rgba(80, 75, 52, .5)', .2);
