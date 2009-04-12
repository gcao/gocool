

(function(){if(window.jQuery)var _jQuery=window.jQuery;var jQuery=window.jQuery=function(selector,context){return new jQuery.prototype.init(selector,context);};if(window.$)var _$=window.$;window.$=jQuery;var quickExpr=/^[^<]*(<(.|\s)+>)[^>]*$|^#(\w+)$/;var isSimple=/^.[^:#\[\.]*$/;jQuery.fn=jQuery.prototype={init:function(selector,context){selector=selector||document;if(selector.nodeType){this[0]=selector;this.length=1;return this;}else if(typeof selector=="string"){var match=quickExpr.exec(selector);if(match&&(match[1]||!context)){if(match[1])selector=jQuery.clean([match[1]],context);else{var elem=document.getElementById(match[3]);if(elem)if(elem.id!=match[3])return jQuery().find(selector);else{this[0]=elem;this.length=1;return this;}else
selector=[];}}else
return new jQuery(context).find(selector);}else if(jQuery.isFunction(selector))return new jQuery(document)[jQuery.fn.ready?"ready":"load"](selector);return this.setArray(selector.constructor==Array&&selector||(selector.jquery||selector.length&&selector!=window&&!selector.nodeType&&selector[0]!=undefined&&selector[0].nodeType)&&jQuery.makeArray(selector)||[selector]);},jquery:"1.2.3",size:function(){return this.length;},length:0,get:function(num){return num==undefined?jQuery.makeArray(this):this[num];},pushStack:function(elems){var ret=jQuery(elems);ret.prevObject=this;return ret;},setArray:function(elems){this.length=0;Array.prototype.push.apply(this,elems);return this;},each:function(callback,args){return jQuery.each(this,callback,args);},index:function(elem){var ret=-1;this.each(function(i){if(this==elem)ret=i;});return ret;},attr:function(name,value,type){var options=name;if(name.constructor==String)if(value==undefined)return this.length&&jQuery[type||"attr"](this[0],name)||undefined;else{options={};options[name]=value;}return this.each(function(i){for(name in options)jQuery.attr(type?this.style:this,name,jQuery.prop(this,options[name],type,i,name));});},css:function(key,value){if((key=='width'||key=='height')&&parseFloat(value)<0)value=undefined;return this.attr(key,value,"curCSS");},text:function(text){if(typeof text!="object"&&text!=null)return this.empty().append((this[0]&&this[0].ownerDocument||document).createTextNode(text));var ret="";jQuery.each(text||this,function(){jQuery.each(this.childNodes,function(){if(this.nodeType!=8)ret+=this.nodeType!=1?this.nodeValue:jQuery.fn.text([this]);});});return ret;},wrapAll:function(html){if(this[0])jQuery(html,this[0].ownerDocument).clone().insertBefore(this[0]).map(function(){var elem=this;while(elem.firstChild)elem=elem.firstChild;return elem;}).append(this);return this;},wrapInner:function(html){return this.each(function(){jQuery(this).contents().wrapAll(html);});},wrap:function(html){return this.each(function(){jQuery(this).wrapAll(html);});},append:function(){return this.domManip(arguments,true,false,function(elem){if(this.nodeType==1)this.appendChild(elem);});},prepend:function(){return this.domManip(arguments,true,true,function(elem){if(this.nodeType==1)this.insertBefore(elem,this.firstChild);});},before:function(){return this.domManip(arguments,false,false,function(elem){this.parentNode.insertBefore(elem,this);});},after:function(){return this.domManip(arguments,false,true,function(elem){this.parentNode.insertBefore(elem,this.nextSibling);});},end:function(){return this.prevObject||jQuery([]);},find:function(selector){var elems=jQuery.map(this,function(elem){return jQuery.find(selector,elem);});return this.pushStack(/[^+>] [^+>]/.test(selector)||selector.indexOf("..")>-1?jQuery.unique(elems):elems);},clone:function(events){var ret=this.map(function(){if(jQuery.browser.msie&&!jQuery.isXMLDoc(this)){var clone=this.cloneNode(true),container=document.createElement("div");container.appendChild(clone);return jQuery.clean([container.innerHTML])[0];}else
return this.cloneNode(true);});var clone=ret.find("*").andSelf().each(function(){if(this[expando]!=undefined)this[expando]=null;});if(events===true)this.find("*").andSelf().each(function(i){if(this.nodeType==3)return;var events=jQuery.data(this,"events");for(var type in events)for(var handler in events[type])jQuery.event.add(clone[i],type,events[type][handler],events[type][handler].data);});return ret;},filter:function(selector){return this.pushStack(jQuery.isFunction(selector)&&jQuery.grep(this,function(elem,i){return selector.call(elem,i);})||jQuery.multiFilter(selector,this));},not:function(selector){if(selector.constructor==String)if(isSimple.test(selector))return this.pushStack(jQuery.multiFilter(selector,this,true));else
selector=jQuery.multiFilter(selector,this);var isArrayLike=selector.length&&selector[selector.length-1]!==undefined&&!selector.nodeType;return this.filter(function(){return isArrayLike?jQuery.inArray(this,selector)<0:this!=selector;});},add:function(selector){return!selector?this:this.pushStack(jQuery.merge(this.get(),selector.constructor==String?jQuery(selector).get():selector.length!=undefined&&(!selector.nodeName||jQuery.nodeName(selector,"form"))?selector:[selector]));},is:function(selector){return selector?jQuery.multiFilter(selector,this).length>0:false;},hasClass:function(selector){return this.is("."+selector);},val:function(value){if(value==undefined){if(this.length){var elem=this[0];if(jQuery.nodeName(elem,"select")){var index=elem.selectedIndex,values=[],options=elem.options,one=elem.type=="select-one";if(index<0)return null;for(var i=one?index:0,max=one?index+1:options.length;i<max;i++){var option=options[i];if(option.selected){value=jQuery.browser.msie&&!option.attributes.value.specified?option.text:option.value;if(one)return value;values.push(value);}}return values;}else
return(this[0].value||"").replace(/\r/g,"");}return undefined;}return this.each(function(){if(this.nodeType!=1)return;if(value.constructor==Array&&/radio|checkbox/.test(this.type))this.checked=(jQuery.inArray(this.value,value)>=0||jQuery.inArray(this.name,value)>=0);else if(jQuery.nodeName(this,"select")){var values=value.constructor==Array?value:[value];jQuery("option",this).each(function(){this.selected=(jQuery.inArray(this.value,values)>=0||jQuery.inArray(this.text,values)>=0);});if(!values.length)this.selectedIndex=-1;}else
this.value=value;});},html:function(value){return value==undefined?(this.length?this[0].innerHTML:null):this.empty().append(value);},replaceWith:function(value){return this.after(value).remove();},eq:function(i){return this.slice(i,i+1);},slice:function(){return this.pushStack(Array.prototype.slice.apply(this,arguments));},map:function(callback){return this.pushStack(jQuery.map(this,function(elem,i){return callback.call(elem,i,elem);}));},andSelf:function(){return this.add(this.prevObject);},data:function(key,value){var parts=key.split(".");parts[1]=parts[1]?"."+parts[1]:"";if(value==null){var data=this.triggerHandler("getData"+parts[1]+"!",[parts[0]]);if(data==undefined&&this.length)data=jQuery.data(this[0],key);return data==null&&parts[1]?this.data(parts[0]):data;}else
return this.trigger("setData"+parts[1]+"!",[parts[0],value]).each(function(){jQuery.data(this,key,value);});},removeData:function(key){return this.each(function(){jQuery.removeData(this,key);});},domManip:function(args,table,reverse,callback){var clone=this.length>1,elems;return this.each(function(){if(!elems){elems=jQuery.clean(args,this.ownerDocument);if(reverse)elems.reverse();}var obj=this;if(table&&jQuery.nodeName(this,"table")&&jQuery.nodeName(elems[0],"tr"))obj=this.getElementsByTagName("tbody")[0]||this.appendChild(this.ownerDocument.createElement("tbody"));var scripts=jQuery([]);jQuery.each(elems,function(){var elem=clone?jQuery(this).clone(true)[0]:this;if(jQuery.nodeName(elem,"script")){scripts=scripts.add(elem);}else{if(elem.nodeType==1)scripts=scripts.add(jQuery("script",elem).remove());callback.call(obj,elem);}});scripts.each(evalScript);});}};jQuery.prototype.init.prototype=jQuery.prototype;function evalScript(i,elem){if(elem.src)jQuery.ajax({url:elem.src,async:false,dataType:"script"});else
jQuery.globalEval(elem.text||elem.textContent||elem.innerHTML||"");if(elem.parentNode)elem.parentNode.removeChild(elem);}jQuery.extend=jQuery.fn.extend=function(){var target=arguments[0]||{},i=1,length=arguments.length,deep=false,options;if(target.constructor==Boolean){deep=target;target=arguments[1]||{};i=2;}if(typeof target!="object"&&typeof target!="function")target={};if(length==1){target=this;i=0;}for(;i<length;i++)if((options=arguments[i])!=null)for(var name in options){if(target===options[name])continue;if(deep&&options[name]&&typeof options[name]=="object"&&target[name]&&!options[name].nodeType)target[name]=jQuery.extend(target[name],options[name]);else if(options[name]!=undefined)target[name]=options[name];}return target;};var expando="jQuery"+(new Date()).getTime(),uuid=0,windowData={};var exclude=/z-?index|font-?weight|opacity|zoom|line-?height/i;jQuery.extend({noConflict:function(deep){window.$=_$;if(deep)window.jQuery=_jQuery;return jQuery;},isFunction:function(fn){return!!fn&&typeof fn!="string"&&!fn.nodeName&&fn.constructor!=Array&&/function/i.test(fn+"");},isXMLDoc:function(elem){return elem.documentElement&&!elem.body||elem.tagName&&elem.ownerDocument&&!elem.ownerDocument.body;},globalEval:function(data){data=jQuery.trim(data);if(data){var head=document.getElementsByTagName("head")[0]||document.documentElement,script=document.createElement("script");script.type="text/javascript";if(jQuery.browser.msie)script.text=data;else
script.appendChild(document.createTextNode(data));head.appendChild(script);head.removeChild(script);}},nodeName:function(elem,name){return elem.nodeName&&elem.nodeName.toUpperCase()==name.toUpperCase();},cache:{},data:function(elem,name,data){elem=elem==window?windowData:elem;var id=elem[expando];if(!id)id=elem[expando]=++uuid;if(name&&!jQuery.cache[id])jQuery.cache[id]={};if(data!=undefined)jQuery.cache[id][name]=data;return name?jQuery.cache[id][name]:id;},removeData:function(elem,name){elem=elem==window?windowData:elem;var id=elem[expando];if(name){if(jQuery.cache[id]){delete jQuery.cache[id][name];name="";for(name in jQuery.cache[id])break;if(!name)jQuery.removeData(elem);}}else{try{delete elem[expando];}catch(e){if(elem.removeAttribute)elem.removeAttribute(expando);}delete jQuery.cache[id];}},each:function(object,callback,args){if(args){if(object.length==undefined){for(var name in object)if(callback.apply(object[name],args)===false)break;}else
for(var i=0,length=object.length;i<length;i++)if(callback.apply(object[i],args)===false)break;}else{if(object.length==undefined){for(var name in object)if(callback.call(object[name],name,object[name])===false)break;}else
for(var i=0,length=object.length,value=object[0];i<length&&callback.call(value,i,value)!==false;value=object[++i]){}}return object;},prop:function(elem,value,type,i,name){if(jQuery.isFunction(value))value=value.call(elem,i);return value&&value.constructor==Number&&type=="curCSS"&&!exclude.test(name)?value+"px":value;},className:{add:function(elem,classNames){jQuery.each((classNames||"").split(/\s+/),function(i,className){if(elem.nodeType==1&&!jQuery.className.has(elem.className,className))elem.className+=(elem.className?" ":"")+className;});},remove:function(elem,classNames){if(elem.nodeType==1)elem.className=classNames!=undefined?jQuery.grep(elem.className.split(/\s+/),function(className){return!jQuery.className.has(classNames,className);}).join(" "):"";},has:function(elem,className){return jQuery.inArray(className,(elem.className||elem).toString().split(/\s+/))>-1;}},swap:function(elem,options,callback){var old={};for(var name in options){old[name]=elem.style[name];elem.style[name]=options[name];}callback.call(elem);for(var name in options)elem.style[name]=old[name];},css:function(elem,name,force){if(name=="width"||name=="height"){var val,props={position:"absolute",visibility:"hidden",display:"block"},which=name=="width"?["Left","Right"]:["Top","Bottom"];function getWH(){val=name=="width"?elem.offsetWidth:elem.offsetHeight;var padding=0,border=0;jQuery.each(which,function(){padding+=parseFloat(jQuery.curCSS(elem,"padding"+this,true))||0;border+=parseFloat(jQuery.curCSS(elem,"border"+this+"Width",true))||0;});val-=Math.round(padding+border);}if(jQuery(elem).is(":visible"))getWH();else
jQuery.swap(elem,props,getWH);return Math.max(0,val);}return jQuery.curCSS(elem,name,force);},curCSS:function(elem,name,force){var ret;function color(elem){if(!jQuery.browser.safari)return false;var ret=document.defaultView.getComputedStyle(elem,null);return!ret||ret.getPropertyValue("color")=="";}if(name=="opacity"&&jQuery.browser.msie){ret=jQuery.attr(elem.style,"opacity");return ret==""?"1":ret;}if(jQuery.browser.opera&&name=="display"){var save=elem.style.outline;elem.style.outline="0 solid black";elem.style.outline=save;}if(name.match(/float/i))name=styleFloat;if(!force&&elem.style&&elem.style[name])ret=elem.style[name];else if(document.defaultView&&document.defaultView.getComputedStyle){if(name.match(/float/i))name="float";name=name.replace(/([A-Z])/g,"-$1").toLowerCase();var getComputedStyle=document.defaultView.getComputedStyle(elem,null);if(getComputedStyle&&!color(elem))ret=getComputedStyle.getPropertyValue(name);else{var swap=[],stack=[];for(var a=elem;a&&color(a);a=a.parentNode)stack.unshift(a);for(var i=0;i<stack.length;i++)if(color(stack[i])){swap[i]=stack[i].style.display;stack[i].style.display="block";}ret=name=="display"&&swap[stack.length-1]!=null?"none":(getComputedStyle&&getComputedStyle.getPropertyValue(name))||"";for(var i=0;i<swap.length;i++)if(swap[i]!=null)stack[i].style.display=swap[i];}if(name=="opacity"&&ret=="")ret="1";}else if(elem.currentStyle){var camelCase=name.replace(/\-(\w)/g,function(all,letter){return letter.toUpperCase();});ret=elem.currentStyle[name]||elem.currentStyle[camelCase];if(!/^\d+(px)?$/i.test(ret)&&/^\d/.test(ret)){var style=elem.style.left,runtimeStyle=elem.runtimeStyle.left;elem.runtimeStyle.left=elem.currentStyle.left;elem.style.left=ret||0;ret=elem.style.pixelLeft+"px";elem.style.left=style;elem.runtimeStyle.left=runtimeStyle;}}return ret;},clean:function(elems,context){var ret=[];context=context||document;if(typeof context.createElement=='undefined')context=context.ownerDocument||context[0]&&context[0].ownerDocument||document;jQuery.each(elems,function(i,elem){if(!elem)return;if(elem.constructor==Number)elem=elem.toString();if(typeof elem=="string"){elem=elem.replace(/(<(\w+)[^>]*?)\/>/g,function(all,front,tag){return tag.match(/^(abbr|br|col|img|input|link|meta|param|hr|area|embed)$/i)?all:front+"></"+tag+">";});var tags=jQuery.trim(elem).toLowerCase(),div=context.createElement("div");var wrap=!tags.indexOf("<opt")&&[1,"<select multiple='multiple'>","</select>"]||!tags.indexOf("<leg")&&[1,"<fieldset>","</fieldset>"]||tags.match(/^<(thead|tbody|tfoot|colg|cap)/)&&[1,"<table>","</table>"]||!tags.indexOf("<tr")&&[2,"<table><tbody>","</tbody></table>"]||(!tags.indexOf("<td")||!tags.indexOf("<th"))&&[3,"<table><tbody><tr>","</tr></tbody></table>"]||!tags.indexOf("<col")&&[2,"<table><tbody></tbody><colgroup>","</colgroup></table>"]||jQuery.browser.msie&&[1,"div<div>","</div>"]||[0,"",""];div.innerHTML=wrap[1]+elem+wrap[2];while(wrap[0]--)div=div.lastChild;if(jQuery.browser.msie){var tbody=!tags.indexOf("<table")&&tags.indexOf("<tbody")<0?div.firstChild&&div.firstChild.childNodes:wrap[1]=="<table>"&&tags.indexOf("<tbody")<0?div.childNodes:[];for(var j=tbody.length-1;j>=0;--j)if(jQuery.nodeName(tbody[j],"tbody")&&!tbody[j].childNodes.length)tbody[j].parentNode.removeChild(tbody[j]);if(/^\s/.test(elem))div.insertBefore(context.createTextNode(elem.match(/^\s*/)[0]),div.firstChild);}elem=jQuery.makeArray(div.childNodes);}if(elem.length===0&&(!jQuery.nodeName(elem,"form")&&!jQuery.nodeName(elem,"select")))return;if(elem[0]==undefined||jQuery.nodeName(elem,"form")||elem.options)ret.push(elem);else
ret=jQuery.merge(ret,elem);});return ret;},attr:function(elem,name,value){if(!elem||elem.nodeType==3||elem.nodeType==8)return undefined;var fix=jQuery.isXMLDoc(elem)?{}:jQuery.props;if(name=="selected"&&jQuery.browser.safari)elem.parentNode.selectedIndex;if(fix[name]){if(value!=undefined)elem[fix[name]]=value;return elem[fix[name]];}else if(jQuery.browser.msie&&name=="style")return jQuery.attr(elem.style,"cssText",value);else if(value==undefined&&jQuery.browser.msie&&jQuery.nodeName(elem,"form")&&(name=="action"||name=="method"))return elem.getAttributeNode(name).nodeValue;else if(elem.tagName){if(value!=undefined){if(name=="type"&&jQuery.nodeName(elem,"input")&&elem.parentNode)throw"type property can't be changed";elem.setAttribute(name,""+value);}if(jQuery.browser.msie&&/href|src/.test(name)&&!jQuery.isXMLDoc(elem))return elem.getAttribute(name,2);return elem.getAttribute(name);}else{if(name=="opacity"&&jQuery.browser.msie){if(value!=undefined){elem.zoom=1;elem.filter=(elem.filter||"").replace(/alpha\([^)]*\)/,"")+(parseFloat(value).toString()=="NaN"?"":"alpha(opacity="+value*100+")");}return elem.filter&&elem.filter.indexOf("opacity=")>=0?(parseFloat(elem.filter.match(/opacity=([^)]*)/)[1])/100).toString():"";}name=name.replace(/-([a-z])/ig,function(all,letter){return letter.toUpperCase();});if(value!=undefined)elem[name]=value;return elem[name];}},trim:function(text){return(text||"").replace(/^\s+|\s+$/g,"");},makeArray:function(array){var ret=[];if(typeof array!="array")for(var i=0,length=array.length;i<length;i++)ret.push(array[i]);else
ret=array.slice(0);return ret;},inArray:function(elem,array){for(var i=0,length=array.length;i<length;i++)if(array[i]==elem)return i;return-1;},merge:function(first,second){if(jQuery.browser.msie){for(var i=0;second[i];i++)if(second[i].nodeType!=8)first.push(second[i]);}else
for(var i=0;second[i];i++)first.push(second[i]);return first;},unique:function(array){var ret=[],done={};try{for(var i=0,length=array.length;i<length;i++){var id=jQuery.data(array[i]);if(!done[id]){done[id]=true;ret.push(array[i]);}}}catch(e){ret=array;}return ret;},grep:function(elems,callback,inv){var ret=[];for(var i=0,length=elems.length;i<length;i++)if(!inv&&callback(elems[i],i)||inv&&!callback(elems[i],i))ret.push(elems[i]);return ret;},map:function(elems,callback){var ret=[];for(var i=0,length=elems.length;i<length;i++){var value=callback(elems[i],i);if(value!==null&&value!=undefined){if(value.constructor!=Array)value=[value];ret=ret.concat(value);}}return ret;}});var userAgent=navigator.userAgent.toLowerCase();jQuery.browser={version:(userAgent.match(/.+(?:rv|it|ra|ie)[\/: ]([\d.]+)/)||[])[1],safari:/webkit/.test(userAgent),opera:/opera/.test(userAgent),msie:/msie/.test(userAgent)&&!/opera/.test(userAgent),mozilla:/mozilla/.test(userAgent)&&!/(compatible|webkit)/.test(userAgent)};var styleFloat=jQuery.browser.msie?"styleFloat":"cssFloat";jQuery.extend({boxModel:!jQuery.browser.msie||document.compatMode=="CSS1Compat",props:{"for":"htmlFor","class":"className","float":styleFloat,cssFloat:styleFloat,styleFloat:styleFloat,innerHTML:"innerHTML",className:"className",value:"value",disabled:"disabled",checked:"checked",readonly:"readOnly",selected:"selected",maxlength:"maxLength",selectedIndex:"selectedIndex",defaultValue:"defaultValue",tagName:"tagName",nodeName:"nodeName"}});jQuery.each({parent:function(elem){return elem.parentNode;},parents:function(elem){return jQuery.dir(elem,"parentNode");},next:function(elem){return jQuery.nth(elem,2,"nextSibling");},prev:function(elem){return jQuery.nth(elem,2,"previousSibling");},nextAll:function(elem){return jQuery.dir(elem,"nextSibling");},prevAll:function(elem){return jQuery.dir(elem,"previousSibling");},siblings:function(elem){return jQuery.sibling(elem.parentNode.firstChild,elem);},children:function(elem){return jQuery.sibling(elem.firstChild);},contents:function(elem){return jQuery.nodeName(elem,"iframe")?elem.contentDocument||elem.contentWindow.document:jQuery.makeArray(elem.childNodes);}},function(name,fn){jQuery.fn[name]=function(selector){var ret=jQuery.map(this,fn);if(selector&&typeof selector=="string")ret=jQuery.multiFilter(selector,ret);return this.pushStack(jQuery.unique(ret));};});jQuery.each({appendTo:"append",prependTo:"prepend",insertBefore:"before",insertAfter:"after",replaceAll:"replaceWith"},function(name,original){jQuery.fn[name]=function(){var args=arguments;return this.each(function(){for(var i=0,length=args.length;i<length;i++)jQuery(args[i])[original](this);});};});jQuery.each({removeAttr:function(name){jQuery.attr(this,name,"");if(this.nodeType==1)this.removeAttribute(name);},addClass:function(classNames){jQuery.className.add(this,classNames);},removeClass:function(classNames){jQuery.className.remove(this,classNames);},toggleClass:function(classNames){jQuery.className[jQuery.className.has(this,classNames)?"remove":"add"](this,classNames);},remove:function(selector){if(!selector||jQuery.filter(selector,[this]).r.length){jQuery("*",this).add(this).each(function(){jQuery.event.remove(this);jQuery.removeData(this);});if(this.parentNode)this.parentNode.removeChild(this);}},empty:function(){jQuery(">*",this).remove();while(this.firstChild)this.removeChild(this.firstChild);}},function(name,fn){jQuery.fn[name]=function(){return this.each(fn,arguments);};});jQuery.each(["Height","Width"],function(i,name){var type=name.toLowerCase();jQuery.fn[type]=function(size){return this[0]==window?jQuery.browser.opera&&document.body["client"+name]||jQuery.browser.safari&&window["inner"+name]||document.compatMode=="CSS1Compat"&&document.documentElement["client"+name]||document.body["client"+name]:this[0]==document?Math.max(Math.max(document.body["scroll"+name],document.documentElement["scroll"+name]),Math.max(document.body["offset"+name],document.documentElement["offset"+name])):size==undefined?(this.length?jQuery.css(this[0],type):null):this.css(type,size.constructor==String?size:size+"px");};});var chars=jQuery.browser.safari&&parseInt(jQuery.browser.version)<417?"(?:[\\w*_-]|\\\\.)":"(?:[\\w\u0128-\uFFFF*_-]|\\\\.)",quickChild=new RegExp("^>\\s*("+chars+"+)"),quickID=new RegExp("^("+chars+"+)(#)("+chars+"+)"),quickClass=new RegExp("^([#.]?)("+chars+"*)");jQuery.extend({expr:{"":function(a,i,m){return m[2]=="*"||jQuery.nodeName(a,m[2]);},"#":function(a,i,m){return a.getAttribute("id")==m[2];},":":{lt:function(a,i,m){return i<m[3]-0;},gt:function(a,i,m){return i>m[3]-0;},nth:function(a,i,m){return m[3]-0==i;},eq:function(a,i,m){return m[3]-0==i;},first:function(a,i){return i==0;},last:function(a,i,m,r){return i==r.length-1;},even:function(a,i){return i%2==0;},odd:function(a,i){return i%2;},"first-child":function(a){return a.parentNode.getElementsByTagName("*")[0]==a;},"last-child":function(a){return jQuery.nth(a.parentNode.lastChild,1,"previousSibling")==a;},"only-child":function(a){return!jQuery.nth(a.parentNode.lastChild,2,"previousSibling");},parent:function(a){return a.firstChild;},empty:function(a){return!a.firstChild;},contains:function(a,i,m){return(a.textContent||a.innerText||jQuery(a).text()||"").indexOf(m[3])>=0;},visible:function(a){return"hidden"!=a.type&&jQuery.css(a,"display")!="none"&&jQuery.css(a,"visibility")!="hidden";},hidden:function(a){return"hidden"==a.type||jQuery.css(a,"display")=="none"||jQuery.css(a,"visibility")=="hidden";},enabled:function(a){return!a.disabled;},disabled:function(a){return a.disabled;},checked:function(a){return a.checked;},selected:function(a){return a.selected||jQuery.attr(a,"selected");},text:function(a){return"text"==a.type;},radio:function(a){return"radio"==a.type;},checkbox:function(a){return"checkbox"==a.type;},file:function(a){return"file"==a.type;},password:function(a){return"password"==a.type;},submit:function(a){return"submit"==a.type;},image:function(a){return"image"==a.type;},reset:function(a){return"reset"==a.type;},button:function(a){return"button"==a.type||jQuery.nodeName(a,"button");},input:function(a){return/input|select|textarea|button/i.test(a.nodeName);},has:function(a,i,m){return jQuery.find(m[3],a).length;},header:function(a){return/h\d/i.test(a.nodeName);},animated:function(a){return jQuery.grep(jQuery.timers,function(fn){return a==fn.elem;}).length;}}},parse:[/^(\[) *@?([\w-]+) *([!*$^~=]*) *('?"?)(.*?)\4 *\]/,/^(:)([\w-]+)\("?'?(.*?(\(.*?\))?[^(]*?)"?'?\)/,new RegExp("^([:.#]*)("+chars+"+)")],multiFilter:function(expr,elems,not){var old,cur=[];while(expr&&expr!=old){old=expr;var f=jQuery.filter(expr,elems,not);expr=f.t.replace(/^\s*,\s*/,"");cur=not?elems=f.r:jQuery.merge(cur,f.r);}return cur;},find:function(t,context){if(typeof t!="string")return[t];if(context&&context.nodeType!=1&&context.nodeType!=9)return[];context=context||document;var ret=[context],done=[],last,nodeName;while(t&&last!=t){var r=[];last=t;t=jQuery.trim(t);var foundToken=false;var re=quickChild;var m=re.exec(t);if(m){nodeName=m[1].toUpperCase();for(var i=0;ret[i];i++)for(var c=ret[i].firstChild;c;c=c.nextSibling)if(c.nodeType==1&&(nodeName=="*"||c.nodeName.toUpperCase()==nodeName))r.push(c);ret=r;t=t.replace(re,"");if(t.indexOf(" ")==0)continue;foundToken=true;}else{re=/^([>+~])\s*(\w*)/i;if((m=re.exec(t))!=null){r=[];var merge={};nodeName=m[2].toUpperCase();m=m[1];for(var j=0,rl=ret.length;j<rl;j++){var n=m=="~"||m=="+"?ret[j].nextSibling:ret[j].firstChild;for(;n;n=n.nextSibling)if(n.nodeType==1){var id=jQuery.data(n);if(m=="~"&&merge[id])break;if(!nodeName||n.nodeName.toUpperCase()==nodeName){if(m=="~")merge[id]=true;r.push(n);}if(m=="+")break;}}ret=r;t=jQuery.trim(t.replace(re,""));foundToken=true;}}if(t&&!foundToken){if(!t.indexOf(",")){if(context==ret[0])ret.shift();done=jQuery.merge(done,ret);r=ret=[context];t=" "+t.substr(1,t.length);}else{var re2=quickID;var m=re2.exec(t);if(m){m=[0,m[2],m[3],m[1]];}else{re2=quickClass;m=re2.exec(t);}m[2]=m[2].replace(/\\/g,"");var elem=ret[ret.length-1];if(m[1]=="#"&&elem&&elem.getElementById&&!jQuery.isXMLDoc(elem)){var oid=elem.getElementById(m[2]);if((jQuery.browser.msie||jQuery.browser.opera)&&oid&&typeof oid.id=="string"&&oid.id!=m[2])oid=jQuery('[@id="'+m[2]+'"]',elem)[0];ret=r=oid&&(!m[3]||jQuery.nodeName(oid,m[3]))?[oid]:[];}else{for(var i=0;ret[i];i++){var tag=m[1]=="#"&&m[3]?m[3]:m[1]!=""||m[0]==""?"*":m[2];if(tag=="*"&&ret[i].nodeName.toLowerCase()=="object")tag="param";r=jQuery.merge(r,ret[i].getElementsByTagName(tag));}if(m[1]==".")r=jQuery.classFilter(r,m[2]);if(m[1]=="#"){var tmp=[];for(var i=0;r[i];i++)if(r[i].getAttribute("id")==m[2]){tmp=[r[i]];break;}r=tmp;}ret=r;}t=t.replace(re2,"");}}if(t){var val=jQuery.filter(t,r);ret=r=val.r;t=jQuery.trim(val.t);}}if(t)ret=[];if(ret&&context==ret[0])ret.shift();done=jQuery.merge(done,ret);return done;},classFilter:function(r,m,not){m=" "+m+" ";var tmp=[];for(var i=0;r[i];i++){var pass=(" "+r[i].className+" ").indexOf(m)>=0;if(!not&&pass||not&&!pass)tmp.push(r[i]);}return tmp;},filter:function(t,r,not){var last;while(t&&t!=last){last=t;var p=jQuery.parse,m;for(var i=0;p[i];i++){m=p[i].exec(t);if(m){t=t.substring(m[0].length);m[2]=m[2].replace(/\\/g,"");break;}}if(!m)break;if(m[1]==":"&&m[2]=="not")r=isSimple.test(m[3])?jQuery.filter(m[3],r,true).r:jQuery(r).not(m[3]);else if(m[1]==".")r=jQuery.classFilter(r,m[2],not);else if(m[1]=="["){var tmp=[],type=m[3];for(var i=0,rl=r.length;i<rl;i++){var a=r[i],z=a[jQuery.props[m[2]]||m[2]];if(z==null||/href|src|selected/.test(m[2]))z=jQuery.attr(a,m[2])||'';if((type==""&&!!z||type=="="&&z==m[5]||type=="!="&&z!=m[5]||type=="^="&&z&&!z.indexOf(m[5])||type=="$="&&z.substr(z.length-m[5].length)==m[5]||(type=="*="||type=="~=")&&z.indexOf(m[5])>=0)^not)tmp.push(a);}r=tmp;}else if(m[1]==":"&&m[2]=="nth-child"){var merge={},tmp=[],test=/(-?)(\d*)n((?:\+|-)?\d*)/.exec(m[3]=="even"&&"2n"||m[3]=="odd"&&"2n+1"||!/\D/.test(m[3])&&"0n+"+m[3]||m[3]),first=(test[1]+(test[2]||1))-0,last=test[3]-0;for(var i=0,rl=r.length;i<rl;i++){var node=r[i],parentNode=node.parentNode,id=jQuery.data(parentNode);if(!merge[id]){var c=1;for(var n=parentNode.firstChild;n;n=n.nextSibling)if(n.nodeType==1)n.nodeIndex=c++;merge[id]=true;}var add=false;if(first==0){if(node.nodeIndex==last)add=true;}else if((node.nodeIndex-last)%first==0&&(node.nodeIndex-last)/first>=0)add=true;if(add^not)tmp.push(node);}r=tmp;}else{var fn=jQuery.expr[m[1]];if(typeof fn=="object")fn=fn[m[2]];if(typeof fn=="string")fn=eval("false||function(a,i){return "+fn+";}");r=jQuery.grep(r,function(elem,i){return fn(elem,i,m,r);},not);}}return{r:r,t:t};},dir:function(elem,dir){var matched=[];var cur=elem[dir];while(cur&&cur!=document){if(cur.nodeType==1)matched.push(cur);cur=cur[dir];}return matched;},nth:function(cur,result,dir,elem){result=result||1;var num=0;for(;cur;cur=cur[dir])if(cur.nodeType==1&&++num==result)break;return cur;},sibling:function(n,elem){var r=[];for(;n;n=n.nextSibling){if(n.nodeType==1&&(!elem||n!=elem))r.push(n);}return r;}});jQuery.event={add:function(elem,types,handler,data){if(elem.nodeType==3||elem.nodeType==8)return;if(jQuery.browser.msie&&elem.setInterval!=undefined)elem=window;if(!handler.guid)handler.guid=this.guid++;if(data!=undefined){var fn=handler;handler=function(){return fn.apply(this,arguments);};handler.data=data;handler.guid=fn.guid;}var events=jQuery.data(elem,"events")||jQuery.data(elem,"events",{}),handle=jQuery.data(elem,"handle")||jQuery.data(elem,"handle",function(){var val;if(typeof jQuery=="undefined"||jQuery.event.triggered)return val;val=jQuery.event.handle.apply(arguments.callee.elem,arguments);return val;});handle.elem=elem;jQuery.each(types.split(/\s+/),function(index,type){var parts=type.split(".");type=parts[0];handler.type=parts[1];var handlers=events[type];if(!handlers){handlers=events[type]={};if(!jQuery.event.special[type]||jQuery.event.special[type].setup.call(elem)===false){if(elem.addEventListener)elem.addEventListener(type,handle,false);else if(elem.attachEvent)elem.attachEvent("on"+type,handle);}}handlers[handler.guid]=handler;jQuery.event.global[type]=true;});elem=null;},guid:1,global:{},remove:function(elem,types,handler){if(elem.nodeType==3||elem.nodeType==8)return;var events=jQuery.data(elem,"events"),ret,index;if(events){if(types==undefined||(typeof types=="string"&&types.charAt(0)=="."))for(var type in events)this.remove(elem,type+(types||""));else{if(types.type){handler=types.handler;types=types.type;}jQuery.each(types.split(/\s+/),function(index,type){var parts=type.split(".");type=parts[0];if(events[type]){if(handler)delete events[type][handler.guid];else
for(handler in events[type])if(!parts[1]||events[type][handler].type==parts[1])delete events[type][handler];for(ret in events[type])break;if(!ret){if(!jQuery.event.special[type]||jQuery.event.special[type].teardown.call(elem)===false){if(elem.removeEventListener)elem.removeEventListener(type,jQuery.data(elem,"handle"),false);else if(elem.detachEvent)elem.detachEvent("on"+type,jQuery.data(elem,"handle"));}ret=null;delete events[type];}}});}for(ret in events)break;if(!ret){var handle=jQuery.data(elem,"handle");if(handle)handle.elem=null;jQuery.removeData(elem,"events");jQuery.removeData(elem,"handle");}}},trigger:function(type,data,elem,donative,extra){data=jQuery.makeArray(data||[]);if(type.indexOf("!")>=0){type=type.slice(0,-1);var exclusive=true;}if(!elem){if(this.global[type])jQuery("*").add([window,document]).trigger(type,data);}else{if(elem.nodeType==3||elem.nodeType==8)return undefined;var val,ret,fn=jQuery.isFunction(elem[type]||null),event=!data[0]||!data[0].preventDefault;if(event)data.unshift(this.fix({type:type,target:elem}));data[0].type=type;if(exclusive)data[0].exclusive=true;if(jQuery.isFunction(jQuery.data(elem,"handle")))val=jQuery.data(elem,"handle").apply(elem,data);if(!fn&&elem["on"+type]&&elem["on"+type].apply(elem,data)===false)val=false;if(event)data.shift();if(extra&&jQuery.isFunction(extra)){ret=extra.apply(elem,val==null?data:data.concat(val));if(ret!==undefined)val=ret;}if(fn&&donative!==false&&val!==false&&!(jQuery.nodeName(elem,'a')&&type=="click")){this.triggered=true;try{elem[type]();}catch(e){}}this.triggered=false;}return val;},handle:function(event){var val;event=jQuery.event.fix(event||window.event||{});var parts=event.type.split(".");event.type=parts[0];var handlers=jQuery.data(this,"events")&&jQuery.data(this,"events")[event.type],args=Array.prototype.slice.call(arguments,1);args.unshift(event);for(var j in handlers){var handler=handlers[j];args[0].handler=handler;args[0].data=handler.data;if(!parts[1]&&!event.exclusive||handler.type==parts[1]){var ret=handler.apply(this,args);if(val!==false)val=ret;if(ret===false){event.preventDefault();event.stopPropagation();}}}if(jQuery.browser.msie)event.target=event.preventDefault=event.stopPropagation=event.handler=event.data=null;return val;},fix:function(event){var originalEvent=event;event=jQuery.extend({},originalEvent);event.preventDefault=function(){if(originalEvent.preventDefault)originalEvent.preventDefault();originalEvent.returnValue=false;};event.stopPropagation=function(){if(originalEvent.stopPropagation)originalEvent.stopPropagation();originalEvent.cancelBubble=true;};if(!event.target)event.target=event.srcElement||document;if(event.target.nodeType==3)event.target=originalEvent.target.parentNode;if(!event.relatedTarget&&event.fromElement)event.relatedTarget=event.fromElement==event.target?event.toElement:event.fromElement;if(event.pageX==null&&event.clientX!=null){var doc=document.documentElement,body=document.body;event.pageX=event.clientX+(doc&&doc.scrollLeft||body&&body.scrollLeft||0)-(doc.clientLeft||0);event.pageY=event.clientY+(doc&&doc.scrollTop||body&&body.scrollTop||0)-(doc.clientTop||0);}if(!event.which&&((event.charCode||event.charCode===0)?event.charCode:event.keyCode))event.which=event.charCode||event.keyCode;if(!event.metaKey&&event.ctrlKey)event.metaKey=event.ctrlKey;if(!event.which&&event.button)event.which=(event.button&1?1:(event.button&2?3:(event.button&4?2:0)));return event;},special:{ready:{setup:function(){bindReady();return;},teardown:function(){return;}},mouseenter:{setup:function(){if(jQuery.browser.msie)return false;jQuery(this).bind("mouseover",jQuery.event.special.mouseenter.handler);return true;},teardown:function(){if(jQuery.browser.msie)return false;jQuery(this).unbind("mouseover",jQuery.event.special.mouseenter.handler);return true;},handler:function(event){if(withinElement(event,this))return true;arguments[0].type="mouseenter";return jQuery.event.handle.apply(this,arguments);}},mouseleave:{setup:function(){if(jQuery.browser.msie)return false;jQuery(this).bind("mouseout",jQuery.event.special.mouseleave.handler);return true;},teardown:function(){if(jQuery.browser.msie)return false;jQuery(this).unbind("mouseout",jQuery.event.special.mouseleave.handler);return true;},handler:function(event){if(withinElement(event,this))return true;arguments[0].type="mouseleave";return jQuery.event.handle.apply(this,arguments);}}}};jQuery.fn.extend({bind:function(type,data,fn){return type=="unload"?this.one(type,data,fn):this.each(function(){jQuery.event.add(this,type,fn||data,fn&&data);});},one:function(type,data,fn){return this.each(function(){jQuery.event.add(this,type,function(event){jQuery(this).unbind(event);return(fn||data).apply(this,arguments);},fn&&data);});},unbind:function(type,fn){return this.each(function(){jQuery.event.remove(this,type,fn);});},trigger:function(type,data,fn){return this.each(function(){jQuery.event.trigger(type,data,this,true,fn);});},triggerHandler:function(type,data,fn){if(this[0])return jQuery.event.trigger(type,data,this[0],false,fn);return undefined;},toggle:function(){var args=arguments;return this.click(function(event){this.lastToggle=0==this.lastToggle?1:0;event.preventDefault();return args[this.lastToggle].apply(this,arguments)||false;});},hover:function(fnOver,fnOut){return this.bind('mouseenter',fnOver).bind('mouseleave',fnOut);},ready:function(fn){bindReady();if(jQuery.isReady)fn.call(document,jQuery);else
jQuery.readyList.push(function(){return fn.call(this,jQuery);});return this;}});jQuery.extend({isReady:false,readyList:[],ready:function(){if(!jQuery.isReady){jQuery.isReady=true;if(jQuery.readyList){jQuery.each(jQuery.readyList,function(){this.apply(document);});jQuery.readyList=null;}jQuery(document).triggerHandler("ready");}}});var readyBound=false;function bindReady(){if(readyBound)return;readyBound=true;if(document.addEventListener&&!jQuery.browser.opera)document.addEventListener("DOMContentLoaded",jQuery.ready,false);if(jQuery.browser.msie&&window==top)(function(){if(jQuery.isReady)return;try{document.documentElement.doScroll("left");}catch(error){setTimeout(arguments.callee,0);return;}jQuery.ready();})();if(jQuery.browser.opera)document.addEventListener("DOMContentLoaded",function(){if(jQuery.isReady)return;for(var i=0;i<document.styleSheets.length;i++)if(document.styleSheets[i].disabled){setTimeout(arguments.callee,0);return;}jQuery.ready();},false);if(jQuery.browser.safari){var numStyles;(function(){if(jQuery.isReady)return;if(document.readyState!="loaded"&&document.readyState!="complete"){setTimeout(arguments.callee,0);return;}if(numStyles===undefined)numStyles=jQuery("style, link[rel=stylesheet]").length;if(document.styleSheets.length!=numStyles){setTimeout(arguments.callee,0);return;}jQuery.ready();})();}jQuery.event.add(window,"load",jQuery.ready);}jQuery.each(("blur,focus,load,resize,scroll,unload,click,dblclick,"+"mousedown,mouseup,mousemove,mouseover,mouseout,change,select,"+"submit,keydown,keypress,keyup,error").split(","),function(i,name){jQuery.fn[name]=function(fn){return fn?this.bind(name,fn):this.trigger(name);};});var withinElement=function(event,elem){var parent=event.relatedTarget;while(parent&&parent!=elem)try{parent=parent.parentNode;}catch(error){parent=elem;}return parent==elem;};jQuery(window).bind("unload",function(){jQuery("*").add(document).unbind();});jQuery.fn.extend({load:function(url,params,callback){if(jQuery.isFunction(url))return this.bind("load",url);var off=url.indexOf(" ");if(off>=0){var selector=url.slice(off,url.length);url=url.slice(0,off);}callback=callback||function(){};var type="GET";if(params)if(jQuery.isFunction(params)){callback=params;params=null;}else{params=jQuery.param(params);type="POST";}var self=this;jQuery.ajax({url:url,type:type,dataType:"html",data:params,complete:function(res,status){if(status=="success"||status=="notmodified")self.html(selector?jQuery("<div/>").append(res.responseText.replace(/<script(.|\s)*?\/script>/g,"")).find(selector):res.responseText);self.each(callback,[res.responseText,status,res]);}});return this;},serialize:function(){return jQuery.param(this.serializeArray());},serializeArray:function(){return this.map(function(){return jQuery.nodeName(this,"form")?jQuery.makeArray(this.elements):this;}).filter(function(){return this.name&&!this.disabled&&(this.checked||/select|textarea/i.test(this.nodeName)||/text|hidden|password/i.test(this.type));}).map(function(i,elem){var val=jQuery(this).val();return val==null?null:val.constructor==Array?jQuery.map(val,function(val,i){return{name:elem.name,value:val};}):{name:elem.name,value:val};}).get();}});jQuery.each("ajaxStart,ajaxStop,ajaxComplete,ajaxError,ajaxSuccess,ajaxSend".split(","),function(i,o){jQuery.fn[o]=function(f){return this.bind(o,f);};});var jsc=(new Date).getTime();jQuery.extend({get:function(url,data,callback,type){if(jQuery.isFunction(data)){callback=data;data=null;}return jQuery.ajax({type:"GET",url:url,data:data,success:callback,dataType:type});},getScript:function(url,callback){return jQuery.get(url,null,callback,"script");},getJSON:function(url,data,callback){return jQuery.get(url,data,callback,"json");},post:function(url,data,callback,type){if(jQuery.isFunction(data)){callback=data;data={};}return jQuery.ajax({type:"POST",url:url,data:data,success:callback,dataType:type});},ajaxSetup:function(settings){jQuery.extend(jQuery.ajaxSettings,settings);},ajaxSettings:{global:true,type:"GET",timeout:0,contentType:"application/x-www-form-urlencoded",processData:true,async:true,data:null,username:null,password:null,accepts:{xml:"application/xml, text/xml",html:"text/html",script:"text/javascript, application/javascript",json:"application/json, text/javascript",text:"text/plain",_default:"*/*"}},lastModified:{},ajax:function(s){var jsonp,jsre=/=\?(&|$)/g,status,data;s=jQuery.extend(true,s,jQuery.extend(true,{},jQuery.ajaxSettings,s));if(s.data&&s.processData&&typeof s.data!="string")s.data=jQuery.param(s.data);if(s.dataType=="jsonp"){if(s.type.toLowerCase()=="get"){if(!s.url.match(jsre))s.url+=(s.url.match(/\?/)?"&":"?")+(s.jsonp||"callback")+"=?";}else if(!s.data||!s.data.match(jsre))s.data=(s.data?s.data+"&":"")+(s.jsonp||"callback")+"=?";s.dataType="json";}if(s.dataType=="json"&&(s.data&&s.data.match(jsre)||s.url.match(jsre))){jsonp="jsonp"+jsc++;if(s.data)s.data=(s.data+"").replace(jsre,"="+jsonp+"$1");s.url=s.url.replace(jsre,"="+jsonp+"$1");s.dataType="script";window[jsonp]=function(tmp){data=tmp;success();complete();window[jsonp]=undefined;try{delete window[jsonp];}catch(e){}if(head)head.removeChild(script);};}if(s.dataType=="script"&&s.cache==null)s.cache=false;if(s.cache===false&&s.type.toLowerCase()=="get"){var ts=(new Date()).getTime();var ret=s.url.replace(/(\?|&)_=.*?(&|$)/,"$1_="+ts+"$2");s.url=ret+((ret==s.url)?(s.url.match(/\?/)?"&":"?")+"_="+ts:"");}if(s.data&&s.type.toLowerCase()=="get"){s.url+=(s.url.match(/\?/)?"&":"?")+s.data;s.data=null;}if(s.global&&!jQuery.active++)jQuery.event.trigger("ajaxStart");if((!s.url.indexOf("http")||!s.url.indexOf("//"))&&s.dataType=="script"&&s.type.toLowerCase()=="get"){var head=document.getElementsByTagName("head")[0];var script=document.createElement("script");script.src=s.url;if(s.scriptCharset)script.charset=s.scriptCharset;if(!jsonp){var done=false;script.onload=script.onreadystatechange=function(){if(!done&&(!this.readyState||this.readyState=="loaded"||this.readyState=="complete")){done=true;success();complete();head.removeChild(script);}};}head.appendChild(script);return undefined;}var requestDone=false;var xml=window.ActiveXObject?new ActiveXObject("Microsoft.XMLHTTP"):new XMLHttpRequest();xml.open(s.type,s.url,s.async,s.username,s.password);try{if(s.data)xml.setRequestHeader("Content-Type",s.contentType);if(s.ifModified)xml.setRequestHeader("If-Modified-Since",jQuery.lastModified[s.url]||"Thu, 01 Jan 1970 00:00:00 GMT");xml.setRequestHeader("X-Requested-With","XMLHttpRequest");xml.setRequestHeader("Accept",s.dataType&&s.accepts[s.dataType]?s.accepts[s.dataType]+", */*":s.accepts._default);}catch(e){}if(s.beforeSend)s.beforeSend(xml);if(s.global)jQuery.event.trigger("ajaxSend",[xml,s]);var onreadystatechange=function(isTimeout){if(!requestDone&&xml&&(xml.readyState==4||isTimeout=="timeout")){requestDone=true;if(ival){clearInterval(ival);ival=null;}status=isTimeout=="timeout"&&"timeout"||!jQuery.httpSuccess(xml)&&"error"||s.ifModified&&jQuery.httpNotModified(xml,s.url)&&"notmodified"||"success";if(status=="success"){try{data=jQuery.httpData(xml,s.dataType);}catch(e){status="parsererror";}}if(status=="success"){var modRes;try{modRes=xml.getResponseHeader("Last-Modified");}catch(e){}if(s.ifModified&&modRes)jQuery.lastModified[s.url]=modRes;if(!jsonp)success();}else
jQuery.handleError(s,xml,status);complete();if(s.async)xml=null;}};if(s.async){var ival=setInterval(onreadystatechange,13);if(s.timeout>0)setTimeout(function(){if(xml){xml.abort();if(!requestDone)onreadystatechange("timeout");}},s.timeout);}try{xml.send(s.data);}catch(e){jQuery.handleError(s,xml,null,e);}if(!s.async)onreadystatechange();function success(){if(s.success)s.success(data,status);if(s.global)jQuery.event.trigger("ajaxSuccess",[xml,s]);}function complete(){if(s.complete)s.complete(xml,status);if(s.global)jQuery.event.trigger("ajaxComplete",[xml,s]);if(s.global&&!--jQuery.active)jQuery.event.trigger("ajaxStop");}return xml;},handleError:function(s,xml,status,e){if(s.error)s.error(xml,status,e);if(s.global)jQuery.event.trigger("ajaxError",[xml,s,e]);},active:0,httpSuccess:function(r){try{return!r.status&&location.protocol=="file:"||(r.status>=200&&r.status<300)||r.status==304||r.status==1223||jQuery.browser.safari&&r.status==undefined;}catch(e){}return false;},httpNotModified:function(xml,url){try{var xmlRes=xml.getResponseHeader("Last-Modified");return xml.status==304||xmlRes==jQuery.lastModified[url]||jQuery.browser.safari&&xml.status==undefined;}catch(e){}return false;},httpData:function(r,type){var ct=r.getResponseHeader("content-type");var xml=type=="xml"||!type&&ct&&ct.indexOf("xml")>=0;var data=xml?r.responseXML:r.responseText;if(xml&&data.documentElement.tagName=="parsererror")throw"parsererror";if(type=="script")jQuery.globalEval(data);if(type=="json")data=eval("("+data+")");return data;},param:function(a){var s=[];if(a.constructor==Array||a.jquery)jQuery.each(a,function(){s.push(encodeURIComponent(this.name)+"="+encodeURIComponent(this.value));});else
for(var j in a)if(a[j]&&a[j].constructor==Array)jQuery.each(a[j],function(){s.push(encodeURIComponent(j)+"="+encodeURIComponent(this));});else
s.push(encodeURIComponent(j)+"="+encodeURIComponent(a[j]));return s.join("&").replace(/%20/g,"+");}});jQuery.fn.extend({show:function(speed,callback){return speed?this.animate({height:"show",width:"show",opacity:"show"},speed,callback):this.filter(":hidden").each(function(){this.style.display=this.oldblock||"";if(jQuery.css(this,"display")=="none"){var elem=jQuery("<"+this.tagName+" />").appendTo("body");this.style.display=elem.css("display");if(this.style.display=="none")this.style.display="block";elem.remove();}}).end();},hide:function(speed,callback){return speed?this.animate({height:"hide",width:"hide",opacity:"hide"},speed,callback):this.filter(":visible").each(function(){this.oldblock=this.oldblock||jQuery.css(this,"display");this.style.display="none";}).end();},_toggle:jQuery.fn.toggle,toggle:function(fn,fn2){return jQuery.isFunction(fn)&&jQuery.isFunction(fn2)?this._toggle(fn,fn2):fn?this.animate({height:"toggle",width:"toggle",opacity:"toggle"},fn,fn2):this.each(function(){jQuery(this)[jQuery(this).is(":hidden")?"show":"hide"]();});},slideDown:function(speed,callback){return this.animate({height:"show"},speed,callback);},slideUp:function(speed,callback){return this.animate({height:"hide"},speed,callback);},slideToggle:function(speed,callback){return this.animate({height:"toggle"},speed,callback);},fadeIn:function(speed,callback){return this.animate({opacity:"show"},speed,callback);},fadeOut:function(speed,callback){return this.animate({opacity:"hide"},speed,callback);},fadeTo:function(speed,to,callback){return this.animate({opacity:to},speed,callback);},animate:function(prop,speed,easing,callback){var optall=jQuery.speed(speed,easing,callback);return this[optall.queue===false?"each":"queue"](function(){if(this.nodeType!=1)return false;var opt=jQuery.extend({},optall);var hidden=jQuery(this).is(":hidden"),self=this;for(var p in prop){if(prop[p]=="hide"&&hidden||prop[p]=="show"&&!hidden)return jQuery.isFunction(opt.complete)&&opt.complete.apply(this);if(p=="height"||p=="width"){opt.display=jQuery.css(this,"display");opt.overflow=this.style.overflow;}}if(opt.overflow!=null)this.style.overflow="hidden";opt.curAnim=jQuery.extend({},prop);jQuery.each(prop,function(name,val){var e=new jQuery.fx(self,opt,name);if(/toggle|show|hide/.test(val))e[val=="toggle"?hidden?"show":"hide":val](prop);else{var parts=val.toString().match(/^([+-]=)?([\d+-.]+)(.*)$/),start=e.cur(true)||0;if(parts){var end=parseFloat(parts[2]),unit=parts[3]||"px";if(unit!="px"){self.style[name]=(end||1)+unit;start=((end||1)/e.cur(true))*start;self.style[name]=start+unit;}if(parts[1])end=((parts[1]=="-="?-1:1)*end)+start;e.custom(start,end,unit);}else
e.custom(start,val,"");}});return true;});},queue:function(type,fn){if(jQuery.isFunction(type)||(type&&type.constructor==Array)){fn=type;type="fx";}if(!type||(typeof type=="string"&&!fn))return queue(this[0],type);return this.each(function(){if(fn.constructor==Array)queue(this,type,fn);else{queue(this,type).push(fn);if(queue(this,type).length==1)fn.apply(this);}});},stop:function(clearQueue,gotoEnd){var timers=jQuery.timers;if(clearQueue)this.queue([]);this.each(function(){for(var i=timers.length-1;i>=0;i--)if(timers[i].elem==this){if(gotoEnd)timers[i](true);timers.splice(i,1);}});if(!gotoEnd)this.dequeue();return this;}});var queue=function(elem,type,array){if(!elem)return undefined;type=type||"fx";var q=jQuery.data(elem,type+"queue");if(!q||array)q=jQuery.data(elem,type+"queue",array?jQuery.makeArray(array):[]);return q;};jQuery.fn.dequeue=function(type){type=type||"fx";return this.each(function(){var q=queue(this,type);q.shift();if(q.length)q[0].apply(this);});};jQuery.extend({speed:function(speed,easing,fn){var opt=speed&&speed.constructor==Object?speed:{complete:fn||!fn&&easing||jQuery.isFunction(speed)&&speed,duration:speed,easing:fn&&easing||easing&&easing.constructor!=Function&&easing};opt.duration=(opt.duration&&opt.duration.constructor==Number?opt.duration:{slow:600,fast:200}[opt.duration])||400;opt.old=opt.complete;opt.complete=function(){if(opt.queue!==false)jQuery(this).dequeue();if(jQuery.isFunction(opt.old))opt.old.apply(this);};return opt;},easing:{linear:function(p,n,firstNum,diff){return firstNum+diff*p;},swing:function(p,n,firstNum,diff){return((-Math.cos(p*Math.PI)/2)+0.5)*diff+firstNum;}},timers:[],timerId:null,fx:function(elem,options,prop){this.options=options;this.elem=elem;this.prop=prop;if(!options.orig)options.orig={};}});jQuery.fx.prototype={update:function(){if(this.options.step)this.options.step.apply(this.elem,[this.now,this]);(jQuery.fx.step[this.prop]||jQuery.fx.step._default)(this);if(this.prop=="height"||this.prop=="width")this.elem.style.display="block";},cur:function(force){if(this.elem[this.prop]!=null&&this.elem.style[this.prop]==null)return this.elem[this.prop];var r=parseFloat(jQuery.css(this.elem,this.prop,force));return r&&r>-10000?r:parseFloat(jQuery.curCSS(this.elem,this.prop))||0;},custom:function(from,to,unit){this.startTime=(new Date()).getTime();this.start=from;this.end=to;this.unit=unit||this.unit||"px";this.now=this.start;this.pos=this.state=0;this.update();var self=this;function t(gotoEnd){return self.step(gotoEnd);}t.elem=this.elem;jQuery.timers.push(t);if(jQuery.timerId==null){jQuery.timerId=setInterval(function(){var timers=jQuery.timers;for(var i=0;i<timers.length;i++)if(!timers[i]())timers.splice(i--,1);if(!timers.length){clearInterval(jQuery.timerId);jQuery.timerId=null;}},13);}},show:function(){this.options.orig[this.prop]=jQuery.attr(this.elem.style,this.prop);this.options.show=true;this.custom(0,this.cur());if(this.prop=="width"||this.prop=="height")this.elem.style[this.prop]="1px";jQuery(this.elem).show();},hide:function(){this.options.orig[this.prop]=jQuery.attr(this.elem.style,this.prop);this.options.hide=true;this.custom(this.cur(),0);},step:function(gotoEnd){var t=(new Date()).getTime();if(gotoEnd||t>this.options.duration+this.startTime){this.now=this.end;this.pos=this.state=1;this.update();this.options.curAnim[this.prop]=true;var done=true;for(var i in this.options.curAnim)if(this.options.curAnim[i]!==true)done=false;if(done){if(this.options.display!=null){this.elem.style.overflow=this.options.overflow;this.elem.style.display=this.options.display;if(jQuery.css(this.elem,"display")=="none")this.elem.style.display="block";}if(this.options.hide)this.elem.style.display="none";if(this.options.hide||this.options.show)for(var p in this.options.curAnim)jQuery.attr(this.elem.style,p,this.options.orig[p]);}if(done&&jQuery.isFunction(this.options.complete))this.options.complete.apply(this.elem);return false;}else{var n=t-this.startTime;this.state=n/this.options.duration;this.pos=jQuery.easing[this.options.easing||(jQuery.easing.swing?"swing":"linear")](this.state,n,0,1,this.options.duration);this.now=this.start+((this.end-this.start)*this.pos);this.update();}return true;}};jQuery.fx.step={scrollLeft:function(fx){fx.elem.scrollLeft=fx.now;},scrollTop:function(fx){fx.elem.scrollTop=fx.now;},opacity:function(fx){jQuery.attr(fx.elem.style,"opacity",fx.now);},_default:function(fx){fx.elem.style[fx.prop]=fx.now+fx.unit;}};jQuery.fn.offset=function(){var left=0,top=0,elem=this[0],results;if(elem)with(jQuery.browser){var parent=elem.parentNode,offsetChild=elem,offsetParent=elem.offsetParent,doc=elem.ownerDocument,safari2=safari&&parseInt(version)<522&&!/adobeair/i.test(userAgent),fixed=jQuery.css(elem,"position")=="fixed";if(elem.getBoundingClientRect){var box=elem.getBoundingClientRect();add(box.left+Math.max(doc.documentElement.scrollLeft,doc.body.scrollLeft),box.top+Math.max(doc.documentElement.scrollTop,doc.body.scrollTop));add(-doc.documentElement.clientLeft,-doc.documentElement.clientTop);}else{add(elem.offsetLeft,elem.offsetTop);while(offsetParent){add(offsetParent.offsetLeft,offsetParent.offsetTop);if(mozilla&&!/^t(able|d|h)$/i.test(offsetParent.tagName)||safari&&!safari2)border(offsetParent);if(!fixed&&jQuery.css(offsetParent,"position")=="fixed")fixed=true;offsetChild=/^body$/i.test(offsetParent.tagName)?offsetChild:offsetParent;offsetParent=offsetParent.offsetParent;}while(parent&&parent.tagName&&!/^body|html$/i.test(parent.tagName)){if(!/^inline|table.*$/i.test(jQuery.css(parent,"display")))add(-parent.scrollLeft,-parent.scrollTop);if(mozilla&&jQuery.css(parent,"overflow")!="visible")border(parent);parent=parent.parentNode;}if((safari2&&(fixed||jQuery.css(offsetChild,"position")=="absolute"))||(mozilla&&jQuery.css(offsetChild,"position")!="absolute"))add(-doc.body.offsetLeft,-doc.body.offsetTop);if(fixed)add(Math.max(doc.documentElement.scrollLeft,doc.body.scrollLeft),Math.max(doc.documentElement.scrollTop,doc.body.scrollTop));}results={top:top,left:left};}function border(elem){add(jQuery.curCSS(elem,"borderLeftWidth",true),jQuery.curCSS(elem,"borderTopWidth",true));}function add(l,t){left+=parseInt(l)||0;top+=parseInt(t)||0;}return results;};})();



var fdSliderController;

(function() {

function fdSlider(inp,range,callback,classname,hide,tween,vertical) {

this._inp       = inp;
this._hideInput = hide;
this._min       = range[0]||0;
this._max       = range[1]||0;
this._range     = this._max - this._min;
this._tween     = tween;
this._mouseX    = 0;
this._timer     = null;
this._classname = classname;
this._drag      = false;
this._kbEnabled = true;
this._callback  = callback;
this._vertical  = vertical;
this._steps     = inp.tagName.toLowerCase() == "input" ? 10 : inp.options.length - 1;

this.NS_XHTML = "http://www.w3.org/1999/xhtml";
this.NS_STATE = "http://www.w3.org/2005/07/aaa";

this.events = {
stopevent: function(e) {
if(e == null) e = document.parentWindow.event;
if(e.stopPropagation) {
e.stopPropagation();
e.preventDefault();
}
/*@cc_on@*/
/*@if(@_win32)
e.cancelBubble = true;
e.returnValue = false;
/*@end@*/
return false;
},
redraw: function() {
self.locate();
try {
var sW = self.outerWrapper.offsetWidth;
var sH = self.outerWrapper.offsetHeight;
var hW = self.handle.offsetWidth;
var hH = self.handle.offsetHeight;
var bH = self.bar.offsetHeight;
var bW = self.bar.offsetWidth;
var sI = self._steps;

if(self._vertical) {
self.bar.style.height = Math.round(sH - hH) + "px";
self.bar.style.left   = Math.floor((sW - bW) / 2) + "px";
self.bar.style.top    = Math.round(hH / 2) + "px";
self._incPx    = (sH - hH) / sI < 1 ? 1 : (sH - hH) / sI;
} else {
self.bar.style.width  = Math.round(sW - hW) + "px";
self.bar.style.left   = Math.round(hW / 2) + "px";
self.bar.style.top    = Math.floor((sH - bH) / 2) + "px";
self._incPx    = (sW - hW) / sI < 1 ? 1 : (sW - hW) / sI;
};
self.resetHandlePosition();
} catch(err) { };
},
onfocus: function(e) {
self.outerWrapper.className = self.outerWrapper.className.replace('focused','') + ' focused';
if (window.addEventListener && !window.devicePixelRatio) {
window.addEventListener('DOMMouseScroll', self.events.trackmousewheel, false);
} else {
fdSliderController.addEvent(document, 'mousewheel', self.events.trackmousewheel);
fdSliderController.addEvent(window,   'mousewheel', self.events.trackmousewheel);
};
},
onblur: function(e) {
self.outerWrapper.className = self.outerWrapper.className.replace(/focused|fd-fc-slider-hover|fd-slider-hover/g,'');
if (window.addEventListener && !window.devicePixelRatio) window.removeEventListener('DOMMouseScroll', self.events.trackmousewheel, false);
else {
fdSliderController.removeEvent(document, 'mousewheel', self.events.trackmousewheel);
fdSliderController.removeEvent(window,   'mousewheel', self.events.trackmousewheel);
};

},
trackmousewheel: function(e) {
if(!self._kbEnabled) return;
var delta = 0;
var e = e || window.event;
if (e.wheelDelta) {
delta = e.wheelDelta/120;
if (window.opera) delta = -delta;
} else if(e.detail) {
delta = -e.detail/3;
};
if(delta) {
var xtmp = self._vertical ? self.handle.offsetTop : self.handle.offsetLeft;
var wtmp = self._vertical ? self.outerWrapper.offsetHeight - self.handle.offsetHeight : self.outerWrapper.offsetWidth - self.handle.offsetWidth;
var inc  = self._inp.tagName.toLowerCase() == "input" ? Math.round(self._incPx / 2) < 1 ? 1 : Math.round(self._incPx / 2) : self._incPx;
if(self._vertical) inc = -inc;
if(delta < 0) {
xtmp += inc;
xtmp = Math.ceil(xtmp);
} else {
xtmp -= inc;
xtmp = Math.floor(xtmp);
};
if(xtmp < 0) xtmp = 0;
else if(xtmp > wtmp) xtmp = wtmp;
self.updateInput(xtmp);
if(self._vertical) self.handle.style.top = xtmp + "px";
else self.handle.style.left = xtmp + "px";
};
return self.events.stopevent(e);
},
onkeypress: function(e) {
if (e == null) e = document.parentWindow.event;
if ((e.keyCode >= 35 && e.keyCode <= 40) || !self._kbEnabled) {
return self.events.stopevent(e);
};
},
onkeydown: function(e) {
if(!self._kbEnabled) return true;

if(e == null) e = document.parentWindow.event;
var kc = e.keyCode != null ? e.keyCode : e.charCode;

if ( kc < 35 || kc > 40 ) return true;

var xtmp = self._vertical ? self.handle.offsetTop : self.handle.offsetLeft;
var wtmp = self._vertical ? self.outerWrapper.offsetHeight - self.handle.offsetHeight : self.outerWrapper.offsetWidth - self.handle.offsetWidth;
var inc  = self._inp.tagName.toLowerCase() == "input" ? Math.round(self._incPx / 2) < 1 ? 1 : Math.round(self._incPx / 2) : self._incPx;

if(self._vertical) inc = -inc;

if( kc == 37 || kc == 40 ) {
xtmp -= inc;
xtmp = Math.floor(xtmp);
} else if( kc == 39 || kc == 38) {
xtmp += inc;
xtmp = Math.ceil(xtmp);
} else if( kc == 35 ) {
xtmp = wtmp;
} else if( kc == 36 ) {
xtmp = 0;
}

if(xtmp < 0) xtmp = 0;
else if(xtmp > wtmp) xtmp = wtmp;

self.updateInput(xtmp);
self.handle.style[self._vertical ? "top" : "left"] = xtmp + "px";

return self.events.stopevent(e);
},
onchange: function( e ) {
self.resetHandlePosition();
self.doCallback();
return true;
},
onmouseover: function( e ) {
/*@cc_on@*/
/*@if(@_jscript_version <= 5.6)
if(this.className.search(/focused/) != -1) {
this.className = this.className.replace("fd-fc-slider-hover", "") +' fd-fc-slider-hover';
return;
}
/*@end@*/
this.className = this.className.replace(/fd\-slider\-hover/g,"") +' fd-slider-hover';
},
onmouseout: function( e ) {
/*@cc_on@*/
/*@if(@_jscript_version <= 5.6)
if(this.className.search(/focused/) != -1) {
this.className = this.className.replace("fd-fc-slider-hover", "");
return;
}
/*@end@*/
this.className = this.className.replace(/fd\-slider\-hover/g,"");
},
onHmouseup:function(e) {
e = e || window.event;
fdSliderController.removeEvent(document, 'mousemove', self.events.trackmouse);
fdSliderController.removeEvent(document, 'mouseup', self.events.onHmouseup);
self._drag = false;
self._kbEnabled = true;

if(window.opera) try { setTimeout(function() { self.events.onfocus(); }, 0); } catch(err) {};

return self.events.stopevent(e);
},
onHmousedown: function(e) {
e = e || window.event;
self._mouseX    = self._vertical ? e.clientY : e.clientX;
self.handleX    = parseInt(self._vertical ? self.handle.offsetTop : self.handle.offsetLeft)||0;
self._drag      = true;
self._kbEnabled = false;

fdSliderController.addEvent(document, 'mousemove', self.events.trackmouse);
fdSliderController.addEvent(document, 'mouseup', self.events.onHmouseup);

if(window.devicePixelRatio || (document.all && !window.opera)) try { setTimeout(function() { self.handle.focus(); }, 0); } catch(err) {};
},
onmouseup: function( e ) {
e = e || window.event;
fdSliderController.removeEvent(document, 'mouseup', self.events.onmouseup);
if(!self._tween) {
clearTimeout(self._timer);
self._timer = null;
self._kbEnabled = true;
}
return self.events.stopevent(e);
},
trackmouse: function( e ) {
if (!e) var e = window.event;
var x = self._vertical ? self.handleX + (e.clientY-self._mouseX) : self.handleX + (e.clientX-self._mouseX);
if(x < 0) x = 0;
var max = self._vertical ? self.outerWrapper.offsetHeight - self.handle.offsetHeight : self.outerWrapper.offsetWidth - self.handle.offsetWidth;
if(x > max) x = max;
if(self._vertical) self.handle.style.top = x + "px";
else self.handle.style.left = x + "px";
self.updateInput(x);
},
onmousedown: function( e ) {
var targ;
if (!e) var e = window.event;
if (e.target) targ = e.target;
else if (e.srcElement) targ = e.srcElement;
if (targ.nodeType == 3) targ = targ.parentNode;

if(targ.className.search("fd-slider-handle") != -1) {
return true;
};

try { setTimeout(function() { self.handle.focus(); }, 0); } catch(err) {};

clearTimeout(self._timer);
self._timer = null;
self._kbEnabled = false;
self.locate();
self._drag      = false;
var posx        = 0;
var sLft        = 0;
var sTop        = 0;

if (document.documentElement && document.documentElement.scrollTop) {
sTop = document.documentElement.scrollTop;
sLft = document.documentElement.scrollLeft;
} else if (document.body) {
sTop = document.body.scrollTop;
sLft = document.body.scrollLeft;
}

if (e.pageX)            posx = self._vertical ? e.pageY : e.pageX;
else if (e.clientX)     posx = self._vertical ? e.clientY + sTop : e.clientX + sLft;

var diff = Math.round((self._vertical) ? self.handle.offsetHeight / 2 : self.handle.offsetWidth / 2);
posx -= self._vertical ? self._y + diff : self._x + diff;

if(posx < 0) posx = 0;
else if(!self._vertical && posx > self.outerWrapper.offsetWidth - self.handle.offsetWidth)  posx = self.outerWrapper.offsetWidth - self.handle.offsetWidth;
else if(self._vertical && posx > self.outerWrapper.offsetHeight - self.handle.offsetHeight) posx = self.outerWrapper.offsetHeight - self.handle.offsetHeight;

if(self._tween) {
self.tweenTo(posx);
} else {
fdSliderController.addEvent(document, 'mouseup', self.events.onmouseup);
self._posx = posx;
self.onTimer();
};
}
};

this.onTimer = function() {
var xtmp = self._vertical ? self.handle.offsetTop : self.handle.offsetLeft;
if(self._posx < xtmp) {
xtmp -= self._incPx;
xtmp = Math.floor(xtmp);
if(xtmp < self._posx) xtmp = self._posx;
} else {
xtmp += self._incPx;
xtmp = Math.ceil(xtmp);
if(xtmp > self._posx) xtmp = self._posx;
};
xtmp = Math.round(xtmp);
self.updateInput(xtmp);
self.handle.style[self._vertical ? "top" : "left"] = xtmp + "px";
if(xtmp != self._posx) self._timer = setTimeout(self.onTimer, 200);
else self._kbEnabled = true;
};

this.locate = function(){
var curleft = 0;
var curtop  = 0;
var obj = self.outerWrapper;
try {
while (obj.offsetParent) {
curleft += obj.offsetLeft;
curtop  += obj.offsetTop;
obj      = obj.offsetParent;
};
} catch(err) {}
self._x = curleft;
self._y = curtop;
};

this.tweenTo = function(x){
self._kbEnabled = false;
self._tweenX = parseInt(x);
self._tweenB = parseInt(self._vertical ? self.handle.style.top : self.handle.style.left);
self._tweenC = self._tweenX - self._tweenB;
self._tweenD = 20;
self._frame  = 0;
if(!self._timer) self._timer = setTimeout(self.tween,50);
};

this.tween = function(){
self._frame++;
var c = self._tweenC;
var d = 20;
var t = self._frame;
var b = self._tweenB;
var x = Math.ceil((t==d) ? b+c : c * (-Math.pow(2, -10 * t/d) + 1) + b);

self.handle.style[self._vertical ? "top" : "left"] = x + "px";
self.updateInput(x);
if(t!=d && !self._md) self._timer = setTimeout(self.tween,20);
else {
self.handle.style[self._vertical ? "top" : "left"] = self._tweenX + "px";
clearTimeout(self._timer);
self._timer = null;
self._kbEnabled = true;
};
};

this.updateInput = function(x) {
var max = self._vertical ? self.outerWrapper.offsetHeight - self.handle.offsetHeight : self.outerWrapper.offsetWidth - self.handle.offsetWidth;
var inc = max / self._range;

var val = Number(self._min) + Math.abs(Math.floor(x / inc));
if(self._vertical) val = -val;

if(val < self._min) val = self._min;
else if(val > self._max) val = self._max;

self.setInputValue(Math.round(val));
self.doCallback();
};

this.setInputValue = function(val) {
if(self._inp.tagName.toLowerCase() == "select") {
for(var i = 0, opt; opt = self._inp.options[i]; i++) {
if(opt.value && parseInt(opt.value, 10) == val) {
opt.selected = true;
break;
};
};
} else {
self._inp.value = val;
};
self.setAttrNS(self.handle, self.NS_STATE, "valuenow", val);
};

this.doCallback = function() {
if(self._callback) {
if(typeof self._callback == "string" && self._callback in window) window[self._callback]();
else if(typeof self._callback == "function") self._callback();
};
};

this.resetHandlePosition = function() {
var value = self._inp.tagName.toLowerCase() == "input" ? parseInt(self._inp.value, 10) : parseInt(self._inp.options[self._inp.selectedIndex].value, 10);
if(isNaN(value) || value < self._min) value = self._min;
else if(value > self._max) value = self._max;
self.setInputValue(value);
var max = self._vertical ? self.outerWrapper.offsetHeight - self.handle.offsetHeight : self.outerWrapper.offsetWidth - self.handle.offsetWidth;
var inc = max / self._range;
var tot = value - self._min;
var pos = (tot * inc < (self._min + (self._range / 2))) ? Math.floor(tot * inc) : Math.ceil(tot * inc);
if(self._vertical) {
self.handle.style.top = Math.abs(max - pos) + "px";
} else {
self.handle.style.left = pos + "px";
};
};

this.setAttrNS = function(elmTarget, uriNamespace, sAttrName, sAttrValue) {
if (typeof document.documentElement.setAttributeNS != 'undefined') {
elmTarget.setAttributeNS(uriNamespace, sAttrName, sAttrValue);
} else {
var nsMapping = {
"http://www.w3.org/1999/xhtml":"x:",
"http://www.w3.org/2005/07/aaa":"aaa:"
};
elmTarget.setAttribute(nsMapping[uriNamespace] + sAttrName, sAttrValue);
};
};

this.findLabel = function() {
var label;
if(self._inp.parentNode && self._inp.parentNode.tagName.toLowerCase() == "label") label = self._inp.parentNode;
else {
var labelList = document.getElementsByTagName('label');
for(var lbl = 0; lbl < labelList.length; lbl++) {
if((labelList[lbl]['htmlFor'] && labelList[lbl]['htmlFor'] == self._inp.id) || (labelList[lbl].getAttribute('for') == self._inp.id)) {
label = labelList[lbl];
break;
};
};
};
if(label && !label.id) { label.id = inp.id + "_label_" + fdSliderController.uniqueid++; };
return label;
};

this.build = function() {
if(self._hideInput) self._inp.style.display = "none";
else fdSliderController.addEvent(self._inp, 'change', self.events.onchange);

self.outerWrapper              = document.createElement('div');
self.outerWrapper.className    = "fd-slider" + (self._vertical ? "-vertical " : " ") + self._classname;
self.outerWrapper.id           = "fd-slider-" + inp.id;

self.wrapper                   = document.createElement('span');
self.wrapper.className         = "fd-slider-inner";

self.bar                       = document.createElement('span');
self.bar.className             = "fd-slider-bar";

self.handle                    = document.createElement('button');
self.handle.className          = "fd-slider-handle";

self.handle.appendChild(document.createTextNode(" "));

self.handle.setAttribute("type", "button");
self.handle.setAttribute("tabindex", "0");

self.outerWrapper.appendChild(self.wrapper);
self.outerWrapper.appendChild(self.bar);
self.outerWrapper.appendChild(self.handle);

self._inp.parentNode.insertBefore(self.outerWrapper, self._inp);

self.handle.setAttribute("tabindex", "0");

/*@cc_on@*/
/*@if(@_win32)
self.handle.unselectable       = "on";
self.bar.unselectable          = "on";
self.wrapper.unselectable      = "on";
self.outerWrapper.unselectable = "on";
/*@end@*/

fdSliderController.addEvent(self.outerWrapper, "mouseover", self.events.onmouseover);
fdSliderController.addEvent(self.outerWrapper, "mouseout",  self.events.onmouseout);
fdSliderController.addEvent(self.outerWrapper, "mousedown", self.events.onmousedown);
fdSliderController.addEvent(self.handle,       "keydown",   self.events.onkeydown);
fdSliderController.addEvent(self.handle,       "keypress",  self.events.onkeypress);
fdSliderController.addEvent(self.handle,       "focus",     self.events.onfocus);
fdSliderController.addEvent(self.handle,       "blur",      self.events.onblur);
fdSliderController.addEvent(self.handle,       "mousedown", self.events.onHmousedown);
fdSliderController.addEvent(self.handle,       "mouseup",   self.events.onHmouseup);
fdSliderController.addEvent(window,            "resize",    self.events.redraw);

self.setAttrNS(self.handle, self.NS_XHTML, "role", "wairole:slider");         // role:slider
self.setAttrNS(self.handle, self.NS_STATE, "valuemin", self._min);            // aaa:valuemin
self.setAttrNS(self.handle, self.NS_STATE, "valuemax", self._max);            // aaa:valuemax
self.setAttrNS(self.handle, self.NS_STATE, "valuenow", self._inp.value);      // aaa:valuenow

var lbl = self.findLabel();
if(lbl) {
self.setAttrNS(self.handle, self.NS_STATE, 'labelledby', lbl.id);     // aaa:labelledby
self.handle.id = "fd-slider-handle-" + inp.id;
/*@cc_on
/*@if(@_win32)
lbl.setAttribute("htmlFor", self.handle.id);
@else @*/
lbl.setAttribute("for", self.handle.id);
/*@end
@*/
};

if(document.getElementById("fd_slider_describedby")) {
self.setAttrNS(self.handle, self.NS_STATE, 'describedby', "fd_slider_describedby");     // aaa:describedby
};

self.events.redraw();
};

this.destroy = function() {
try {
self._callback = null;
fdSliderController.removeEvent(self.outerWrapper, "mouseover", self.events.onmouseover);
fdSliderController.removeEvent(self.outerWrapper, "mouseout",  self.events.onmouseout);
fdSliderController.removeEvent(self.outerWrapper, "mousedown", self.events.onmousedown);
fdSliderController.removeEvent(self.handle,       "keydown",   self.events.onkeydown);
fdSliderController.removeEvent(self.handle,       "keypress",  self.events.onkeypress);
fdSliderController.removeEvent(self.handle,       "focus",     self.events.onfocus);
fdSliderController.removeEvent(self.handle,       "blur",      self.events.onblur);
fdSliderController.removeEvent(self.handle,       "mousedown", self.events.onHmousedown);
fdSliderController.removeEvent(self.handle,       "mouseup",   self.events.onHmouseup);
fdSliderController.removeEvent(window,            "resize",    self.events.redraw);
if (window.addEventListener && !window.devicePixelRatio) window.removeEventListener('DOMMouseScroll', self.events.trackmousewheel, false);
else {
fdSliderController.removeEvent(document, "mousewheel", self.events.trackmousewheel);
fdSliderController.removeEvent(window,   "mousewheel", self.events.trackmousewheel);
};
} catch(err) {}

self.wrapper = self.bar = self.handle = self.outerWrapper = self._timer = null;
};

var self = this;
self.build();
};

fdSliderController = {
sliders: {},
uniqueid: 0,
forms: {},

addEvent: function(obj, type, fn) {
if( obj.attachEvent ) {
obj["e"+type+fn] = fn;
obj[type+fn] = function(){obj["e"+type+fn]( window.event );}
obj.attachEvent( "on"+type, obj[type+fn] );
} else { obj.addEventListener( type, fn, true ); }
},
removeEvent: function(obj, type, fn) {
if( obj.detachEvent ) {
try {
obj.detachEvent( "on"+type, obj[type+fn] );
obj[type+fn] = null;
} catch(err) { };
} else { obj.removeEventListener( type, fn, true ); }
},
onload: function(e) {
for(slider in fdSliderController.sliders) { fdSliderController.sliders[slider].resetHandlePosition(); }
},
joinNodeLists: function() {
if(!arguments.length) { return []; }
var nodeList = [];
for (var i = 0; i < arguments.length; i++) {
for (var j = 0, item; item = arguments[i][j]; j++) { nodeList[nodeList.length] = item; };
};
return nodeList;
},
construct: function( e ) {
var regExp_1 = /fd_range_([-]{0,1}[0-9]+){1}_([-]{0,1}[0-9]+){1}/;
var regExp_2 = /fd_callback_([a-zA-Z0-9_]+)/;
var regExp_3 = /fd_classname_([a-zA-Z0-9_\-]+)/;
var inputs   = fdSliderController.joinNodeLists(document.getElementsByTagName('input'), document.getElementsByTagName('select'));
var range, callback, classname, hide, tween, vertical;

for(var i = 0, inp; inp = inputs[i]; i++) {
if((inp.tagName.toLowerCase() == "input" && inp.type == "text" && inp.className && inp.className.search(regExp_1) != -1) || (inp.tagName.toLowerCase() == "select" && inp.className.search(/fd_slider/) != -1)) {
if(!inp.id) inp.id == "sldr" + fdSliderController.uniqueid++;
if(document.getElementById("fd-slider-"+inp.id)) continue;
if(inp.tagName.toLowerCase() == "select") {
range = [inp.options[0].value, inp.options[inp.options.length - 1].value];
hide = true;
} else {
range = inp.className.match(regExp_1);
range = [range[1], range[2]]
hide  = inp.className.search(/fd_hide_input/ig) != -1;
};
callback =  inp.className.search(regExp_2) != -1 ? inp.className.match(regExp_2)[1] : "";
classname = inp.className.search(regExp_3) != -1 ? inp.className.match(regExp_3)[1] : "";
tween = inp.className.search(/fd_tween/ig) != -1;
vertical = inp.className.search(/fd_vertical/ig) != -1;
fdSliderController.sliders[inp.id] = new fdSlider(inp, range, callback, classname, hide, tween, vertical);
};
};
},

deconstruct: function( e ) {
for(slider in fdSliderController.sliders) { fdSliderController.sliders[slider].destroy(); };
fdSliderController.sliders = null;
fdSliderController.removeEvent(window, "load",   fdSliderController.construct);
fdSliderController.removeEvent(window, "unload", fdSliderController.deconstruct);
/*@cc_on@*/
/*@if(@_win32)
fdSliderController.removeEvent(window, "load",   function() { setTimeout(fdSliderController.onload, 200) });
/*@end@*/
}
}
})();

fdSliderController.addEvent(window, "unload", fdSliderController.deconstruct);
fdSliderController.addEvent(window, "load",   fdSliderController.construct);
/*@cc_on@*/
/*@if(@_win32)
fdSliderController.addEvent(window, "load",   function() { setTimeout(fdSliderController.onload, 200) });
/*@end@*/



var gv = {
name: "jsgameviewer",
version: "1.0a",
length: 0,
getId: function(i){
if (i == undefined){
gv.length ++;
for(i=1;gv["GV"+i]!=null;i++)
;
}
return "GV"+i;
}
};

var WEIQI = 0;
var DAOQI = 1;

var CONFIG = {
baseDir: "/jsgameviewer/",
viewDir: "/jsgameviewer/view/",
gameType: WEIQI,
boardSize: 19,
playerInterval: 5,
observerInterval: 15,
container: null
};

var Class = {
create: function() {
return function() {
this.initialize.apply(this, arguments);
}
}
}

Object.extend = function(destination, source) {
for (var property in source) {
destination[property] = source[property];
}
return destination;
}

function clone(myObj){
if(typeof(myObj) != 'object') return myObj;
if(myObj == null) return myObj;

var myNewObj = new Object();

for(var i in myObj)
myNewObj[i] = clone(myObj[i]);

return myNewObj;
}

function notNull(obj){
return obj != undefined && obj != null && jQuery.trim(obj).length > 0;
}

function getId(x, y){
return x+"-"+y;
}

var GameController = Class.create();


var config = {
};





jQuery(document).ready(function(){
tb_init('a.thickbox, area.thickbox, input.thickbox');//pass where to apply thickbox
});

function tb_init(domChunk){
jQuery(domChunk).click(function(){
var t = this.title || this.name || null;
var a = this.href || this.alt;
var g = this.rel || false;
tb_show(t,a,g);
return false;
});
}

function tb_show(caption, url, imageGroup) {//function called when the user clicks on a thickbox link
try {
if (typeof document.body.style.maxHeight === "undefined") {//if IE 6
jQuery("body","html").css({height: "100%", width: "100%"});
jQuery("html").css("overflow","hidden");
if (document.getElementById("TB_HideSelect") === null) {//iframe to hide select elements in ie6
jQuery("body").append("<iframe id='TB_HideSelect'></iframe><div id='TB_overlay'></div><div id='TB_window'></div>");
jQuery("#TB_overlay").click(tb_remove);
}
}else{//all others
if(document.getElementById("TB_overlay") === null){
jQuery("body").append("<div id='TB_overlay'></div><div id='TB_window'></div>");
jQuery("#TB_overlay").click(tb_remove);
}
}

if(tb_detectMacXFF()){
jQuery("#TB_overlay").addClass("TB_overlayMacFFBGHack");//use png overlay so hide flash
}else{
jQuery("#TB_overlay").addClass("TB_overlayBG");//use background and opacity
}

if(caption===null){caption="";}

var baseURL;
if(url.indexOf("?")!==-1){ //ff there is a query string involved
baseURL = url.substr(0, url.indexOf("?"));
}else{
baseURL = url;
}


var queryString = url.replace(/^[^\?]+\??/,'');
var params = tb_parseQuery( queryString );

TB_WIDTH = (params['width']*1) + 30 || 630; //defaults to 630 if no paramaters were added to URL
TB_HEIGHT = (params['height']*1) + 40 || 440; //defaults to 440 if no paramaters were added to URL
ajaxContentW = TB_WIDTH - 30;
ajaxContentH = TB_HEIGHT - 45;

if(jQuery("#TB_window").css("display") != "block"){
if(params['modal'] != "true"){//ajax no modal
jQuery("#TB_window").append("<div id='TB_title'><div id='TB_ajaxWindowTitle'>"+caption+"</div><div id='TB_closeAjaxWindow'><a href='#' id='TB_closeWindowButton'>close</a> or Esc Key</div></div><div id='TB_ajaxContent' style='width:"+ajaxContentW+"px;height:"+ajaxContentH+"px'></div>");
}else{//ajax modal
jQuery("#TB_overlay").unbind();
jQuery("#TB_window").append("<div id='TB_ajaxContent' class='TB_modal' style='width:"+ajaxContentW+"px;height:"+ajaxContentH+"px;'></div>");
}
}else{//this means the window is already up, we are just loading new content via ajax
jQuery("#TB_ajaxContent")[0].style.width = ajaxContentW +"px";
jQuery("#TB_ajaxContent")[0].style.height = ajaxContentH +"px";
jQuery("#TB_ajaxContent")[0].scrollTop = 0;
jQuery("#TB_ajaxWindowTitle").html(caption);
}

jQuery("#TB_closeWindowButton").click(tb_remove);

jQuery("#TB_ajaxContent").html(jQuery('#' + params['inlineId']).html());
jQuery("#TB_window").unload(function () {
jQuery('#' + params['inlineId']).html( jQuery("#TB_ajaxContent").html() ); // move elements back when you're finished
});
tb_position();
jQuery("#TB_load").remove();
jQuery("#TB_window").css({display:"block"});

document.onkeyup = function(e){
if (e == null) { // ie
keycode = event.keyCode;
} else { // mozilla
keycode = e.which;
}
if(keycode == 27){ // close
tb_remove();
}
};
if (params["focus"] != null){
jQuery("#" + params["focus"]).focus();
}

} catch(e) {
}
}


function tb_remove() {
jQuery("#TB_imageOff").unbind("click");
jQuery("#TB_closeWindowButton").unbind("click");
jQuery("#TB_window").fadeOut("fast",function(){jQuery('#TB_window,#TB_overlay,#TB_HideSelect').trigger("unload").unbind().remove();});
jQuery("#TB_load").remove();
if (typeof document.body.style.maxHeight == "undefined") {//if IE 6
jQuery("body","html").css({height: "auto", width: "auto"});
jQuery("html").css("overflow","");
}
document.onkeydown = "";
document.onkeyup = "";
return false;
}

function tb_position() {
jQuery("#TB_window").css({marginLeft: '-' + parseInt((TB_WIDTH / 2),10) + 'px', width: TB_WIDTH + 'px'});
if ( !(jQuery.browser.msie && jQuery.browser.version < 7)) { // take away IE6
jQuery("#TB_window").css({marginTop: '-' + parseInt((TB_HEIGHT / 2),10) + 'px'});
}
}

function tb_parseQuery ( query ) {
var Params = {};
if ( ! query ) {return Params;}// return empty object
var Pairs = query.split(/[;&]/);
for ( var i = 0; i < Pairs.length; i++ ) {
var KeyVal = Pairs[i].split('=');
if ( ! KeyVal || KeyVal.length != 2 ) {continue;}
var key = unescape( KeyVal[0] );
var val = unescape( KeyVal[1] );
val = val.replace(/\+/g, ' ');
Params[key] = val;
}
return Params;
}

function tb_getPageSize(){
var de = document.documentElement;
var w = window.innerWidth || self.innerWidth || (de&&de.clientWidth) || document.body.clientWidth;
var h = window.innerHeight || self.innerHeight || (de&&de.clientHeight) || document.body.clientHeight;
arrayPageSize = [w,h];
return arrayPageSize;
}

function tb_detectMacXFF() {
var userAgent = navigator.userAgent.toLowerCase();
if (userAgent.indexOf('mac') != -1 && userAgent.indexOf('firefox')!=-1) {
return true;
}
}





var STONE_NONE  = 0;
var STONE_BLACK = 1;
var STONE_WHITE = 2;
var STONE_ERASE = 3;

var MODE_NORMAL = 0;
var MODE_EDIT   = 1;
var MODE_SCORE  = 2;

var NODE_EMPTY  = 0;
var NODE_MOVE   = 1;
var NODE_PASS   = 2;

var MARK_NONE       = 0;
var MARK_SQUARE     = 1;
var MARK_CIRCLE     = 2;
var MARK_TRIANGLE   = 3;
var MARK_CROSS      = 4;
var MARK_TEXT       = 5;
var MARK_NUMBER     = 6;
var MARK_TERR_BLACK = 7;
var MARK_TERR_WHITE = 8;
var MARK_STONE      = 9;

var MoveNumber = Class.create();
MoveNumber.prototype = {
initialize: function(val, depth){
this.val = val;
this.depth = 0;
if (depth != undefined && depth != null)
this.depth = depth;
}
}

var Point = Class.create();
Point.prototype = {
initialize: function(x,y,color,moveNumber,deleteFlag){
this.x = x;
this.y = y;
this.id = x + "-" + y;
this.color = 0;
if (color != undefined && color != null)
this.color = color;
this.moveNumber = null;
if (moveNumber != undefined && moveNumber != null)
this.moveNumber = moveNumber;
this.deleteFlag = false;
if (deleteFlag)
this.deleteFlag = true;
}
}

var Board = Class.create();
Object.extend(Board, Array);
Board.prototype = {
initialize: function(gameType, size){
this.gameType = gameType;
this.size = size;
this.reset();
},

isNeighbor: function(x1,y1,x2,y2){
if (this.gameType == DAOQI){
if (x1 == x2)
return y1 == (y2+1)%this.size || y1 == (y2-1+this.size)%this.size;
if (y1 == y2)
return x1 == (x2+1)%this.size || x1 == (x2-1+this.size)%this.size;
return false;
} else {
if (x1 == x2)
return y1 == y2+1 || y1 == y2-1;
if (y1 == y2)
return x1 == x2+1 || x1 == x2-1;
return false;
}
},

normalize: function(index){
if (index < 0)
return index + this.size;
if (index >= this.size)
return index - this.size;
return index;
},

reset: function(){
for(i=0; i<this.size; i++) {
this[i] = new Array(this.size);
for(j=0; j<this.size; j++)
this[i][j] = 0;
}
},

copyFrom: function(b){
for(var i=0; i<this.size; i++){
for(var j=0; j<this.size; j++){
this[i][j] = b[i][j];
}
}
},

getDeadGroup: function(x, y){
if (this.gameType == DAOQI){
x = this.normalize(x);
y = this.normalize(y);
} else {
if (x < 0 || x>=this.size || y<0 || y>= this.size)
return null;
}

if (this[x][y] == 0)
return null;

if (this.gameType == DAOQI){
if (this[this.normalize(x-1)][y] == 0 ||
this[this.normalize(x+1)][y] == 0 ||
this[x][this.normalize(y-1)] == 0 ||
this[x][this.normalize(y+1)] == 0
)
return null;
} else {
if ((x > 0 && this[x-1][y] == 0) ||
(x < this.size-1 && this[x+1][y] == 0) ||
(y > 0 && this[x][y-1] == 0) ||
(y < this.size-1 && this[x][y+1] == 0)
)
return null;
}

var group = new Array();
group.color = this[x][y];
group.push([x,y]);
group[x+"-"+y] = true;

if (this.gameType == DAOQI){
if (this.expandDeadGroup(group, x-1, y))
return null;
if (this.expandDeadGroup(group, x+1, y))
return null;
if (this.expandDeadGroup(group, x, y-1))
return null;
if (this.expandDeadGroup(group, x, y+1))
return null;
} else {
if (x > 0 && this.expandDeadGroup(group, x-1, y))
return null;
if (x < this.size-1 && this.expandDeadGroup(group, x+1, y))
return null;
if (y > 0 && this.expandDeadGroup(group, x, y-1))
return null;
if (y < this.size-1 && this.expandDeadGroup(group, x, y+1))
return null;
}
return group;
},

expandDeadGroup: function(group, x, y){
if (this.gameType == DAOQI){
x = this.normalize(x);
y = this.normalize(y);
}
if (group[x+"-"+y] != null) // already added to the group
return false;
if (this[x][y] != group.color)
return false;

if (this.gameType == DAOQI){
if (this[this.normalize(x-1)][y] == 0 ||
this[this.normalize(x+1)][y] == 0 ||
this[x][this.normalize(y-1)] == 0 ||
this[x][this.normalize(y+1)] == 0
)
return true;
} else {
if ((x > 0 && this[x-1][y] == 0) ||
(x < this.size-1 && this[x+1][y] == 0) ||
(y > 0 && this[x][y-1] == 0) ||
(y < this.size-1 && this[x][y+1] == 0)
)
return true;
}

group.push([x,y]);
group[x+"-"+y] = true;

if (this.gameType == DAOQI){
if (this.expandDeadGroup(group, x-1, y))
return true;
if (this.expandDeadGroup(group, x+1, y))
return true;
if (this.expandDeadGroup(group, x, y-1))
return true;
if (this.expandDeadGroup(group, x, y+1))
return true;
} else {
if (x > 0 && this.expandDeadGroup(group, x-1, y))
return true;
if (x < this.size-1 && this.expandDeadGroup(group, x+1, y))
return true;
if (y > 0 && this.expandDeadGroup(group, x, y-1))
return true;
if (y < this.size-1 && this.expandDeadGroup(group, x, y+1))
return true;
}

return false;
}
}

var Node = Class.create();
Node.prototype = {
initialize: function(parent){
this.type = NODE_EMPTY;
this.parent = parent;
this.children = new Array();
this.moveNumber = 0;
this.depth = 0;
this.points = new Array();
this.processed = false;
this.blackPrisoners = 0;
this.blackPrisonerPoints = [];
this.whitePrisoners = 0;
this.whitePrisonerPoints = [];
},

isRoot: function(){
return this.parent == null;
},

hasChildren: function(){
return this.children.length > 0;
},

firstChild: function(){
if (this.children.length > 0)
return this.children[0];
return null;
},

isOnBranch: function(){
return this.depth > 1;
},

isDummyNode: function(){
return this.type == NODE_EMPTY && !this.isRoot() && this.comment == null && this.marks == null;
},

hasComment: function(){
return this.comment != undefined && this.comment !=null && jQuery.trim(this.comment).length > 0;
},

hasBranches: function(){
return this.children.length > 1;
},

toString: function(){
var indent = "";
var typeName = "EMPTY";
if (this.type == NODE_MOVE)
typeName = "MOVE";
else if (this.type == NODE_PASS)
typeName = "PASS";
var str = indent+"Node("+typeName+", "+this.moveNumber;
if (this.type == NODE_MOVE || this.type == NODE_PASS)
str += ", "+(this.color == STONE_BLACK?"black":"white");
if (this.type == NODE_MOVE)
str += ", "+this.x+","+this.y;
str += ")";
return str;
}
}

var Game = Class.create();
Game.prototype = {
initialize: function(gameType){
this.type = gameType;
this.charset = "";
this.name = "";
this.boardSize = 19;
this.rule = "";
this.handicap = 0;
this.komi = 0;
this.blackName = "";
this.blackRank = "";
this.whiteName = "";
this.whiteRank = "";
this.date = "";
this.place = "";
this.result = "";
this._moves = 0;
this._firstPlayer = STONE_NONE;
this.rootNode = new Node(null);
},

isFinished: function(){
return this.result && this.result.length > 0;
},

getMoves: function(){
if (this._moves == 0){
var node = this.rootNode;
while(node.hasChildren()) {
node = node.children[0];
if (node.moveNumber != undefined && node.moveNumber != null)
this._moves = node.moveNumber;
}
}
return this._moves;
},

getFirstPlayer: function(){
if (this._firstPlayer == STONE_NONE){
var node = this.rootNode;
while(this._firstPlayer == STONE_NONE && node.hasChildren()){
node = node.children[0];
if(node.type == NODE_MOVE || node.type == NODE_PASS)
this._firstPlayer = node.color;
}
}
return this._firstPlayer;
},

getId: function(){
var id = this.url;
return id;
},

getTitle: function(){
var title = "";
if (this.name)
title += this.name + ": ";
if (this.whiteName)
title += this.whiteName;
else
title += "Unknown Player";
title += "(W) - ";
if (c.game.blackName)
title += c.game.blackName;
else
title += "Unknown Player";
title += "(B)";
if (this.result)
title += "   " + this.result;
if (this.date)
title += "   " + this.date;
if (this.place)
title += "   " + this.place;
return title;
},

getNextPlayer: function(){
var color = STONE_NONE;
var node = this.rootNode;
while(node.hasChildren()){
if (node.color == STONE_BLACK || node.color == STONE_WHITE){
color = node.color;
}
var child = node.children[0];
if (child.temp){
break;
}
node = child;
}
if (node.color == STONE_BLACK || node.color == STONE_WHITE){
color = node.color;
}
var nextPlayerColor = color == STONE_BLACK? STONE_WHITE:STONE_BLACK;
return nextPlayerColor;
}
}

var GameState = Class.create();
GameState.prototype = {
initialize: function(game){
this.game = game;
this.board = new Board(game.type, game.boardSize);
this.currentNode = game.rootNode;
this.rootNode = this.currentNode;
this.blackPrisoners = 0;
this.blackPrisonerPoints = [];
this.whitePrisoners = 0;
this.whitePrisonerPoints = [];
this.moveNumbers = new Object();
this.tempMoves = new Array();
this.processCurrentNode(); // process the root node
},

isFirst: function(){
return this.currentNode.isRoot();
},

isLast: function(){
return !this.currentNode.hasChildren();
},

isOnBranch: function(){
return this.currentNode.isOnBranch();
},

getNextPlayer: function(){
var node = this.currentNode;
var color = node.color;
while(color != STONE_BLACK && color != STONE_WHITE && !node.isRoot()){
node = node.parent;
color = node.color;
}
if (color == STONE_BLACK)
color = STONE_WHITE;
else if (color == STONE_WHITE)
color = STONE_BLACK;
else {
node = this.currentNode;
while(color != STONE_BLACK && color != STONE_WHITE && node.hasChildren()){
node = node.children[0];
color = node.color;
}
}
if (!color || color == STONE_NONE)
color = STONE_BLACK;
return color;
},

getMoveNumber: function(x,y){
var m = this.moveNumbers[getId(x,y)];
if (m instanceof Number)
return m;
if (m != undefined && m != null)
return m.val;
return 0;
},

handleDeadGroup: function(group){
var gs = this;
if (group != null){
if (group.color == STONE_BLACK) {
gs.currentNode.blackPrisoners += group.length;
gs.blackPrisoners += group.length;
} else {
gs.currentNode.whitePrisoners += group.length;
gs.whitePrisoners += group.length;
}
jQuery.each(group, function(i,item){
var x = item[0], y = item[1], moveNumber = gs.moveNumbers[getId(x,y)];
var p = [x, y, group.color, moveNumber, gs.currentNode.moveNumber];
if (group.color == STONE_BLACK){
gs.currentNode.blackPrisonerPoints.push(p);
gs.blackPrisonerPoints.push(p);
} else {
gs.currentNode.whitePrisonerPoints.push(p);
gs.whitePrisonerPoints.push(p);
}
gs.board[x][y] = 0;
var point = new Point(x, y, group.color, moveNumber, true);
gs.currentNode.points.push(point);
delete gs.moveNumbers[getId(x, y)];
});
}
},

processCurrentNode: function(){
var gs = this;
var board = this.board;
var node = this.currentNode;
if (node.processed){
for(var i=0; i<node.points.length; i++){
var point = node.points[i];
if (point.deleteFlag)
board[point.x][point.y] = 0;
else
board[point.x][point.y] = point.color;
this.moveNumbers[getId(point.x,point.y)] = point.moveNumber;
}
if (node.blackPrisoners > 0) {
this.blackPrisoners += node.blackPrisoners;
this.blackPrisonerPoints = this.blackPrisonerPoints.concat(node.blackPrisonerPoints);
}
if (node.whitePrisoners > 0) {
this.whitePrisoners += node.whitePrisoners;
this.whitePrisonerPoints = this.whitePrisonerPoints.concat(node.whitePrisonerPoints);
}
return;
}
node.processed = true;
switch(node.type){
case NODE_EMPTY: // add/remove stones only
jQuery.each(node.points, function(i,point){
var x = point.x, y = point.y, color = point.color;
if (x < 0 || x >= board.size || y < 0 || y >= board.size)
return;
switch(color){
case STONE_ERASE:
point.color = board[x][y];
point.deleteFlag = true;
var p = [x,y,point.color,gs.moveNumbers[getId(x,y)],node.moveNumber];
if (point.color == STONE_BLACK){
node.blackPrisoners ++;
gs.blackPrisoners ++;
node.blackPrisonerPoints.push(p);
gs.blackPrisonerPoints.push(p);
} else if (point.color == STONE_WHITE){
node.whitePrisoners ++;
gs.whitePrisoners ++;
node.whitePrisonerPoints.push(p);
gs.whitePrisonerPoints.push(p);
}
board[x][y] = 0;
break;
case STONE_BLACK:
case STONE_WHITE:
board[x][y] = color;
break;
}
});
break;
case NODE_MOVE: // add new move and compute all neighbors' state
var x = node.x, y = node.y, color = node.color, size = this.game.boardSize;
if (x < 0 || x >= size || y < 0 || y >= size)
throw "Invalid point: ("+x+","+y+")";
board[x][y] = color;
var moveNumber = new MoveNumber(node.moveNumber,node.depth);
gs.moveNumbers[getId(x,y)] = moveNumber;
var point = new Point(x,y,color,moveNumber);
node.points.push(point);
var opponentColor = (color==STONE_BLACK)?STONE_WHITE:STONE_BLACK;
if (gs.game.type == DAOQI){
var x1 = board.normalize(x-1);
var y1 = y;
if (board[x1][y1] == opponentColor)
this.handleDeadGroup(board.getDeadGroup(x1, y1));
x1 = board.normalize(x+1);
y1 = y;
if (board[x1][y1] == opponentColor)
this.handleDeadGroup(board.getDeadGroup(x1, y1));
x1 = x;
y1 = board.normalize(y-1);
if (board[x1][y1] == opponentColor)
this.handleDeadGroup(board.getDeadGroup(x1, y1));
x1 = x;
y1 = board.normalize(y+1);
if (board[x1][y1] == opponentColor)
this.handleDeadGroup(board.getDeadGroup(x1, y1));
} else {
if (x > 0){
var x1 = x-1, y1 = y;
if (board[x1][y1] == opponentColor)
this.handleDeadGroup(board.getDeadGroup(x1, y1));
}
if (x < board.size-1){
var x1 = x+1, y1 = y;
if (board[x1][y1] == opponentColor)
this.handleDeadGroup(board.getDeadGroup(x1, y1));
}
if (y > 0){
var x1 = x, y1 = y-1;
if (board[x1][y1] == opponentColor)
this.handleDeadGroup(board.getDeadGroup(x1, y1));
}
if (y < board.size-1){
var x1 = x, y1 = y+1;
if (board[x1][y1] == opponentColor)
this.handleDeadGroup(board.getDeadGroup(x1, y1));
}
}
this.handleDeadGroup(board.getDeadGroup(x, y));
break;
case NODE_PASS: // nothing has to be done
break;
}

if (!node.hasChildren()){
if (!node.isOnBranch() && this.last == null){
gs.last = new Object();
gs.last.node = node;
gs.last.board = clone(board);
gs.last.moveNumbers = clone(this.moveNumbers);
gs.last.blackPrisoners = this.blackPrisoners;
gs.last.blackPrisonerPoints = clone(this.blackPrisonerPoints);
gs.last.whitePrisoners = this.whitePrisoners;
gs.last.whitePrisonerPoints = clone(this.whitePrisonerPoints);
}
}
},

play: function(x,y){
var board = this.board;
if (x < 0 || x >= board.size || y < 0 || y >= board.size)
return false;
if (board[x][y] != 0)
return false;

var c = this.getNextPlayer();
var opponentColor = (c==STONE_BLACK)?STONE_WHITE:STONE_BLACK;
board[x][y] = c;
var killed = 0;
if (x > 0 && board[x-1][y]==opponentColor){
var group = board.getDeadGroup(x-1,y);
if (group != null){
killed = group.length;
}
}
if (killed < 2 && x < board.size-1 && board[x+1][y]==opponentColor){
var group = board.getDeadGroup(x+1,y);
if (group != null){
killed = +group.length;
}
}
if (killed < 2 && y > 0 && board[x][y-1]==opponentColor){
var group = board.getDeadGroup(x,y-1);
if (group != null){
killed = +group.length;
}
}
if (killed < 2 && y < board.size-1 && board[x][y+1]==opponentColor){
var group = board.getDeadGroup(x,y+1);
if (group != null){
killed = +group.length;
}
}
var isValidMove = true;
if (killed == 1){
if (this.currentNode.type == NODE_MOVE){
if (board.isNeighbor(x,y,this.currentNode.x,this.currentNode.y)
&& (this.currentNode.blackPrisoners == 1 || this.currentNode.whitePrisoners == 1)
)
isValidMove = false;
}
} else if (killed == 0){
var group = board.getDeadGroup(x,y);
if (group != null && group.length > 0)
isValidMove = false;
}
if (!isValidMove){
board[x][y] = 0;
return false;
}

var newNode = new Node(this.currentNode);
newNode.temp = true;
newNode.type = NODE_MOVE;
newNode.x = x;
newNode.y = y;
newNode.color = c;
newNode.moveNumber = this.currentNode.moveNumber+1;
if (this.currentNode.children.length == 0){
newNode.depth = this.currentNode.depth;
} else {
newNode.depth = this.currentNode.depth + 1;
}
if (!newNode.isOnBranch()){
this.last = null;
}
this.currentNode.children.push(newNode);
this.tempMoves.push([x,y]);
return this.goToBranch(this.currentNode.children.length - 1);
},

canRemove: function(){
if (this.currentNode.temp)
return true;
else
return false;
},

remove: function(){
if (this.canRemove()){
var node = this.currentNode;
var parent = node.parent;
var i = 0;
for(i=0; i<parent.children.length; i++){
if (parent.children[i] == node)
break;
}
this.back();
parent.children.splice(i,1);
if (!node.isOnBranch()){
this.last = null;
}
}
},

back: function(){
if (this.currentNode.isRoot())
return false;
for(var i=0; i<this.currentNode.points.length; i++){
var point = this.currentNode.points[i];
if (point.deleteFlag){
this.board[point.x][point.y] = point.color;
this.moveNumbers[getId(point.x,point.y)] = point.moveNumber;
} else {
this.board[point.x][point.y] = STONE_NONE;
delete this.moveNumbers[getId(point.x,point.y)];
}
}
if (this.currentNode.blackPrisoners > 0) {
this.blackPrisoners -= this.currentNode.blackPrisoners;
for(var i=0; i<this.currentNode.blackPrisoners; i++){
if (this.blackPrisonerPoints.length > 0)
this.blackPrisonerPoints.pop();
}
}
if (this.currentNode.whitePrisoners > 0) {
this.whitePrisoners -= this.currentNode.whitePrisoners;
for(var i=0; i<this.currentNode.whitePrisoners; i++){
if (this.whitePrisonerPoints.length > 0)
this.whitePrisonerPoints.pop();
}
}
this.currentNode = this.currentNode.parent;
return true;
},

backAll: function(){
this.currentNode = this.rootNode;
this.board.reset();
this.moveNumbers = new Object();
this.blackPrisoners = 0;
this.blackPrisonerPoints = [];
this.whitePrisoners = 0;
this.whitePrisonerPoints = [];
var board = this.board;
jQuery.each(this.currentNode.points, function(i,point){
board[point.x][point.y] = point.color;
});
},

forward: function(){
if (!this.currentNode.hasChildren())
return false;
this.currentNode = this.currentNode.children[0];
this.processCurrentNode();
return true;
},

forwardAll: function(){
if (this.isOnBranch() || this.last == null){
while(this.forward())
;
} else {
this.currentNode = this.last.node;
this.board.copyFrom(this.last.board);
this.moveNumbers = clone(this.last.moveNumbers);
this.blackPrisoners = this.last.blackPrisoners;
this.blackPrisonerPoints = clone(this.last.blackPrisonerPoints);
this.whitePrisoners = this.last.whitePrisoners;
this.whitePrisonerPoints = clone(this.last.whitePrisonerPoints);
}
},

goToBranch: function(n){
if (!this.currentNode.hasChildren())
return false;
if (this.currentNode.children.length <= n)
return false;
this.currentNode = this.currentNode.children[n];
this.processCurrentNode();
return true;
}
}

var GameHistory = new Array();
GameHistory.max = 30;
GameHistory.save = function(gameState){
var id = gameState.game.getId();
var matched = null;
for(var i=0; i<this.length; i++){
if (this[i] == id){
matched = i;
break;
}
}
if (matched != null && matched > 0){
for(var i=0; i<matched-1; i++){
this[i+1] = this[i];
}
} else {
this.unshift(id); // insert to the beginning
if (this.length > this.max){ // remove last
var last = this.pop();
delete this[last];
}
}
this[0] = id;
this[id] = gameState;
}



var CHAR_A_CODE = 97;

var STATE_VAR_BEGIN = 0;
var STATE_NODE      = 1;
var STATE_VAR_END   = 2;

var PROPERTY_MOVE_BLACK = 0;
var PROPERTY_MOVE_WHITE = 1;
var PROPERTY_EDIT_BLACK = 2;
var PROPERTY_EDIT_WHITE = 3;
var PROPERTY_EDIT_ERASE = 4;
var PROPERTY_COMMENT    = 5;
var PROPERTY_EDIT_MARK  = 6;

var MARK_NONE       = 0;
var MARK_CROSS      = 1;
var MARK_TRIANGLE   = 2;
var MARK_SQUARE     = 3;
var MARK_CIRCLE     = 4;
var MARK_TEXT       = 5;
var MARK_TERR_BLACK = 6;
var MARK_TERR_WHITE = 7;

var GM_DAOQI        = "10";

var SGFParser = Class.create();
SGFParser.prototype = {
initialize: function(gameType){
this.gameType = gameType;
},

minPos: function(n1, n2, n3) {
var min;

if (n1 != -1)
min = n1;
else if (n2 != -1)
min = n2;
else
min = n3;

if (n1 < min && n1 != -1)
min = n1;

if (n2 < min && n2 != -1)
min = n2;

if (n3 < min && n3 != -1)
min = n3;

return min;
},

nextNonSpace: function(input, i) {
while(true){
c = input.charAt(i);
if (c == ' ' || c == '\t' || c == '\n' || c == '\r')
i++;
else
break;
}

return i;
},

createErrorMsg: function(input, pos, e){
var s = "SGFParser: ";
if (e != undefined && e != null)
s += e;
s += "\n";
if (pos > 0)
s = input.substring(0,pos-1);
s += "{PARSING FAILED HERE}";
if (pos < input.length)
s += input.substring(pos);
return s;
},

parseProperty: function(input, prop) {
var pos;
var inputLength = input.length;
var result = "";

pos = input.indexOf(prop + "[");
if (pos == -1)
return result;
pos += 2;

if (input.charAt(pos) != '[') {
throw this.createErrorMsg(input, pos);
}

while (input.charAt(++pos) != ']' && pos < inputLength)
result += input.charAt(pos);

if (pos > inputLength) {
throw this.createErrorMsg(input, pos);
}

return result;
},

initGame: function(input) {
var game = new Game(this.gameType);

tmp = this.parseProperty(input, "GM");
if (tmp.length > 0 && GM_DAOQI == tmp)
game.type = DAOQI;

var tmp = this.parseProperty(input, "SZ");
if (tmp.length > 0) {
try {
game.boardSize = parseInt(tmp);
} catch(e){
throw this.createErrorMsg(input, input.indexOf("SZ["));
}
}

tmp = this.parseProperty(input, "GN");
if (tmp.length > 0)
game.name = tmp;

tmp = this.parseProperty(input, "CA");
if (tmp.length > 0)
game.charset = tmp;

tmp = this.parseProperty(input, "PW");
if (tmp.length > 0)
game.whiteName = tmp;

tmp = this.parseProperty(input, "WR");
if (tmp.length > 0)
game.whiteRank = tmp;

tmp = this.parseProperty(input, "PB");
if (tmp.length > 0)
game.blackName = tmp;

tmp = this.parseProperty(input, "BR");
if (tmp.length > 0)
game.blackRank = tmp;

tmp = this.parseProperty(input, "RU");
if (tmp.length > 0)
game.rule = tmp;

tmp = this.parseProperty(input, "KM");
if (tmp.length > 0) {
try {
game.komi = parseFloat(tmp);
} catch(e){
throw this.createErrorMsg(input, input.indexOf("KM["));
}
}

tmp = this.parseProperty(input, "HA");
if (tmp.length > 0) {
try {
game.handicap = parseInt(tmp);
} catch(e){
throw this.createErrorMsg(input, input.indexOf("HA["));
}
}

tmp = this.parseProperty(input, "RE");
if (tmp.length > 0)
game.result = tmp;

tmp = this.parseProperty(input, "DT");
if (tmp.length > 0)
game.date = tmp;

tmp = this.parseProperty(input, "PC");
if (tmp.length > 0)
game.place = tmp;

return game;
},

parse: function(input){
var pos = 0;
try {
input = input.replace(/&/g,"&amp;");
input = input.replace(/</g,"&lt;");
var game = this.initGame(input);
var inputLength = input.length;
var state = STATE_VAR_BEGIN;
var pos = 0;
var posVarBegin = 0;
var posVarEnd = 0;
var posNode = 0;
var pointer = 0;
var isRoot = true;
var moveNumber = 0;
var x = -1;
var y = -1;
var color = STONE_NONE;
var setup = false;
var comment = "";
var markType = MARK_NONE;
var markText = "";
var currentNode = game.rootNode;
var nodeStack = new Array();

do {
posVarBegin = input.indexOf('(', pointer);
posVarEnd = input.indexOf(')', pointer);
posNode = input.indexOf(';', pointer);

pos = this.minPos(posVarBegin, posVarEnd, posNode);


if (state == STATE_NODE && pos == posVarEnd)
state = STATE_VAR_END;

if (state == STATE_NODE && pos == posVarBegin)
state = STATE_VAR_BEGIN;

else if (state == STATE_VAR_BEGIN && pos == posNode)
state = STATE_NODE;

else if (state == STATE_VAR_END && pos == posVarBegin)
state = STATE_VAR_BEGIN;

switch (state) {
case STATE_VAR_BEGIN:
if (pos != posVarBegin)
throw this.createErrorMsg(input, pos);

nodeStack.push(currentNode);

pointer = pos + 1;
break; //}}}
case STATE_VAR_END:
if (pos != posVarEnd)
throw this.createErrorMsg(input, pos);

currentNode = nodeStack.pop();
moveNumber = currentNode.moveNumber;

pointer = pos + 1;
break; //}}}
case STATE_NODE:
if (pos != posNode)
throw this.createErrorMsg(input, pos);

if (isRoot) {
isRoot = false;
} else {
if (currentNode.isDummyNode() && currentNode.parent != null){
currentNode.parent.children.pop();
currentNode = currentNode.parent;
}
var newNode = new Node(currentNode);
newNode.moveNumber = moveNumber;
if (nodeStack.length > 0)
newNode.depth = nodeStack[nodeStack.length - 1].depth + 1;
currentNode.children.push(newNode);
currentNode = newNode;
}
var prop;
pos++;
do {
var tmppos = 0;
pos = this.nextNonSpace(input, pos);

if (input.charAt(pos) == 'B' && input.charAt(tmppos = this.nextNonSpace(input, pos + 1)) == '[') {
prop = PROPERTY_MOVE_BLACK;
pos = tmppos;
color = STONE_BLACK;
}
else if (input.charAt(pos) == 'W' && input.charAt(tmppos = this.nextNonSpace(input, pos + 1)) == '[') {
prop = PROPERTY_MOVE_WHITE;
pos = tmppos;
color = STONE_WHITE;
}
else if (input.charAt(pos) == 'A' && input.charAt(pos + 1) == 'B' &&
input.charAt(tmppos = this.nextNonSpace(input, pos + 2)) == '[') {
prop = PROPERTY_EDIT_BLACK;
pos = tmppos;
setup = true;
color = STONE_BLACK;
}
else if (input.charAt(pos) == 'A' && input.charAt(pos + 1) == 'W' &&
input.charAt(tmppos = this.nextNonSpace(input, pos + 2)) == '[') {
prop = PROPERTY_EDIT_WHITE;
pos = tmppos;
setup = true;
color = STONE_WHITE;
}
else if (input.charAt(pos) == 'A' && input.charAt(pos + 1) == 'E' &&
input.charAt(tmppos = this.nextNonSpace(input, pos + 2)) == '[') {
prop = PROPERTY_EDIT_ERASE;
pos = tmppos;
setup = true;
color = STONE_ERASE;
}
else if (input.charAt(pos) == 'T' && input.charAt(pos + 1) == 'R' &&
input.charAt(tmppos = this.nextNonSpace(input, pos + 2)) == '[') {
prop = PROPERTY_EDIT_MARK;
markType = MARK_TRIANGLE;
pos = tmppos;
}
else if (input.charAt(pos) == 'C' && input.charAt(pos + 1) == 'R' &&
input.charAt(tmppos = this.nextNonSpace(input, pos + 2)) == '[') {
prop = PROPERTY_EDIT_MARK;
markType = MARK_CIRCLE;
pos = tmppos;
}
else if (input.charAt(pos) == 'S' && input.charAt(pos + 1) == 'Q' &&
input.charAt(tmppos = this.nextNonSpace(input, pos + 2)) == '[') {
prop = PROPERTY_EDIT_MARK;
markType = MARK_SQUARE;
pos = tmppos;
}
else if (input.charAt(pos) == 'M' && input.charAt(pos + 1) == 'A' &&
input.charAt(tmppos = this.nextNonSpace(input, pos + 2)) == '[') {
prop = PROPERTY_EDIT_MARK;
markType = MARK_CROSS;
pos = tmppos;
}
else if (input.charAt(pos) == 'L' && input.charAt(pos + 1) == 'B' &&
input.charAt(tmppos = this.nextNonSpace(input, pos + 2)) == '[') {
prop = PROPERTY_EDIT_MARK;
markType = MARK_TEXT;
pos = tmppos;
oldLabel = false;
}
else if (input.charAt(pos) == 'C' && input.charAt(tmppos = this.nextNonSpace(input, pos + 1)) == '[') {
prop = PROPERTY_COMMENT;
pos = tmppos;
}
else if (input.charAt(pos) == 'T' && input.charAt(pos + 1) == 'B' &&
input.charAt(tmppos = this.nextNonSpace(input, pos + 2)) == '[') {
prop = PROPERTY_EDIT_MARK;
markType = MARK_TERR_BLACK;
pos = tmppos;
color = STONE_BLACK;
}
else if (input.charAt(pos) == 'T' && input.charAt(pos + 1) == 'W' &&
input.charAt(tmppos = this.nextNonSpace(input, pos + 2)) == '[') {
prop = PROPERTY_EDIT_MARK;
markType = MARK_TERR_WHITE;
pos = tmppos;
color = STONE_WHITE;
}
else if (input.charAt(pos) == ';' || input.charAt(pos) == '(' || input.charAt(pos) == ')') {
pos = this.nextNonSpace(input, pos);

continue;
}
else {
var tmp = input.indexOf("]", pos) + 1;
if (tmp <= 0) {
pointer = pos + 1;
break;
}
pos = tmp;
pos = this.nextNonSpace(input, pos);

continue;
} //}}}

do {
if (input.charAt(pos) != '[')
throw this.createErrorMsg(input, pos);

if (input.charAt(pos + 1) == ']') {
if (prop == PROPERTY_MOVE_BLACK || prop == PROPERTY_MOVE_WHITE) {
currentNode.type = NODE_PASS;
currentNode.color = color;
currentNode.moveNumber = ++moveNumber;
}
pos += 2;
continue;
}

switch (prop) {
case PROPERTY_MOVE_BLACK:
case PROPERTY_MOVE_WHITE:
x = input.charCodeAt(pos + 1) - CHAR_A_CODE;
y = input.charCodeAt(pos + 2) - CHAR_A_CODE;

currentNode.type = NODE_MOVE;
if (x >= 19 || y >= 19)
currentNode.type = NODE_PASS;

currentNode.color = color;
currentNode.x = x;
currentNode.y = y;
currentNode.moveNumber = ++moveNumber;

pos += 4;
break;

case PROPERTY_EDIT_BLACK:
case PROPERTY_EDIT_WHITE:
case PROPERTY_EDIT_ERASE:
x = input.charCodeAt(pos + 1) - CHAR_A_CODE;
y = input.charCodeAt(pos + 2) - CHAR_A_CODE;
currentNode.points.push(new Point(x, y, color));

pos += 4;
break; //}}}

case PROPERTY_COMMENT:
if (currentNode.comment == null)
currentNode.comment = "";

while (input.charAt(++pos) != ']' || (input.charAt(pos - 1) == '\\' && input.charAt(pos) == ']')) {
if (!(input.charAt(pos) == '\\' && input.charAt(pos + 1) == ']') &&
!(input.charAt(pos) == '\\' && input.charAt(pos + 1) == '[') &&
!(input.charAt(pos) == '\\' && input.charAt(pos + 1) == ')') &&
!(input.charAt(pos) == '\\' && input.charAt(pos + 1) == '('))
currentNode.comment += input.charAt(pos);

if (pos > inputLength)
throw this.createErrorMsg(input, inputLength);
}

pos++;
break; //}}}

case PROPERTY_EDIT_MARK:
while (input.charAt(pos) == '[' && pos < inputLength) {
x = input.charCodeAt(pos + 1) - CHAR_A_CODE;
y = input.charCodeAt(pos + 2) - CHAR_A_CODE;
pos += 3;
markText = "";

if (markType == MARK_TEXT) {
if (input.charAt(pos) != ':')
throw this.createErrorMsg(input, pos);

while (input.charAt(++pos) != ']' && pos < inputLength)
markText += input.charAt(pos);

try {
var n = parseInt(markText);
markType = MARK_TEXT;
} catch (e) {
markType = MARK_TEXT;
}
}

if (currentNode.marks == null)
currentNode.marks = new Array();
currentNode.marks.push([x, y, markType, markText]);

pos++;
pos = this.nextNonSpace(input, pos);
}
break; //}}}
}

pos = this.nextNonSpace(input, pos);

} while (setup && input.charAt(pos) == '['); //}}}

pos = this.nextNonSpace(input, pos);

} while (input.charAt(pos) != ';' && input.charAt(pos) != '(' && input.charAt(pos) != ')' && pos < inputLength);

pos = this.nextNonSpace(input, pos);

pointer = pos;
break; //}}}

default:
throw this.createErrorMsg(input, pointer);
}

} while(pointer < inputLength && pos >= 0);

if (currentNode.isDummyNode() && currentNode.parent != null){
currentNode.parent.children.pop();
}
return game;
} catch(e) {
throw this.createErrorMsg(input,pos,e);
}
}
}


Object.extend(CONFIG, {
gridSize:21,
fastMode:10,
showMoveNumber:false,
activeBackground: "#EECD7A",
inactiveBackground: "#CCAB69",
boardColor:"#EECD7A",
gridSizeWQ:21,
gridSizeDQ:19,
boardColorDQ:"#CCAB69",
vbw:3,
boardSizeDQ:25,
rightPaneHeight:446,
rightPaneHeightDQ:522
});

var LABELS = ['A','B','C','D','E','F','G','H','J','K','L','M','N','O','P','Q','R','S','T'];
var BRANCHES = ['A','B','C','D','E','F','G','H','I','J'];
var WEIQI_TEMPLATE = null;
var DAOQI_TEMPLATE = null;

Object.extend(GameController.prototype, {
destroyView: function(){
jQuery("#"+this.id).remove();
},

initView: function(){
var c = this;
if (c.initialized())
return c;
var conf = c.config;
conf.x0 = conf.vbw;
conf.y0 = conf.vbw;
var s = "";
if (conf.gameType == DAOQI){
conf.gridSize = conf.gridSizeDQ;
if (DAOQI_TEMPLATE == null){
jQuery.ajax({
async: false,
dataType: "application/xml",
url: CONFIG.viewDir+"templates/daoqi.html",
success: function(response){
DAOQI_TEMPLATE = response;
}
});
}
s = DAOQI_TEMPLATE;
c.rightPaneHeight = conf.rightPaneHeightDQ;
} else {
conf.gridSize = conf.gridSizeWQ;
if (WEIQI_TEMPLATE == null){
jQuery.ajax({
async: false,
dataType: "application/xml",
url: CONFIG.viewDir+"templates/weiqi.html",
success: function(response){
WEIQI_TEMPLATE = response;
}
});
}
s = WEIQI_TEMPLATE;
c.rightPaneHeight = conf.rightPaneHeight;
}
if (c.id != 'GV1')
s = s.replace(/GV1/g, c.id);
if (conf.container == null) {
jQuery("#"+c.id).replaceWith(s);
} else {
jQuery("#"+conf.container).empty().append(s);
}
fdSliderController.construct();
jQuery("#"+c.id+"_boardFascade").mousemove(function(e){
c.registerKeyListener();
var arr = c.eventToXY(e);
jQuery("#"+c.id+"_pointLabel").empty().append(c.xyToLabel(arr[0],arr[1]));
}).mouseout(function(e){
jQuery("#"+c.id+"_pointLabel").empty();
}).mousedown(function(e){
var arr = c.eventToXY(e);
c.fromX = arr[0];
c.fromY = arr[1];
if (e.ctrlKey && e.shiftKey){
c.sendMove_(arr[0], arr[1]);
} else if (e.ctrlKey || c.config.gameType == WEIQI){
c.play(arr[0],arr[1]);
} else if (c.config.gameType == DAOQI){
this.style.cursor = 'move';
}
}).mouseup(function(e){
this.style.cursor = 'auto';
var arr = c.eventToXY(e);
var toX = arr[0], toY = arr[1];
if (c.fromX == undefined || c.fromX == NaN || c.fromY == undefined || c.fromY == NaN)
return;
if (c.fromX != toX || c.fromY != toY) {
c.moveBoard(toX-c.fromX, toY-c.fromY);
}
});
c.setToggleNumberImg();
jQuery("#"+c.id+"_goToInput").keydown(function(){
if(e.keyCode==13){
gvGoTo(id);
}
});
c.addPrisonerHandlers();
c.registerKeyListener();
jQuery(document).ready(function(){tb_init("a.thickbox")});
return c;
},

addPrisonerHandlers: function(){
var c = this;
jQuery("#" + this.id + "_moveOuter, #" + this.id + "_blackPrisonersOuter, #" + this.id + "_whitePrisonersOuter")
.mouseout(function(){
jQuery("#"+c.id+"_prisoners").empty();
});
jQuery("#" + this.id + "_blackPrisonersOuter").mouseover(function(){
jQuery("#"+c.id+"_prisoners").empty();
if (c.gameState.blackPrisoners > 0){
jQuery.each(c.gameState.blackPrisonerPoints, function(i,item){
c.showPrisoner(item);
});
}
});
jQuery("#" + this.id + "_whitePrisonersOuter").mouseover(function(){
jQuery("#"+c.id+"_prisoners").empty();
if (c.gameState.whitePrisoners > 0){
jQuery.each(c.gameState.whitePrisonerPoints, function(i,item){
c.showPrisoner(item);
});
}
});
jQuery("#" + this.id + "_moveOuter").mouseover(function(){
jQuery("#"+c.id+"_prisoners").empty();
if (c.gameState.currentNode.blackPrisoners > 0){
jQuery.each(c.gameState.currentNode.blackPrisonerPoints, function(i,item){
c.showPrisoner(item);
});
}
if (c.gameState.currentNode.whitePrisoners > 0){
jQuery.each(c.gameState.currentNode.whitePrisonerPoints, function(i,item){
c.showPrisoner(item);
});
}
});
},

showPrisoner: function(item){
var c = this;
var conf = c.config;
var x = item[0], y = item[1], color = item[2];
var area = c.xyToArea(x,y);
var left = area[0], top = area[1], width = area[2], height = area[3];
if (conf.gameType == DAOQI) {
var cssClass = color == STONE_BLACK? "gvsprite-19-markblack" : "gvsprite-19-markwhite";
c.mapToPoints(x,y,function(x1,y1){
var area = c.xyToArea(x1,y1);
var left = area[0], top = area[1], width = area[2], height = area[3];
var s = "<div class='"+cssClass+"' style='position:absolute;left:"+left+"px;top:"+top+"px;";
if (c.gameState.board[x][y] == STONE_NONE){
if (c.isInCentralArea(x1,y1)){
s += "background-color:"+conf.boardColorDQ+";";
} else {
s += "background-color:"+conf.boardColor+";";
}
}
s += "'></div>";
jQuery("#"+c.id+"_prisoners").append(s);
});
} else {
var cssClass = color == STONE_BLACK? "gvsprite-21-markblack" : "gvsprite-21-markwhite";
var s = "<div class='"+cssClass+"' style='position:absolute;left:"+left+"px;top:"+top+"px;";
if (c.gameState.board[x][y] == STONE_NONE){
s += "background-color:"+conf.boardColor+";";
}
s += "'></div>";
jQuery("#"+c.id+"_prisoners").append(s);
}
},

removeKeyListener: function(){
jQuery("#"+this.id+"_bannerbg").css("background-color",this.config.inactiveBackground);
},

registerKeyListener: function(){
var c = this;
for(var i=1; i<=gv.length; i++){
gv[gv.getId(i)].removeKeyListener();
}
jQuery("#"+this.id+"_bannerbg").css("background-color",c.config.activeBackground);
document.onkeydown = function(e){
var keyCode;
if (window.event)
keyCode = window.event.keyCode;
else if (e)
keyCode = e.which;
else
return;

e = e || window.event;
switch(keyCode){
case 37: // left
if (e.ctrlKey){
if (e.altKey)
c.backAll();
else
c.backN(c.config.fastMode)
} else {
if (e.altKey && e.shiftKey)
c.backToComment();
else
c.back();
}
return;
case 39: // right
if (e.ctrlKey){
if (e.altKey)
c.forwardAll();
else
c.forwardN(c.config.fastMode);
} else {
if (e.altKey && e.shiftKey)
c.forwardToComment();
else
c.forward();
}
return;
case 46: // delete
c.remove();
return;
}

if (e.altKey && e.shiftKey){
switch (keyCode) {
case 71: // g
setTimeout("gv."+c.id+".goToPopup()",100);
break;
case 77: // m
c.toggleNumber();
break;
case 82: // r
c.refresh();
break;
default: // a: 65, z: 90
if (keyCode >= 65 && keyCode <= 90){
c.goToBranch(keyCode - 65);
}
}
}
};
return c;
},

initGame: function(){
return this.removeAllStones()
.setGameInfo()
.setGameState()
.addRemoveStones(this.gameState.currentNode.points);
},

setGameInfo: function(){
var c = this;
if (c.isMyTurn()){
jQuery("#" + c.id + "_resign").show();
} else {
jQuery("#" + c.id + "_resign").hide();
}
var infoNode = jQuery("#" + c.id + "_info").empty();
var game = c.game;
if (game == undefined || game == null)
return c;
if (notNull(game.name)){
infoNode.append("<div align='center' style='font-weight:bold'>"+jQuery.trim(game.name)+"</div>");
}
if (notNull(game.date)){
infoNode.append("<div>&#26102;&#38388;&#65306;"+jQuery.trim(game.date)+"</div>");
}
if (notNull(game.place)){
infoNode.append("<div>&#22320;&#28857;&#65306;"+jQuery.trim(game.place)+"</div>");
}
var playFirst = "&nbsp;&lt;-&nbsp;&#20808;&#34892;";
var blackRank = "";
if (notNull(game.blackRank))
blackRank = "&nbsp;("+game.blackRank+")";
var blackPlayer = "<div>&#40657;&#26041;&#65306;<strong>"+jQuery.trim(game.blackName)+"</strong>"+blackRank;
if (game.getFirstPlayer() == STONE_BLACK)
blackPlayer += playFirst;
blackPlayer += "</div>";
infoNode.append(blackPlayer);
var whiteRank = "";
if (notNull(game.whiteRank))
whiteRank = "&nbsp;("+game.whiteRank+")";
var whitePlayer = "<div>&#30333;&#26041;&#65306;<strong>"+jQuery.trim(game.whiteName)+"</strong>"+whiteRank;
if (game.getFirstPlayer() == STONE_WHITE)
whitePlayer += playFirst;
whitePlayer += "</div>";
infoNode.append(whitePlayer);
if (game.handicap > 0){
infoNode.append("<div>&#35753;&#23376;&#65306;"+game.handicap+"</div>");
} else {
infoNode.append("<div>&#35268;&#21017;&#65306;"+jQuery.trim(game.rule)+"</div>");
if (game.rule == "Chinese")
infoNode.append("<div>&#36148;&#23376;&#65306;"+game.komi+"</div>");
else
infoNode.append("<div>&#36148;&#30446;&#65306;"+game.komi+"</div>");
}
infoNode.append("<div>&#25163;&#25968;&#65306;"+game.getMoves()+"</div>");
infoNode.append("<div>&#32467;&#26524;&#65306;"+jQuery.trim(game.result)+"</div>");
return c;
},

removeGameInfo: function(){
jQuery("#" + this.id + "_info").empty();
return this;
},

setGameState: function(){
var c = this;
var gameState = c.gameState;
var node = gameState.currentNode;
c.setNextPlayer(gameState.getNextPlayer());
c.setMoveNumber(node.moveNumber);
c.setPrisoners(gameState.blackPrisoners, gameState.whitePrisoners);
if (node.type == NODE_MOVE)
c.setMoveMark(node.x, node.y);
else
c.removeMoveMark();
c.setMarks(node.marks);
c.setBranches();
c.setComment();
return c;
},

moveBoard: function(xDiff,yDiff){
var c = this;
var conf = c.config;
if (conf.gameType != DAOQI)
return;
var board = c.gameState.board;
conf.x0 = board.normalize(conf.x0+xDiff);
conf.y0 = board.normalize(conf.y0+yDiff);
c.removeAllStones();
c.removeBranches();
c.removeMoveMark();
var s = "";
for(var i=0; i<board.size; i++){
for(var j=0; j<board.size; j++){
var color = board[i][j];
if (color == STONE_BLACK || color == STONE_WHITE){
var moveNumber = 0;
if (c.config.showMoveNumber)
moveNumber = c.gameState.getMoveNumber(i,j);
c.mapToPoints(i,j,function(x,y){
s += c.createStone(x,y,color,moveNumber);
});
}
}
}
if (s.length > 0)
jQuery("#"+c.id+"_boardPoints").append(s);
c.setBranches();
var node = c.gameState.currentNode;
if (node.type == NODE_MOVE)
c.setMoveMark(node.x, node.y);
else
c.removeMoveMark();
var vlabelStart = (conf.y0-conf.vbw)*conf.gridSize;
jQuery("#"+c.id+"_vlabel").css("backgroundPosition", "0px "+vlabelStart+"px");
var hlabelStart = (conf.x0-conf.vbw)*conf.gridSize;
jQuery("#"+c.id+"_hlabel").css("backgroundPosition", hlabelStart+"px 0px");
c.setMarks(node.marks);
return c;
},

mapToPoints_: function(x,y){
var conf = this.config;
var stones = new Array();
var x1 = x+conf.x0, y1 = y+conf.y0;
var xarr = [];
if (x1>=0 && x1<conf.boardSizeDQ)
xarr.push(x1);
if (x1>=conf.boardSize)
xarr.push(x1-conf.boardSize);
if (x1<conf.boardSizeDQ-conf.boardSize)
xarr.push(x1+conf.boardSize);

var yarr = [];
if (y1>=0 && y1<conf.boardSizeDQ)
yarr.push(y1);
if (y1>=conf.boardSize)
yarr.push(y1-conf.boardSize);
if (y1<conf.boardSizeDQ-conf.boardSize)
yarr.push(y1+conf.boardSize);

for(var i=0; i<xarr.length; i++)
for(var j=0; j<yarr.length; j++){
stones.push([xarr[i],yarr[j]]);
}
return stones;
},

mapToPoints: function(x,y,func){
var stones = this.mapToPoints_(x,y);
for(var i=0; i<stones.length; i++){
var stone = stones[i];
func(stone[0],stone[1]);
}
return this;
},

getStoneId: function(x,y){
return this.id+"_point_"+x+"-"+y;
},

createStone: function(x,y,color,moveNumber){
var c = this;
var styleClass = "";
if (c.config.gameType == DAOQI){
if (color == STONE_BLACK)
styleClass = "gvsprite-19-black";
else if (color == STONE_WHITE)
styleClass = "gvsprite-19-white";
else
return null;
} else {
if (color == STONE_BLACK)
styleClass = "gvsprite-21-black";
else if (color == STONE_WHITE)
styleClass = "gvsprite-21-white";
else
return null;
}
var s = "<div id='" + c.getStoneId(x,y) + "' class='" + styleClass + "' style='position:absolute;left:";
a = c.xyToArea(x,y);
s += a[0] + "px;top:" + a[1] + "px;'>";
if (c.config.showMoveNumber && moveNumber > 0){
var colorS = "white";
if (color == STONE_WHITE)
colorS = "black";
var fontSize = "medium";
var left = 0;
if (moveNumber >= 10 && moveNumber < 100){
fontSize = "small";
}else if (moveNumber >= 100){
fontSize = "x-small";
left = 1;
}
s += "<div style='display:table;width:"+a[2]+"px;height:"+a[3]+"px;#position:relative;overflow:hidden;'><div style='display:table-cell;vertical-align:middle;#position:absolute;#top:50%;'>"
+"<div style='#position:relative;left:"+left+"px;width:100%;#top:-50%;text-align:center;color:"+colorS+";font-family:times;font-size:"+fontSize+";'>"+moveNumber+"</div></div></div>";
} else {
s += "&nbsp;";
}
s += "</div>";
return s;
},

addStone: function(x,y,color){
var c = this;
var conf = c.config;
var moveNumber = 0;
if (conf.showMoveNumber){
moveNumber = c.gameState.getMoveNumber(x,y);
}
if (conf.gameType == DAOQI){
c.mapToPoints(x,y,function(x,y){
var s = c.createStone(x,y,color,moveNumber);
if (s != null){
jQuery("#"+c.id+"_boardPoints").append(s);
}
});
} else {
var s = c.createStone(x,y,color,moveNumber);
if (s != null){
jQuery("#"+c.id+"_boardPoints").append(s);
}
}
return c;
},

addRemoveStones: function(points){
var c = this;
for(var i=0; i<points.length; i++){
var point = points[i];
c.removeStone(point.x,point.y);
if (!point.deleteFlag){
c.addStone(point.x, point.y, point.color);
}
}
return c;
},

removeStone: function(x,y){
var c = this;
var conf = c.config;
if (conf.gameType == DAOQI){
this.mapToPoints(x,y,function(x,y){
var stone = jQuery("#"+c.getStoneId(x,y));
stone.remove();
});
} else {
var stone = jQuery("#"+c.getStoneId(x,y));
stone.remove();
}
return c;
},

removeAllStones: function(){
jQuery("#"+this.id+"_boardPoints").children().remove();
return this;
},

setNextPlayer: function(color){
var s = "";
if (color == STONE_BLACK)
s += "&#40657;";
else if (color == STONE_WHITE)
s += "&#30333;";
jQuery("#"+this.id+"_nextPlayer").empty().append(s);
return this;
},

setMoveNumber: function(moveNumber){
if (moveNumber == 0)
moveNumber = "0";
jQuery("#"+this.id+"_curMove").empty().append(moveNumber);
return this;
},

setMoveMark: function(x,y){
var c = this;
var conf = c.config;
if (conf.gameType == DAOQI){
jQuery("#"+c.id+"_moveMarks").empty();
c.mapToPoints(x,y,function(x,y){
var area = c.xyToArea(x,y);
jQuery("#"+c.id+"_moveMarks").append("<div class='gvsprite-19-markmove' style='position:absolute;left:"+
area[0]+"px;top:"+area[1]+"px;width:"+area[2]+"px;height:"+area[3]+"px'>&nbsp;</div>");
});
} else {
jQuery("#"+c.id+"_moveMark").css({position: "absolute", left:x*conf.gridSize, top:y*conf.gridSize, width:conf.gridSize, height:conf.gridSize});
}
return c;
},

removeMoveMark: function(){
var c = this;
if (c.config.gameType == DAOQI){
jQuery("#"+c.id+"_moveMarks").empty();
} else {
jQuery("#"+c.id+"_moveMark").css({width:0, height:0});
}
return c;
},

setMarks: function(marks){
var c = this;
jQuery("#"+c.id+"_boardMarks").empty();
if (marks == undefined || marks == null)
return c;
var conf = c.config;
if (conf.gameType == DAOQI){
for (var i=0; i<marks.length; i++){
var mark = marks[i];
var x = mark[0], y = mark[1];
var color = c.gameState.board[x][y];
var styleClass = "";
switch(mark[2]){
case MARK_CROSS:
styleClass = "gvsprite-19-markcross";
break;
case MARK_TRIANGLE:
styleClass = "gvsprite-19-marktriangle";
break;
case MARK_SQUARE:
styleClass = "gvsprite-19-marksquare";
break;
case MARK_CIRCLE:
styleClass = "gvsprite-19-markcircle";
break;
case MARK_TERR_BLACK:
styleClass = "gvsprite-19-markblack";
break;
case MARK_TERR_WHITE:
styleClass = "gvsprite-19-markwhite";
break;
case MARK_TEXT:
c.mapToPoints(x,y,function(x,y){
var area = c.xyToArea(x,y);
var left = area[0], top = area[1], width = area[2], height = area[3];
var s = "<div style='position:absolute;left:"+left+"px;top:"+top+"px;width:"+width+"px;height:"+height+"px;text-align:center;vertical-align:middle;color:red;font-family:Nina;font-weight:bolder;font-size:14px;";
if (color == STONE_NONE){
if (c.isInCentralArea(x,y)){
s += "background-color:"+conf.boardColorDQ+";";
} else {
s += "background-color:"+conf.boardColor+";";
}
}
s += "'>"+mark[3]+"</div>";
jQuery("#"+c.id+"_boardMarks").append(s);
});
continue;
}
c.mapToPoints(x,y,function(x,y){
var area = c.xyToArea(x,y);
var left = area[0], top = area[1], width = area[2], height = area[3];
var s = "<div class='"+styleClass+"' style='position:absolute;left:"+left+"px;top:"+top+"px;";
if (color == STONE_NONE){
if (c.isInCentralArea(x,y)){
s += "background-color:"+conf.boardColorDQ+";";
} else {
s += "background-color:"+conf.boardColor+";";
}
}
s += "'></div>";
jQuery("#"+c.id+"_boardMarks").append(s);
});
}
} else {
for (var i=0; i<marks.length; i++){
var mark = marks[i];
var x = mark[0], y = mark[1];
var color = c.gameState.board[x][y];
var area = c.xyToArea(x,y);
var left = area[0], top = area[1], width = area[2], height = area[3];
var styleClass = "";
switch(mark[2]){
case MARK_CROSS:
styleClass = "gvsprite-21-markcross";
break;
case MARK_TRIANGLE:
styleClass = "gvsprite-21-marktriangle";
break;
case MARK_SQUARE:
styleClass = "gvsprite-21-marksquare";
break;
case MARK_CIRCLE:
styleClass = "gvsprite-21-markcircle";
break;
case MARK_TERR_BLACK:
styleClass = "gvsprite-21-markblack";
break;
case MARK_TERR_WHITE:
styleClass = "gvsprite-21-markwhite";
break;
case MARK_TEXT:
var s = "<div style='position:absolute;left:"+left+"px;top:"+top+"px;width:"+width+"px;height:"+height+"px;text-align:center;vertical-align:middle;color:red;font-family:Nina;font-weight:bolder;font-size:15px;";
if (color == STONE_NONE){
s += "background-color:"+conf.boardColor+";";
}
s += "'>"+mark[3]+"</div>";
jQuery("#"+c.id+"_boardMarks").append(s);
continue;
}
var s = "<div class='"+styleClass+"' style='position:absolute;left:"+left+"px;top:"+top+"px;";
if (color == STONE_NONE){
s += "background-color:"+conf.boardColor+";";
}
s += "'></div>";
jQuery("#"+c.id+"_boardMarks").append(s);
}
}
return this;
},

setPrisoners: function(b, w){
if (b == 0)
b = "0";
if (w == 0)
w = "0";
jQuery("#"+this.id+"_blackPrisoners").empty().append(b);
jQuery("#"+this.id+"_whitePrisoners").empty().append(w);
return this;
},

setBranches: function(){
var c = this;
var conf = c.config;
jQuery("#"+c.id+"_boardBranches").empty();
jQuery("#"+c.id+"_branches").empty();
jQuery("#"+c.id+"_branches").css({height:0});
var gameState = c.gameState;
var node = gameState.currentNode;
if (node.hasChildren() && node.children.length >= 2){
var n = node.children.length;
for(var i=0; i<node.children.length; i++){
var title = "";
if (i == 0){
title = "&#20998;&#25903;A = &#23454;&#25112; [Alt Shift &#8594;][Alt Shift A]";
} else {
if (i < BRANCHES.length){
var branchName = BRANCHES[i];
title = "&#20998;&#25903;" + branchName + "[Alt Shift " + branchName + "]";
}
}
var s = "<div class='gvtb-branch gvbutton'><a href='#' title='" + title + "' onclick='gv."+c.id+".goToBranch("+i+");return false;'>"+BRANCHES[i]+"</a></div>";
jQuery("#"+c.id+"_branches").append(s);
jQuery("#"+c.id+"_branches").css({height:n*23});
var child = node.children[i];
if (child.type == NODE_MOVE){
var x = child.x, y = child.y;
if (conf.gameType == DAOQI){
c.mapToPoints(x,y,function(x,y){
var styleClass = "gvbranch";
if (c.isInCentralArea(x,y))
styleClass = "gvbranch-real";
var area = c.xyToArea(x,y);
jQuery("#"+c.id+"_boardBranches").append("<div class='"+styleClass+"' style='left:"+area[0]+"px;top:"+area[1]
+"px;width:"+area[2]+"px;height:"+area[3]+"px;'>"+BRANCHES[i]+"</div>");
});
} else {
var area = c.xyToArea(x,y);
jQuery("#"+c.id+"_boardBranches").append("<div class='gvbranch' style='left:"+area[0]+"px;top:"+area[1]
+"px;width:"+area[2]+"px;height:"+area[3]+"px;'>"+BRANCHES[i]+"</div>");
}
}
}
}
return this;
},

removeBranches: function(){
jQuery("#"+this.id+"_boardBranches").empty();
jQuery("#"+this.id+"_branches").empty();
jQuery("#"+this.id+"_branches").css({height: 0});
return this;
},

setComment: function(comment){
var c = this;
var gameState = c.gameState;
var node = gameState.currentNode;
if (!comment){
comment = "<strong>";
if (node.depth > 1)
comment += "&#20998;&#25903;";
comment += "&#31532;"+node.moveNumber+"&#25163;&#35780;&#35770;</strong>";
if (node.comment != undefined && node.comment != null)
comment += "<br/>"+node.comment.replace(/\n/g, "<br/>\n");
}
jQuery("#"+c.id+"_comment").empty().append(comment);
jQuery("#"+c.id+"_comment").height(c.rightPaneHeight - jQuery("#"+c.id+"_info").height()-12);
return this;
},

removeComment: function(){
jQuery("#"+this.id+"_comment").empty();
return this;
},

redrawBoard: function(){
var c = this;
var gameState = c.gameState;
var board = gameState.board;
var s = "";
if (c.config.gameType == DAOQI){
for(var i=0; i<board.size; i++){
for(var j=0; j<board.size; j++){
var color = board[i][j];
var moveNumber = 0;
if (c.config.showMoveNumber){
moveNumber = c.gameState.getMoveNumber(i,j);
}
if (color == STONE_BLACK || color == STONE_WHITE){
c.mapToPoints(i,j,function(x,y){
s += c.createStone(x,y,color,moveNumber);
});
}
}
}
} else {
for(var i=0; i<board.size; i++){
for(var j=0; j<board.size; j++){
var color = board[i][j];
var moveNumber = 0;
if (c.config.showMoveNumber){
moveNumber = c.gameState.getMoveNumber(i,j);
}
if (color == STONE_BLACK || color == STONE_WHITE){
s += c.createStone(i,j,color,moveNumber);
}
}
}
}
jQuery("#"+c.id+"_boardPoints").empty();
if (s.length > 0)
jQuery("#"+c.id+"_boardPoints").append(s);
return c;
},

sendMove_: function(x,y){
this.play(x,y);
return this.sendMove();
},

play: function(x,y){
var c = this;
var gameState = c.gameState;

if (gameState == null)
return c;

if (gameState.board[x][y] != 0){
if (gameState.isFirst())
return false;
var points = new Array();
var changed = false;
for(;;){
var node = gameState.currentNode;
if (node.type == NODE_MOVE && node.x == x && node.y == y)
break;
if (!c.back_(points))
break;
changed = true;
}
if (changed){
jQuery.each(points, function(i,point){
c.removeStone(point.x,point.y);
if (point.deleteFlag){
c.addStone(point.x, point.y, point.color);
}
});
c.setGameState();
return true;
}
return false;
}

if (!gameState.isLast()){
var children = gameState.currentNode.children;
for(var i=0; i<children.length; i++){
var node = children[i];
if (node.type == NODE_MOVE && node.x == x && node.y == y){
return c.goToBranch(i);
}
}
}

if (gameState.play(x,y)){
var node = gameState.currentNode;
jQuery.each(node.points, function(i,point){
c.removeStone(point.x,point.y);
if (!point.deleteFlag){
c.addStone(point.x, point.y, point.color);
}
});
c.setGameState();
return true;
} else {
return false;
}
},

remove: function(){
var c = this;
var gs = c.gameState;
if (gs != null && gs.canRemove()){
var node = gs.currentNode;
jQuery.each(node.points, function(i,point){
c.removeStone(point.x,point.y);
if (point.deleteFlag){
c.addStone(point.x, point.y, point.color);
}
});
gs.remove();
c.setGameState();
}
return c;
},

back_: function(points){
var c = this;
var gameState = c.gameState;
if (gameState.isFirst())
return false;
var node = gameState.currentNode;
for (var i=0; i<node.points.length; i++){
var point = node.points[i];
var found = false;
for(var j=0; j<points.length; j++){
var p = points[j];
if (point.x == p.x && point.y == p.y){
found = true;
points[j] = point;
break;
}
}
if (!found){
points.push(point);
}
}
gameState.back();
return true;
},

back: function(){
var c = this;
var gameState = c.gameState;
if (gameState == null)
return c;
if (gameState.isFirst())
return false;
var node = gameState.currentNode;
jQuery.each(node.points, function(i,point){
c.removeStone(point.x,point.y);
if (point.deleteFlag){
c.addStone(point.x, point.y, point.color);
}
});
gameState.back();
c.setGameState();
return true;
},

backN: function(n){
var c = this;
if (c.gameState == null)
return c;
if (n == undefined)
n = c.config.fastMode;
var points = new Array();
var changed = false;
for(var i=0; i<n; i++){
if (!c.back_(points))
break;
changed = true;
}
if (changed){
jQuery.each(points, function(i,point){
c.removeStone(point.x,point.y);
if (point.deleteFlag){
c.addStone(point.x, point.y, point.color);
}
});
c.setGameState();
}
return c;
},

backToComment: function(){
var c = this;
if (c.gameState == null)
return c;
var points = new Array();
var changed = false;
for(;;){
if (!c.back_(points))
break;
changed = true;
var node = c.gameState.currentNode;
if (node.hasComment() || node.hasBranches())
break;
}
if (changed){
jQuery.each(points, function(i,point){
c.removeStone(point.x,point.y);
if (point.deleteFlag){
c.addStone(point.x, point.y, point.color);
}
});
c.setGameState();
}
return c;
},

backAll: function(){
var c = this;
var gameState = c.gameState;
if (gameState == null)
return c;
c.removeAllStones();
gameState.backAll();
var node = gameState.currentNode;
jQuery.each(node.points, function(i, point){
if (point.color == STONE_BLACK || point.color == STONE_WHITE){
c.addStone(point.x,point.y,point.color);
}
});
c.setGameState();
return c;
},

forward_: function(points){
var c = this;
var gameState = c.gameState;
if (gameState.isLast())
return false;
gameState.forward();
var node = gameState.currentNode;
for (var i=0; i<node.points.length; i++){
var point = node.points[i];
var found = false;
for(var j=0; j<points.length; j++){
var p = points[j];
if (point.x == p.x && point.y == p.y){
found = true;
points[j] = point;
break;
}
}
if (!found){
points.push(point);
}
}
return true;
},

forward: function(){
var c = this;
var gameState = c.gameState;
if (gameState == null)
return c;
if (!gameState.forward())
return false;
var node = gameState.currentNode;
jQuery.each(node.points, function(i,point){
c.removeStone(point.x,point.y);
if (!point.deleteFlag){
c.addStone(point.x, point.y, point.color);
}
});
c.setGameState();
return true;
},

forwardN: function(n){
var c = this;
if (c.gameState == null)
return c;
if (n == undefined)
n = c.config.fastMode;
var points = new Array();
var changed = false;
for(var i=0; i<n; i++){
if (!c.forward_(points))
break;
changed = true;
}
if (changed){
jQuery.each(points, function(i,point){
c.removeStone(point.x,point.y);
if (!point.deleteFlag){
c.addStone(point.x, point.y, point.color);
}
});
c.setGameState();
}
return c;
},

forwardToComment: function(){
var c = this;
if (c.gameState == null)
return c;
var points = new Array();
var changed = false;
for(;;){
if (!c.forward_(points))
break;
changed = true;
var node = c.gameState.currentNode;
if (node.hasComment() || node.hasBranches())
break;
}
if (changed){
jQuery.each(points, function(i,point){
c.removeStone(point.x,point.y);
if (!point.deleteFlag){
c.addStone(point.x, point.y, point.color);
}
});
c.setGameState();
}
return c;
},

forwardAll: function(){
var c = this;
var gameState = c.gameState;
if (gameState == null)
return c;
c.removeAllStones();
gameState.forwardAll();
this.redrawBoard();
c.setGameState();
return c;
},

goToBranch: function(n){
var c = this;
var gameState = c.gameState;
if (gameState == null)
return c;
if (!gameState.goToBranch(n))
return c;
var node = gameState.currentNode;
jQuery.each(node.points, function(i,point){
c.removeStone(point.x,point.y);
if (!point.deleteFlag){
c.addStone(point.x, point.y, point.color);
}
});
c.setGameState();
return c;
},

goTo: function(n){
var c = this;
var gameState = c.gameState;
if (gameState == null)
return c;
while (gameState.isOnBranch()){
c.back();
}
if (n >= gameState.game.getMoves()){
c.forwardAll();
} else if (n <= 0) {
c.backAll();
} else if (n > gameState.currentNode.moveNumber) {
var points = new Array();
var changed = false;
while(n > gameState.currentNode.moveNumber){
if (!c.forward_(points))
break;
changed = true;
}
if (changed){
jQuery.each(points, function(i,point){
c.removeStone(point.x,point.y);
if (!point.deleteFlag){
c.addStone(point.x, point.y, point.color);
}
});
c.setGameState();
}
} else if (n < gameState.currentNode.moveNumber) {
var points = new Array();
var changed = false;
while(n < gameState.currentNode.moveNumber){
if (!c.back_(points))
break;
changed = true;
}
if (changed){
jQuery.each(points, function(i,point){
c.removeStone(point.x,point.y);
if (point.deleteFlag){
c.addStone(point.x, point.y, point.color);
}
});
c.setGameState();
}
}
return c;
},

setToggleNumberImg: function(){
var c = this;
if (c.config.showMoveNumber){
jQuery("#"+c.id+"_toggleNumberImg").removeClass("gvsprite-hidenumber");
jQuery("#"+c.id+"_toggleNumberImg").addClass("gvsprite-shownumber");
} else {
jQuery("#"+c.id+"_toggleNumberImg").removeClass("gvsprite-shownumber");
jQuery("#"+c.id+"_toggleNumberImg").addClass("gvsprite-hidenumber");
}
return c;
},

toggleNumber: function(){
var c = this;
if (c.config.showMoveNumber){
c.config.showMoveNumber = false;
} else {
c.config.showMoveNumber = true;
}
c.setToggleNumberImg();
if (c.gameState == null)
return c;
c.redrawBoard();
return c;
},

showNumber: function(){
var c = this;
if (c.config.hideMoveNumber){
c.toggleNumber();
}
return c;
},

hideNumber: function(){
var c = this;
if (c.config.showMoveNumber){
c.toggleNumber();
}
return c;
},

eventToXY: function(e){
var conf = this.config;
e = e || window.event;
if (e.layerX == undefined)
e.layerX = e.offsetX;
if (e.layerY == undefined)
e.layerY = e.offsetY;
var x = parseInt(e.layerX/conf.gridSize);
var y = parseInt(e.layerY/conf.gridSize);
if (conf.gameType == DAOQI){
x = (x+conf.boardSize-conf.x0)%conf.boardSize;
y = (y+conf.boardSize-conf.y0)%conf.boardSize;
}
return [x,y];
},

isInCentralArea: function(x,y){
var conf = this.config;
return x >= conf.vbw && x < conf.boardSize+conf.vbw && y >= conf.vbw && y < conf.boardSize+conf.vbw;
},

xyToArea: function(x,y){
var conf = this.config;
return [x*conf.gridSize, y*conf.gridSize, conf.gridSize, conf.gridSize];
},

xyToLabel: function(x,y){
var conf = this.config;
var s = LABELS[x];
s += conf.boardSize - parseInt(y);
return s;
},

postThickBoxFix: function(){
this.registerKeyListener();
},

goToPopup: function(){
var url = "#TB_inline?test=0&width=250&height=56&inlineId="+this.id+"_goTo&focus="+this.id+"_goToInput&modal=true&test1=0";
tb_show("",url,null);
},

goToOkHandler: function(){
try {
var input = document.getElementsByName(this.id+"_goToForm")[1].goToInput.value;
tb_remove();
var moveNumber = parseInt(input);
this.goTo(moveNumber);
}
catch(e){
throw "GameController().goToOkHandler(): " + e;
}
this.postThickBoxFix();
},

goToKeyDown:function(input, e){
var keyCode;
if (window.event)
keyCode = window.event.keyCode;
else if (e)
keyCode = e.which;
else
return;

if (keyCode == 13){
gvGoToInput = input.value;
this.goToOkHandler();
} else if (keyCode == 27){
tb_remove();
this.postThickBoxFix();
}
}
});


Object.extend(GameController.prototype, {
initialize: function(config){
this.id = gv.getId();
gv[this.id] = this;
this.config = clone(CONFIG);
if (config != null)
Object.extend(this.config,config);
this.reset();
},

init: function(){
this.initView();
this._initialized = true;
return this;
},

initialized: function(){
return this._inialized == true;
},

destroy: function(){
this.destroyView();
delete gv[this.id];
gv.length--;
},

reset: function(){
this._initialized = false;
if (this.config.container != null)
jQuery("#" + this.config.container).empty().append(this.getPlaceHolder());
else {
if (document.getElementById(this.id) != null)
jQuery("#"+this.id).replaceWith(this.getPlaceHolder());
else
document.write(this.getPlaceHolder());
}
return this;
},

show: function(){
if (!this.initialized())
this.init();
jQuery("#" + this.id).show();
return this;
},

hide: function(){
jQuery("#" + this.id).hide();
return this;
},

setGameType: function(gameType){
if (this.config.gameType != gameType){
this.config.gameType = gameType;
this.reset();
}
return this;
},

setGameTypeIf: function(gameType){
if (this.config.gameType != DAOQI && this.game.type == DAOQI){
this.setGameType(DAOQI);
}
return this;
},

load: function(url, n){
var h = GameHistory[url];
if (h != undefined && h != null){
GameHistory.save(h);
this.game = h.game;
this.setGameTypeIf(this.game.type).show();
this.gameState = h;
this.gameState.backAll();
this.initGame();
if (n == undefined)
this.forwardAll();
else
this.forwardN(n);
return this;
}
var c = this;
jQuery.ajax({url:url,
success:function(response){
try {
if (c.game && c.game.dataSize && c.game.dataSize == response.length){
return;
}
c.game = new SGFParser(c.config.gameType).parse(response);
c.game.dataSize = response.length;
c.setGameTypeIf(c.game.type).show();
c.game.url = url;
c.gameState = new GameState(c.game);
GameHistory.save(c.gameState);
c.initGame();
if (n == undefined)
c.forwardAll();
else
c.forwardN(n);
} catch(e) {
throw "GameController.load('" + url + "')->success: " + e;
}
},
failure:function(){
throw "GameController.load('" + url + "')->failure:";
}
});
return this;
},

loadInline: function(divId, n){
try {
if (jQuery("#"+divId).length == 0){
return this;
}
var s = jQuery.trim(jQuery("#"+divId).text());
if (this.game && this.game.dataSize && this.game.dataSize == s.length){
return this;
}
this.game = new SGFParser(this.config.gameType).parse();
this.game.dataSize = s.length;
this.setGameTypeIf(this.game.type);
this.gameState = new GameState(this.game);
this.initGame();
if (n == undefined)
this.forwardAll();
else
this.forwardN(n);
return this;
} catch(e) {
throw "GameController.loadInline('" + divId + "'): " + e;
}
},

refresh: function(force){
var url = this.game.url;
var c = this;
jQuery.ajax({url:url,
ifModified: true,
success:function(response){
try {
if (!force && c.game && c.game.dataSize && c.game.dataSize == response.length){
return;
}
c.game = new SGFParser(c.config.gameType).parse(response);
c.game.dataSize = response.length;
c.setGameTypeIf(c.game.type).show();
c.game.url = url;
c.gameState = new GameState(c.game);
GameHistory.save(c.gameState);
c.initGame();
c.forwardAll();
} catch(e) {
throw "GameController.refresh('" + url + "')->success: " + e;
}
},
failure:function(){
throw "GameController.refresh('" + url + "')->failure:";
}
});
},

openInWindow: function(){
var url = this.config.baseDir + "gamewindow.php?";
var title = "jsgameviewer", width = 722, height = 452;
if (this.config.gameType == DAOQI) {
url += "type=DAOQI&";
width = 798;
height = 528;
}
if (this.game && this.game.url)
url += "url=" + encodeURIComponent(this.game.url);
var win = window.open(url, title, "width=" + width + "px,height=" + height + "px,status=yes,location=no,resizable=yes");
},

setPlayer: function(player){
this.player = player;
return this;
},

setPlayerInterval: function(interval){
this.config.playerInterval = interval;
return this;
},

setObserverInterval: function(interval){
this.config.observerInterval = interval;
return this;
},

startUpdater: function(){
this.stopUpdater();
if (this.game && !this.game.isFinished())
return this;
var c = this;
var updaterFunc = function(){
if (!c.game)
return;
if (c.game.isFinished()){
c.stopUpdater();
return;
}
if (c.isMyTurn())
return;
c.refresh();
};
if (this.player){
this.playerUpdater = setInterval(updaterFunc, this.config.playerInterval*1000);
}
this.observerUpdater = setInterval(updaterFunc, this.config.observerInterval*1000);
return this;
},

stopUpdater: function(){
if (this.playerUpdater){
clearInterval(this.playerUpdater);
delete this.playerUpdater;
}
if (this.observerUpdater){
clearInterval(this.observerUpdater);
delete this.observerUpdater;
}
return this;
},

saveSession: function(url, interval){
if (!this.sessionSaver){
this.sessionSaver = setInterval(function(){
jQuery.ajax({url: url});
}, interval*1000);
}
return this;
},

setUsernameElemId: function(elemId){
this.usernameElemId = elemId;
return this;
},

setUsername: function(username){
this.username = username;
return this;
},

getUsername: function(){
if (this.username){
return this.username;
} else if (this.usernameElemId){
return jQuery.trim(jQuery('#' + this.usernameElemId).text());
} else {
return null;
}
},

isPlayer: function(){
if (this.player && this.player.isPlayer){
return this.player.isPlayer();
} else {
return false;
}
},

isMyTurn: function(){
if (this.player && this.player.isMyTurn){
return this.player.isMyTurn();
} else {
return false;
}
},

sendMove: function(){
if (this.player && this.player.sendMove){
return this.player.sendMove();
} else {
alert("这不是DGS对局。本程序目前只支持在DGS上下棋。");
return false;
}
},

resign: function(){
if (this.player && this.player.resign){
var answer = confirm("你确实要认输吗？");
if (answer)
this.player.resign();
} else {
alert("这不是DGS对局。本程序目前只支持在DGS上下棋。");
return false;
}
},

getPlaceHolder: function(){
return "<div id='" + this.id + "' style='display:none'>&nbsp;</div>";
}
});

GameController.prototype.loadGame = GameController.prototype.load;


DGS_GAME_ID_PATTERN = /gid=(\d+)/i;

Object.extend(CONFIG, {
dgsUrlPrefix: "http://www.dragongoserver.net/"
});

Object.extend(GameController.prototype, {
loadDGSGame: function(id, n){
var conf = this.config;
return this.load(conf.baseDir + "php/proxy.php?url=" + conf.dgsUrlPrefix + "sgf.php?gid=" + id, n);
},

createDGSPlayer: function(){
this.setPlayer(new DGSPlayer(this));
return this;
}
});

var DGSPlayer = Class.create();
Object.extend(DGSPlayer.prototype, {
initialize: function(gameController){
this.gameController = gameController;
},

getGameId: function(){
var match_result = DGS_GAME_ID_PATTERN.exec(this.gameController.game.url);
if (match_result){
var gid = match_result[1];
return gid;
}
return null;
},

isPlayer: function(){
var c = this.gameController;
var username = c.getUsername();
return username == this.parseUsername(c.game.blackName) || username == this.parseUsername(c.game.whiteName);
},

isMyTurn: function(){
var c = this.gameController;
var username = c.getUsername();
var nextPlayerColor = c.game.getNextPlayer();
return (nextPlayerColor == STONE_BLACK && username == this.parseUsername(c.game.blackName)) ||
(nextPlayerColor == STONE_WHITE && username == this.parseUsername(c.game.whiteName));
},

parseUsername: function(s){
var i = s.indexOf('(');
var j = s.indexOf(')');
if (i >= 0 & j > i){
return s.substring(i+1, j);
} else {
return s;
}
},

sendMove: function(color, moveNumber, x, y, prevX, prevY){
var c = this.gameController;
var node = c.gameState.currentNode;
var parentNode = node.parent;
if (node.temp && (!parentNode || !parentNode.temp)){
} else {
alert("这不是你试下的第一步！");
return false;
}
var prevX = null, prevY = null;
if (parentNode){
prevX = parentNode.x;
prevY = parentNode.y;
}
var color = node.color;
var moveNumber = node.moveNumber;
var x = node.x, y = node.y;
var gid = this.getGameId(c.game.url);
if (!gid || gid.length == 0){
alert("未知DGS对局号（在对局URL中未找到gid=###，###为对局号）");
return false;
}
var url = c.config.baseDir + "php/dgs.php?command=PLAY&gid="+gid;
url += "&color=" + (color==STONE_BLACK?"B":"W");
url += "&move=" + moveNumber;
var xyToSgf = function(x,y){
if (x && x >= 0 && y && y >= 0){
return String.fromCharCode('a'.charCodeAt(0)+x, 'a'.charCodeAt(0)+y);
}
return null;
}
var sgf_move = xyToSgf.call(this, x,y);
url += "&sgf_move=" + sgf_move;
var sgf_prev = xyToSgf.call(this, prevX, prevY);
if (sgf_prev != null)
url += "&sgf_prev=" + sgf_prev;
jQuery.ajax({url: url,
success:function(response){
if (response.charAt(0) == '0'){ // success
c.refresh();
} else { // failure
c.setComment(response);
alert("操作失败！请参见棋盘右边的原始错误信息。");
}
},
error: function(XMLHttpRequest, textStatus, errorThrown){
c.setComment(textStatus + " " + errorThrown);
alert("操作失败！请参见棋盘右边的原始错误信息。");
}
});
return true;
},

resign: function(){
var c = this.gameController;
var gid = this.getGameId(c.game.url);
if (!gid || gid.length == 0){
alert("未知DGS对局号（在对局URL中未找到gid=###，###为对局号）");
return false;
}
var node = c.gameState.rootNode;
while(node.hasChildren()){
var n = node.children[0];
if (n.temp)
break;
else
node = n;
}
var moveNumber = node.moveNumber;
var url = c.config.baseDir + "php/dgs.php?command=RESIGN&gid="+gid+"&move="+moveNumber;
jQuery.ajax({url: url,
success:function(response){
if (response.charAt(0) == '0'){ // success
c.refresh();
} else { // failure
c.setComment(response);
alert("操作失败！请参见棋盘右边的原始错误信息。");
}
},
error: function(XMLHttpRequest, textStatus, errorThrown){
c.setComment(textStatus + " " + errorThrown);
alert("操作失败！请参见棋盘右边的原始错误信息。");
}
});
return true;
}
});
