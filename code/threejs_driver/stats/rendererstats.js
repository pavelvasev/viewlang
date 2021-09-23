/** cloned from https://github.com/jeromeetienne/threex.rendererstats
 * provide info on THREE.WebGLRenderer
 */
RendererStats = function () {
	var msMin = 100;
	var msMax = 0;

	var container = document.createElement( 'div' );
	container.style.cssText = 'width:160px;opacity:0.9;cursor:pointer';

	var msDiv = document.createElement( 'div' );
	msDiv.style.cssText = 'padding:0 0 3px 3px;text-align:left;background-color:#200;';
	container.appendChild(msDiv);

	var msText = document.createElement( 'div' );
	msText.style.cssText = 'color:#f00;font-family:Helvetica,Arial,sans-serif;font-size:15px;font-weight:bold;line-height:15px';
	msText.innerHTML = 'WebGLRenderer';
	msDiv.appendChild(msText);
	
	var msTexts	= [];
	var nLines = 9+2;
	for(var i = 0; i < nLines; i++)
	{
		msTexts[i] = document.createElement( 'div' );
		msTexts[i].style.cssText = 'color:#f00;background-color:#311;font-family:Helvetica,Arial,sans-serif;font-size:18px;font-weight:bold;line-height:15px';
		msDiv.appendChild(msTexts[i]);		
		msTexts[i].innerHTML = '-';
	}

	var lastTime = Date.now();

	return {
		domElement : container,

		update : function(webGLRenderer) {
			// refresh only 30time per second
      // console.log(webGLRenderer);
			if(Date.now() - lastTime < 1000/30)	return;
			lastTime = Date.now()

			var i = 0;
			msTexts[i++].textContent = "== Memory =====";
			msTexts[i++].textContent = "Programs: "	+ webGLRenderer.info.programs.length;
			msTexts[i++].textContent = "Geometries: "+webGLRenderer.info.memory.geometries;
			msTexts[i++].textContent = "Textures: "	+ webGLRenderer.info.memory.textures;

			msTexts[i++].textContent = "== Render ===== ";
			msTexts[i++].textContent = "Calls: "	+ webGLRenderer.info.render.calls;
			msTexts[i++].textContent = "Lines: "	+ webGLRenderer.info.render.lines;
			//msTexts[i++].textContent = "Triangles: "	+ webGLRenderer.info.render.triangles.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ' ');
			msTexts[i++].innerHTML= "Triangles: "	+ webGLRenderer.info.render.triangles.toString().replace(/\B(?=(\d{3})+(?!\d))/g, '&nbsp;');
			// thanks https://www.codegrepper.com/code-examples/javascript/javascript+format+numbers+thousands+space+seperator
			msTexts[i++].textContent = "Points: "	+ webGLRenderer.info.render.points;

			msTexts[i++].textContent = "== Tasks ===== ";
			msTexts[i++].textContent = `Active: ${qmlEngine?.rootObject?.propertyComputationPending}`;
		}
	}	
};