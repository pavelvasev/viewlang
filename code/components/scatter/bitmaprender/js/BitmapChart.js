/*
  todo
  opacity (qml)


*/

//alert(15);
var chartMap = {};

function splitColor(color) {
  return [(color>>16)&255,(color>>8)&255,(color)&255,(255 - ((color>>24)&255))&255 ];
}

function numToHexC(num) {
  var r = num.toString(16);
  if (r.length == 1) return "0"+r;
  return r;
}

function colorToHex(colorArr) {
 return numToHexC(colorArr[0])+numToHexC(colorArr[1])+numToHexC(colorArr[2]);

}

function BitmapChart( targetDivId, dataProvider, histogram, pixelColor, shift, pixelRenderFunction, selectionChangedHandler ) {
  console.log( "BitmapChart for ",targetDivId );
    
	chartMap[ targetDivId ] = this; 

	if (!pixelColor) pixelColor = [0,0,1];
	
	if (pixelColor.length) {
	  this.color = pixelColor.map( function(x) { return x*255; } );  // eg input [1,0,0.5]
	  if (this.color.length == 3) this.color.push(255); // alpha
	}
  else
    this.color = splitColor(pixelColor); // eg 0xff0070
  //this.color = [0,0,255,255];
    

	if (!pixelRenderFunction)
	  pixelRenderFunction = makeDrawCross( this.color[0],this.color[1],this.color[2],this.color[3] );
	
	this.borderSize = 30;
	this.segments = 10;
	this.renderTime = 0;
	this.opaque = false;
	
	this.dataProvider = dataProvider;
//	console.log("testing data..");
//	console.log(dataProvider[0][0]);
	
	this.targetDivId = targetDivId;
	this.targetDiv = $( "#"+this.targetDivId );

	this.selectionChangedHandler = selectionChangedHandler;
	
//	this.mouseLabel = $( "<div id='mouseLabel' style='position:absolute; text-shadow: 2px 2px 2px #FFF; color:#fff; background-color: #000; z-index:20000;'></div>" )

//	this.mouseLabel = $( "<div id='mouseLabel' style='position:absolute; color:#fff; background-color: #000; z-index:20000;'></div>" )
  //console.log(colorToHex(this.color));

    if (!shift) shift=0;
    this.shift = shift;
  //console.log("used shift=",this.shift);
	this.mouseLabel = $( "<div id='mouseLabel"+this.targetDivId+"' style='position:absolute; color:#fff; background-color: #" + colorToHex(this.color)+ ";margin-top:"+shift+"px; z-index:20000;'></div>" )
	this.selectionDiv = $( "<div id='selection' style='position:absolute; background:red; opacity:0.4; z-index:20000; '></div>" )
	this.isSelecting = false;
	
	$("body").append(this.mouseLabel);
	$("body").append(this.selectionDiv);
	
	var chart = this;
	if(document.ontouchmove === undefined){
		this.targetDiv.mousemove( function(event) { chart.mouseMoveHandler(event) } );
		this.targetDiv.mouseover( function(event) { chart.mouseOverHandler(event) } );
		this.targetDiv.mouseout( function(event) { chart.mouseOutHandler(event) } );
		this.targetDiv.mousedown( function(event) { chart.mouseDownHandler(event) } );
	
		$("body").mouseup( function(event) { chart.mouseUpHandler(event) } );
		$("body").mousemove( function(event) { chart.bodyMouseMoveHandler(event) } );
	}else{
		$("body")[0].ontouchstart = function(event) { chart.mouseDownHandler(event) };
		$("body")[0].ontouchend = function(event) { chart.mouseUpHandler(event) };
		$("body")[0].ontouchmove = function(event) { chart.bodyMouseMoveHandler(event) };
	}
	
	var chart=this;
	$(window).resize( function() { chart.resize() } );
	
   if ( window.orientation != undefined )
     window.onorientationchange = function() { chart.resize() };
	
	
	this.histogram = histogram;
	
	if (pixelRenderFunction != undefined && pixelRenderFunction != null)
		this.pixelRenderFunction = pixelRenderFunction;
	else
		this.pixelRenderFunction = drawSinglePixel;

	
	this.selection = [0,1,0,1];
	
	this.computeMinMax = this.computeMinMax2;

	// this.resize();

	this.horizontalAttribute = 0;
	this.verticalAttribute   = 1;
	this.computeMinMax();
	this.reset();

	return;

	// тут ничего пока не происходит более.. ретурн однако

	this.computeMinMax();
	
	// this.horizontalAttribute = "x";
	this.horizontalAttribute = 0;
	this.horizontalMin = this.dataMinMax[0];
	this.horizontalMax = this.dataMinMax[1];
	this._horizontalMin = undefined;
	this._horizontalMax = undefined;
			
	// this.verticalAttribute = "y";
	this.verticalAttribute = 1;
	this.verticalMin = this.dataMinMax[2];
	this.verticalMax = this.dataMinMax[3];
	this._verticalMin = undefined;
	this._verticalMax = undefined;
	
	this.mouseDownX = 0;
	this.mouseDownY = 0;
	
	this.resize();
}

BitmapChart.prototype.computeMinMax2 = function() {
  var qq = this.dataProvider.length;
  var r = [null,null,null,null];
  var o;
  var x;
  var y;
	for (var i=0; i < qq; i++)
	{  
		o = this.dataProvider[i];
		x = o[this.horizontalAttribute];
		y = o[this.verticalAttribute];
		if (r[0] == null || x < r[0]) r[0] = x;
		if (r[1] == null || x > r[1]) r[1] = x;

		if (r[2] == null || y < r[2]) r[2] = y;
		if (r[3] == null || y > r[3]) r[3] = y;		
  }
  

  this.dataMinMax = r;
  //console.log("i computed... calling nte",this);
  if (this.minmaxRecomputed) this.minmaxRecomputed(r); // тут кстати возможно изменят dataMinMax
}

BitmapChart.prototype.update = function( dataProvider ) {
  this.dataProvider = dataProvider;
  this.computeMinMax();
  this.reset();
}

BitmapChart.prototype.reset = function( event,resetSel ) {
	
	if (resetSel)
  	  this.selection = [0,1,0,1];

	this.horizontalMin = this.dataMinMax[0];
	this.horizontalMax = this.dataMinMax[1];
	
	this._horizontalMin = this.horizontalMin + (this.horizontalMax-this.horizontalMin)*this.selection[0];
	this._horizontalMax = this.horizontalMin + (this.horizontalMax-this.horizontalMin)*this.selection[1];
			
	this.verticalMin = this.dataMinMax[2];
	this.verticalMax = this.dataMinMax[3];

	this._verticalMin = this.verticalMin + (this.verticalMax-this.verticalMin)*this.selection[2];
	this._verticalMax = this.verticalMin + (this.verticalMax-this.verticalMin)*this.selection[3];

	//console.log("resetted... this._horizontalMin=",this._horizontalMin);
	
	this.resize();
}

BitmapChart.prototype.append = function( data ) {
  this.histogram = false;

  var qq = data.length;
  var r = this.dataMinMax;
  var o;
  var x;
  var y;
	for (var i=0; i < qq; i++)
	{  
		o = data[i];
		x = o[0];
		y = o[1];
		if (r[0] == null || x < r[0]) r[0] = x;
		if (r[1] == null || x > r[1]) r[1] = x;

		if (r[2] == null || y < r[2]) r[2] = y;
		if (r[3] == null || y > r[3]) r[3] = y;		
  }
  
  // http://stackoverflow.com/questions/1374126/how-to-extend-an-existing-javascript-array-with-another-array/17368101#17368101
  var d = this.dataProvider;
  data.forEach(function(v) {d.push(v)}, this);   

  this.dataMinMax = r;

  // if (this.minmaxRecomputed) minmaxRecomputed(r);

  this.reset();
}

BitmapChart.prototype.resize = function( event ) {
	var chart = this;
	chart.invalidateLayout();
}

BitmapChart.prototype.invalidateLayout = function( event ) {
	//log ("invalid");
	var chart = this;
	if ( chart.invalidationTimeout )
		clearTimeout( chart.invalidationTimeout );
	chart.invalidationTimeout = setTimeout( function() { chart.validateLayout(); }, chart.timeout || 1550 );
	
	if (!chart.progress) {
  	chart.progress = jQuery("<progress style='position:absolute; bottom:2px; left:45%; z-index:100;display:none;'></progress>");
  	chart.targetDiv.append( chart.progress );
  }
  if (chart.timeout && chart.timeout > 30)
    chart.progress.show();
  
  /*
	if (chart.canvas) {
  	var ctx = chart.canvas[0].getContext("2d");  
  	ctx.fillText("...",0,0);
  }
  */

}

BitmapChart.prototype.validateLayout = function( event ) {
	//log("valid");
	var chart = this;
	
	if (chart.canvas)
		chart.canvas.remove();
	chart.canvas = $( "<canvas width='" + chart.targetDiv.width() + "' height='" + chart.targetDiv.height() + "' />" );
	chart.targetDiv.append( chart.canvas );
	
	chart.render();
	chart.progress.hide();
}



BitmapChart.prototype.getHorizontalPixelValue = function( input ) {
	
	var relative = (input - this.borderSize)/(this.targetDiv.width()-2*this.borderSize);
	return (relative * (this._horizontalMax - this._horizontalMin)) + this._horizontalMin;
}
			
BitmapChart.prototype.getVerticalPixelValue = function( input ) {
	var relative = 1-((input - this.borderSize)/(this.targetDiv.height()-2*this.borderSize));
	return (relative * (this._verticalMax - this._verticalMin)) + this._verticalMin;
}

BitmapChart.prototype.getHorizontalPixelValueRel = function( relative ) {
	
	return (relative * (this.horizontalMax - this.horizontalMin)) + this.horizontalMin;
}
			
BitmapChart.prototype.getVerticalPixelValueRel = function( relative ) {
	return (relative * (this.verticalMax - this.verticalMin)) + this.verticalMin;
}

BitmapChart.prototype.getHorizontalRelValue = function( input ) {
	
	var relative = (input - this.borderSize)/(this.targetDiv.width()-2*this.borderSize);
	// это по отношению к чему? к текущему окошечку, определяемому this._horizontalMin и this._horizontalMax
	// приведем теперь это к глобальному значению относительно this.horizontalMin и this.horizontalMax
	var absolut = (this._horizontalMin + (this._horizontalMax-this._horizontalMin)*relative);
	var abs_relative = (absolut - this.horizontalMin) / (this.horizontalMax-this.horizontalMin);

	return abs_relative;
}
			
BitmapChart.prototype.getVerticalRelValue = function( input ) {
	var relative = 1-((input - this.borderSize)/(this.targetDiv.height()-2*this.borderSize));

	var absolut = (this._verticalMin + (this._verticalMax-this._verticalMin)*relative);
	var abs_relative = (absolut - this.verticalMin) / (this.verticalMax-this.verticalMin);	

	return abs_relative;
}

BitmapChart.prototype.width = function() {
	return this.targetDiv.width();	
}

BitmapChart.prototype.height = function() {
	return this.targetDiv.height();	
}



BitmapChart.prototype.render = function() {
	this.renderTime = new Date().getTime();
	//log( this );
	console.log( "rendering BitmapChart, dataProvider.length=",this.dataProvider.length, "verticalAttribute=",this.verticalAttribute, 
	                   "sel=",this.selection, "dataMinMax=",this.dataMinMax,"horizontalMin=",this._horizontalMin);
	var i = 0;
	
	var w = this.targetDiv.width();
	var h = this.targetDiv.height();
	var chartW = w - 2*this.borderSize;
	var chartH = h - 2*this.borderSize;
	
	var ctx = this.canvas[0].getContext("2d");  

    ctx.clearRect(0,0,w,h);

    if (this.opaque) 
      ctx.clearRect(0,0,w,h);
    else
    {
		ctx.fillStyle = "rgba(255,255,255,255)";  
		ctx.fillRect (0, 0, w, h);
    }
 
 	
	
	var histoMapX = {};
	var histoMapY = {};
	
	if ( isNaN( this._horizontalMax ) )
	{	
		this._horizontalMin = this.horizontalMin;
		this._horizontalMax = this.horizontalMax;
		this._verticalMin = this.verticalMin;
		this._verticalMax = this.verticalMax;
	}

	var horizontalDiff = this._horizontalMax - this._horizontalMin;
	var verticalDiff = this._verticalMax - this._verticalMin;
	
	var _x;
	var _y;
	var o;

	

	var ll = this.dataProvider.length;

	//////////////////////////////////// lines
	ctx.strokeStyle= "#" + colorToHex( this.color );

	if (this.lineContext && this.lineContext(ctx)) {

  ctx.beginPath();
	for (var i=0; i < ll; i++)
	{  
		o = this.dataProvider[i];
		_x = (o[this.horizontalAttribute] - this._horizontalMin) / horizontalDiff;
		_y = (o[this.verticalAttribute] - this._verticalMin) / verticalDiff;
		
		_x = parseInt( this.borderSize+(_x * chartW) );
		_y = parseInt( this.borderSize+(chartH-(_y * chartH)) );
		
		if (i === 0)
			ctx.moveTo(_x,_y);
		else
		  ctx.lineTo(_x,_y);
	}	

  //ctx.strokeStyle="red";
  //ctx.shadowBlur=20;
  //ctx.shadowColor="black";  
  //ctx.lineWidth=5;
  ctx.stroke();	
  }

	//////////////////////////////////// points

	var imageData = ctx.getImageData(0, 0, w, h);
	
	//render each data point 
    
	for (var i=0; i < ll; i++)
	{  
		o = this.dataProvider[i];
		_x = (o[this.horizontalAttribute] - this._horizontalMin) / horizontalDiff;
		_y = (o[this.verticalAttribute] - this._verticalMin) / verticalDiff;
		// console.log(o[this.verticalAttribute]);
		
		_x = parseInt( this.borderSize+(_x * chartW) );
		_y = parseInt( this.borderSize+(chartH-(_y * chartH)) );
		
		if ( _x > this.borderSize && _x < w - this.borderSize &&
			_y >= this.borderSize && _y <= h - this.borderSize)
		{
			if ( this.histogram )
			{
				if ( histoMapX [ _x.toString() ] == null )
					histoMapX [ _x.toString() ] = 1;
				else
					histoMapX [ _x.toString() ] ++;
				
				if ( histoMapY [ _y.toString() ] == null )
					histoMapY [ _y.toString() ] = 1;
				else
					histoMapY [ _y.toString() ] ++;
			}
			
			this.pixelRenderFunction( _x, _y, o, imageData );
		}
	}
	
	if ( this.histogram )
	{
		var maxX = 0;
		var maxY = 0;
		var relative = 0;
		
		
		for ( var key in histoMapX ) 
		{
			maxX = Math.max( maxX, histoMapX[key] );
		}
		
		for ( key in histoMapY ) 
		{
			maxY = Math.max( maxY, histoMapY[key]);
		}
		
		
		for ( key in histoMapX ) 
		{
			_x = parseFloat( key );
			relative = (histoMapX[key]/maxX) * (this.borderSize-1);
			
			for ( var z = this.borderSize-1; z > (this.borderSize-relative); z -- )
			{
				this.setPixel( imageData, _x, z, this.color[0],this.color[1],this.color[2],this.color[3] );
			}
		}
		
		for ( key in histoMapY ) 
		{
			_y = parseFloat( key );
			relative = (histoMapY[key]/maxY) * (this.borderSize-1);
			
			for ( z = 0; z < relative; z ++ )
			{
				this.setPixel( imageData, w-(this.borderSize-1) + z, _y, this.color[0],this.color[1],this.color[2],this.color[3] );
			}
		}
	}
	
	var interval = chartW/this.segments;
	//render verical line overlays
	for ( i = this.borderSize; i<=w-(this.borderSize-2); i += interval )
	{
		for ( var j = this.borderSize; j < h-this.borderSize; j ++ )
		{
			this.setPixel( imageData, Math.round(i), j, 0,0,0,0xFF );
		}
	}
	
	//render horizontal line overlays
	interval = chartH/this.segments;
	for ( var i = this.borderSize; i<=h-(this.borderSize-2); i += interval )
	{
		for ( var j = this.borderSize; j < w-this.borderSize; j ++ )
		{
			this.setPixel( imageData, j, Math.round(i), 0,0,0,0xFF );
		}
	} 
	
	ctx.putImageData(imageData, 0, 0); 
	
	var label;
	ctx.fillStyle = "black";
	
	
	interval = chartW/this.segments;
    //pv
    //var sg = 2;
    //interval = chartW/sg;
	var labelCount = 0;
	var labelIncrement = horizontalDiff/this.segments;
  //  var labelIncrement = horizontalDiff/sg;

    if (this.shift == 0) {
	
	for ( i = this.borderSize; i<=w-(this.borderSize-2); i += interval )
	{
		label=(this._horizontalMin + (labelCount * labelIncrement )).toFixed(2);
		_x = i - 20;
		_y = h-this.borderSize/2;
		
		ctx.fillText( label, _x, _y );
		labelCount++;
	}
	
	interval = chartH/this.segments;
	labelIncrement = verticalDiff/this.segments;
	labelCount = 0;
	
	// vertical label (left) (for y) 
	for ( i = this.borderSize; i<=h-(this.borderSize-2); i += interval )
	{
		label=(this._verticalMin + (labelCount * labelIncrement )).toFixed(2);
		_x = 0;
		_y = h-i;
		
		ctx.fillText( label, _x, _y );
		labelCount++;
	}

	} // if shift
	
	
	this.renderTime = new Date().getTime() - this.renderTime;
	console.log("renderTime=",this.renderTime);
}


BitmapChart.prototype.setPixel = function(imageData, x, y, r, g, b, a) {
	//log( x + "," + y );
    index = (x + y * imageData.width) * 4;
    imageData.data[index+0] = r;
    imageData.data[index+1] = g;
    imageData.data[index+2] = b;
    imageData.data[index+3] = a;
}




function drawSinglePixel( x, y, data, imageData )
{
	BitmapChart.prototype.setPixel(imageData, x, y, 0, 0, 0xFF, 0xFF) 
}

function drawCross( x, y, data, imageData )
{
	BitmapChart.prototype.setPixel(imageData, x, y, 0, 0, 0xFF, 0xFF);
	BitmapChart.prototype.setPixel(imageData, x-1, y, 0, 0, 0xFF, 0xFF);
	BitmapChart.prototype.setPixel(imageData, x+1, y, 0, 0, 0xFF, 0xFF);
	BitmapChart.prototype.setPixel(imageData, x, y-1, 0, 0, 0xFF, 0xFF);
	BitmapChart.prototype.setPixel(imageData, x, y+1, 0, 0, 0xFF, 0xFF);
}

function makeDrawCross (r,g,b,a) {
  
  return function( x, y, data, imageData )
  {
	BitmapChart.prototype.setPixel(imageData, x, y, r,g,b,a);
	BitmapChart.prototype.setPixel(imageData, x-1, y, r,g,b,a);
	BitmapChart.prototype.setPixel(imageData, x+1, y, r,g,b,a);
	BitmapChart.prototype.setPixel(imageData, x, y-1, r,g,b,a);
	BitmapChart.prototype.setPixel(imageData, x, y+1, r,g,b,a);
  }
}

BitmapChart.prototype.mouseMoveHandler = function(event) {
  //console.log("mouse move handl",this.verticalAttribute);
	//var chart = chartMap[ this.id ]; 
	var chart = this;

	if (this.shift > 0) {
	}
	else
	{
	
	var mouseLabel = $('#mouseLabel'+this.targetDivId);
	//log( mouseLabel );
	if ( mouseLabel.parent() != null )
		$("body").append( mouseLabel );

	mouseLabel.css( "left", event.pageX+20 );
	mouseLabel.css( "top", event.pageY+20 );
	
	if ( this.verticalAttribute >= 0 && event.offsetX > chart.borderSize && event.offsetX < chart.targetDiv.width() - chart.borderSize &&
		event.offsetY > chart.borderSize && event.offsetY < chart.targetDiv.height() - chart.borderSize)
	{
		mouseLabel.fadeIn();
		mouseLabel.text( chart.getHorizontalPixelValue( event.offsetX ).toFixed(2) + ", " + chart.getVerticalPixelValue( event.offsetY ).toFixed(4) );
	}
	else {
		mouseLabel.stop(true, true).fadeOut();
	}
	} 

	if (this.nextMouseMoveHandler) this.nextMouseMoveHandler(event);
	if (this.nextMouseChart) this.nextMouseChart.mouseMoveHandler(event);
	//if (this.nextMouseChart) this.nextMouseChart.mouseMoveHandler(event);
}


BitmapChart.prototype.bodyMouseMoveHandler = function(event) {

	var chart = this;
	if (chart) 	
		chart.updateSelection(event);
		
	
	if( !(document.ontouchmove === undefined))
		event.preventDefault();
}

BitmapChart.prototype.updateSelection = function(event) {

	if ( this.isSelecting )
	{	
		var evtTarget;
		
		if(document.ontouchmove === undefined)
			evtTarget = event;
		else
			evtTarget = event.touches[0];
			
		var _x = Math.min( this.mouseDownX, evtTarget.pageX - this.targetDiv.offset().left );
		var w = Math.max( this.mouseDownX, evtTarget.pageX - this.targetDiv.offset().left )-_x;
		
		//pv
		var _y = Math.min( this.mouseDownY, evtTarget.pageY - this.targetDiv.offset().top );
//		var __y = Math.min( this.mouseDownY, evtTarget.pageY );
		var h = Math.max( this.mouseDownY, evtTarget.pageY - this.targetDiv.offset().top ) - _y;
		//console.log( "evtTarget.pageY=",evtTarget.pageY, " this.targetDiv.offset().top=",this.targetDiv.offset().top);
		
		this.selectionDiv.offset({left:_x +this.targetDiv.offset().left, top:_y +this.targetDiv.offset().top});
		this.selectionDiv.width( w );
		this.selectionDiv.height( h );
	} 
}

BitmapChart.prototype.mouseOverHandler = function(event) {

	$('#mouseLabel').stop(true, true).fadeIn();
}

BitmapChart.prototype.mouseOutHandler = function(event) {

	$('#mouseLabel').stop(true, true).fadeOut();
}

BitmapChart.prototype.mouseDownHandler = function(event) {
	var evtTarget;
	
	if(document.ontouchmove === undefined)
		evtTarget = event;
	else
		evtTarget = event.touches[0];
		
	var chart = this;
	chart.isSelecting = true;
	chart.mouseDownX = evtTarget.pageX - $(this.targetDiv).offset().left;
	chart.mouseDownY = evtTarget.pageY - $(this.targetDiv).offset().top;
	chart.updateSelection(event);
	chart.selectionDiv.stop(true, true).fadeIn();
}

BitmapChart.prototype.mouseUpHandler = function(event) {
try{
	var chart = this;
	if ( chart && chart.isSelecting )
	{
		var evtTarget;
		
	if(document.ontouchmove === undefined)
			evtTarget = event;
		else
			evtTarget = event.changedTouches[0];
		
		chart.isSelecting = false;
		chart.selectionDiv.stop(true, true).fadeOut();
		chart.selectionDiv.offset({left:0,top:0});
		chart.selectionDiv.width( 0 );
		chart.selectionDiv.height( 0 );
		
		var h1 = Math.min( chart.mouseDownX, evtTarget.pageX-chart.targetDiv.offset().left );
		var h2 = Math.max( chart.mouseDownX, evtTarget.pageX-chart.targetDiv.offset().left );
		
		var v1 = Math.max( chart.mouseDownY, evtTarget.pageY-chart.targetDiv.offset().top );
		var v2 = Math.min( chart.mouseDownY, evtTarget.pageY-chart.targetDiv.offset().top );
		
        var relarr = [chart.getHorizontalRelValue( h1 ), chart.getHorizontalRelValue( h2 ),
					  chart.getVerticalRelValue( v1 ),chart.getVerticalRelValue( v2 ) ]

		
 
		//console.log("mousa apaa",relarr);
    if (Math.abs(relarr[1]-relarr[0]) < 0.00001 || Math.abs(relarr[3]-relarr[2]) < 0.00001 ) {
      relarr = [0,1,0,1];
      /*
    
		  // this is not selection. this is double click! ;-)
		  if (this.relarrStack && this.relarrStack.length > 0) {
		    relarr = this.relarrStack.pop();
		    console.log("popped");
		  }
		  else {
		    console.log("Resetted");
		    relarr = [0,1,0,1];
		  }
		  */
	  }
	  else
	  {
	    //if (!this.relarrStack) this.relarrStack = [];
	    //this.relarrStack.push( relarr );
	    //console.log("pushed");
	  }
		

		if (this.selectionChangedHandler) 
		  this.selectionChangedHandler( relarr );
		else
		  this.setSelection( relarr );

	}
}catch(e){
  console.log( e );
  alert("BitmapChart.prototype.mouseUpHandler:" + e)
  
}
}

BitmapChart.prototype.isSelectionDifferent = function (relativeArr) {
   if (!this.selection) return true;

        for (var i=0; i<4; i++)
          if (this.selection[i] != relativeArr[i])
            return true;

  return false;
}              

BitmapChart.prototype.undoSelection = function() {
  this.setSelection( [1,1,1,1] ); // double-click case will be triggered and we will have pop action!;-)
}
            
BitmapChart.prototype.setSelection = function( relativeArr ) {
        /* hren kakayato */
        if (!this.isSelectionDifferent(relativeArr)) {
          console.log("same: not setting  selection ",relativeArr,"to ",this.selection,this);
          return;
        }
 
        var chart = this;
//        console.log("set selection ",relativeArr,"to ",chart);
//        debugger;
        
        
		var newHMin = chart.getHorizontalPixelValueRel( relativeArr[0] );
		var newHMax = chart.getHorizontalPixelValueRel( relativeArr[1] );
		
		var newVMin = chart.getVerticalPixelValueRel( relativeArr[2] );
		var newVMax = chart.getVerticalPixelValueRel( relativeArr[3] );

		/*
		if (Math.abs(newHMin-newHMax) < 0.00001 || Math.abs(newVMin-newVMax) < 0.00001 ) {
		  // this is not selection. this is double click! ;-)
		  console.log("BitmapChart: this is double click");
		  if (this.doubleClicked)
  		  this.doubleClicked();
		  return;
		}*/

		chart.selection = relativeArr;
		
		console.log("old chart._horizontalMin=",chart._horizontalMin);
		chart._horizontalMin = newHMin;
		console.log("new! chart._horizontalMin=",chart._horizontalMin);
		chart._horizontalMax = newHMax;
			
		chart._verticalMin = newVMin;
		chart._verticalMax = newVMax;
		

		chart.render();
}



function log( target ) {

	try {
		console.log( target )
	}
	catch ( e )
	{
		//do nothing for now	
	}
	
}
